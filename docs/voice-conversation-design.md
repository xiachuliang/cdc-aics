# 持续实时语音对话功能设计方案

## 用户需求

点击语音按钮进入持续对话模式：
1. 一直听用户说话，持续对话，不需要反复点按钮
2. AI 用语音回复（TTS）
3. **智能打断**：AI 说话途中用户插话 → RouterService 意图分类 → 判断是否打断

## 核心思路

**复用现有 RouterService 做打断决策，不加新的判断器。**

打断逻辑一句说完：RouterService 分类出新消息是 CHITCHAT（"嗯好的"）→ 不打断，排队；分类出其他意图（新需求/纠正/操作）→ 打断当前 Agent，路由给新 Agent。

```
新语音 → ASR → RouterService.classify()
  → CHITCHAT 且当前 Agent 正在回复 → 排队，等说完
  → 其他意图 → 检查 Agent 是否忙
     → 忙 → cancel() 当前流 → 路由给新 Agent
     → 闲 → 正常路由
```

## 技术选型

### ASR（语音→文字）
DashScope `fun-asr-flash`。模式同 ImageAnalysisService：`RestClient` + base64 音频 + Map 构造请求。

### TTS（文字→语音）
DashScope `cosyvoice-v3.5-flash`，同步接口返回 MP3 字节。音色：`zhixiaobai`。

### 打断策略（无需新 LLM 调用）
直接复用 `RouterService.classify()` 的结果：
- `CHITCHAT` → 排队（附和/确认，不需要打断）
- `CONSULTATION / OPERATION / ANALYTICS` → 打断（用户有新的实质需求）

---

## 实现方案

### 一、后端

#### 1. 新建 `voice/VoiceService.java`

纯语音工具，只管 ASR + TTS，**不管打断**：

```java
@Service
public class VoiceService {
    public String speechToText(byte[] audioBytes, String format) { ... }
    public byte[] textToSpeech(String text) { ... }
}
```

#### 2. 修改 `ChatOrchestrator.java` — 支持取消

关键改动：加一个 `AtomicReference<FluxSink>` 或 `AtomicBoolean`，暴露 `cancel()` 方法。

```java
public class ChatOrchestrator implements IChatService {

    // 当前正在执行的 Agent 流（用于打断）
    private final AtomicReference<FluxSink<String>> currentSink = new AtomicReference<>();

    /** 打断当前正在执行的 Agent */
    public void interrupt() {
        FluxSink<String> sink = currentSink.get();
        if (sink != null && !sink.isCancelled()) {
            sink.complete();  // 强制结束当前流
        }
    }

    /** 检查是否有 Agent 正在回复 */
    public boolean isBusy() {
        FluxSink<String> sink = currentSink.get();
        return sink != null && !sink.isCancelled();
    }

    // chatStream() 中设置 sink：
    // .doOnSubscribe(s -> currentSink.set(sink))
    // .doFinally(s -> currentSink.set(null))
}
```

> 或者更简单：用 `Flux.takeUntilOther(Mono)` 配合外部信号取消，避免直接操作 FluxSink。

#### 3. 修改 `ChatController.java` — 新增语音端点

**只加 3 个端点**（不需要打断判断端点）：

| 端点 | 入参 | 返回 | 说明 |
|------|------|------|------|
| `POST /ai/voice/asr` | `@RequestParam file` | `AjaxResult { text }` | 音频→文字 |
| `POST /ai/voice/tts` | `@RequestBody { text }` | `byte[]` audio/mpeg | 文字→MP3 |
| `POST /ai/voice/chat` | `@RequestParam file` + `@RequestParam sessionId` + `@RequestParam(required=false) interrupt` | `AjaxResult { asrText, answer, audioBase64, products..., interrupted }` | 核心：ASR→Router→可能打断→Agent→TTS |

**`POST /ai/voice/chat` 的流程：**

```java
@PostMapping("/voice/chat")
public AjaxResult voiceChat(
        @RequestParam("file") MultipartFile file,
        @RequestParam("sessionId") String sessionId,
        @RequestParam(value = "interrupt", defaultValue = "true") boolean interrupt) {

    // 1. ASR
    String text = voiceService.speechToText(file.getBytes(), ...);

    // 2. 意图分类（复用 RouterService） 
    IntentResult result = routerService.classify(text);

    // 3. 打断逻辑：非闲聊 → 打断当前 Agent
    boolean interrupted = false;
    if (interrupt && result.getIntent() != Intent.CHITCHAT && orchestrator.isBusy()) {
        orchestrator.interrupt();
        interrupted = true;
    }

    // 4. 路由给对应 Agent（走 ChatOrchestrator 同步方法）
    //    （被打断后，Agent 已经是空闲状态，直接路由）
    ChatResult cr = orchestrator.chat(sessionId, text);

    // 5. TTS
    byte[] audio = voiceService.textToSpeech(cr.getAnswer());

    // 6. 返回
    data.put("asrText", text);
    data.put("answer", cr.getAnswer());
    data.put("audioBase64", Base64.getEncoder().encodeToString(audio));
    data.put("interrupted", interrupted);
    ...
}
```

**打断流程示意：**
```
前端仍在播放上一轮 AI 的音频
  → 用户说话（VAD 检测到）→ 收集音频
  → POST /ai/voice/chat (interrupt=true)
  → RouterService.classify("不对我要零食") → OPERATION
  → OPERATION ≠ CHITCHAT → orchestrator.interrupt() → 取消当前流
  → orchestrator.chat(sessionId, "不对我要零食") → 新回复
  → TTS → 返回新音频 + interrupted=true
  → 前端收到 interrupted=true → 停止播放旧音频 → 播放新音频
```

---

### 二、前端

#### 1. 语音模式入口

输入区加麦克风按钮：
```
[📷] [🎤] [___输入框___] [发送]
```
点击麦克风切换语音模式，再次点击或手动退出。

#### 2. VAD 静音检测（Web Audio API）

- `getUserMedia({ audio: true })` 获取麦克风
- `AnalyserNode` 实时监测音量
- 音量 > 阈值 → 正在说话
- 静音 > 800ms → 认为说完，发送音频
- `MediaRecorder` 录制，静音时停止并发送

#### 3. 对话状态机

```
IDLE → 检测到语音 → LISTENING
LISTENING → 静音够了 → THINKING（发音频到后端）
THINKING → 收到回复 → SPEAKING（播放音频 + 显示文字）
SPEAKING → 音频播完 → IDLE

SPEAKING 中检测到语音 →
  收完一段 → THINKING（interrupt=true）
  后端判断是否打断 →
    打断了 → SPEAKING（新音频替换旧音频）
    没打断 → 排队 → 等当前音频结束 → SPEAKING（播排队消息）
```

#### 4. 音频播放与打断

```javascript
let currentAudio = null

async function handleVoiceResponse(data) {
  // 被打断了 → 停播旧音频
  if (data.interrupted && currentAudio) {
    currentAudio.pause()
    currentAudio = null
  }

  // 显示文字（走现有消息渲染）
  messages.value.push({ role: 'ai', content: data.answer, products: data.products || [] })

  // 播放新音频
  const audio = new Audio('data:audio/mp3;base64,' + data.audioBase64)
  currentAudio = audio
  audio.onended = () => { currentAudio = null }
  audio.play()
}
```

---

### 三、涉及文件

| 操作 | 文件 | 说明 |
|------|------|------|
| **新建** | `cdc-aics-ai/.../voice/VoiceService.java` | ASR + TTS（纯工具，无打断逻辑）|
| **修改** | `cdc-aics-ai/.../chat/ChatOrchestrator.java` | 加 `interrupt()` + `isBusy()` |
| **修改** | `cdc-aics-ai/.../chat/ChatController.java` | 加 3 个语音端点 |
| **修改** | `ruoyi-ui/src/views/portal/index.vue` | 语音按钮 + VAD + 音频播放 + 打断 |
| **修改** | `ruoyi-ui/src/api/portal/index.js` | 加语音 API |

**不需要新建的文件**：
- ~~`InterruptResult.java`~~ → 不需要
- ~~独立的打断判断 Service~~ → RouterService 已做
- ~~独立的 `VoiceController.java`~~ → 端点少，加在 ChatController 就行

---

### 四、验证方式

1. 正常语音对话：说话 → 听到 AI 语音回复 → 看到文字
2. 打断测试：AI 播放语音时说"不对我要找零食" → 旧音频停止 → 新回复开始
3. 不打断测试：AI 播放语音时说"嗯好的" → 旧音频继续 → 不打断
