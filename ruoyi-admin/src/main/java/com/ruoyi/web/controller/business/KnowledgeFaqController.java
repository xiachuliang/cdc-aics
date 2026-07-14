package com.ruoyi.web.controller.business;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.business.domain.KnowledgeFaq;
import com.ruoyi.business.service.IKnowledgeFaqService;

/**
 * FAQ 知识库管理
 *
 * @author cdc-aics
 */
@RestController
@RequestMapping("/business/faq")
public class KnowledgeFaqController extends BaseController {

    @Autowired
    private IKnowledgeFaqService faqService;

    /** 列表 */
    @PreAuthorize("@ss.hasPermi('business:faq:list')")
    @GetMapping("/list")
    public TableDataInfo list(KnowledgeFaq faq) {
        startPage();
        return getDataTable(faqService.selectList(faq));
    }

    /** 详情 */
    @PreAuthorize("@ss.hasPermi('business:faq:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id) {
        return success(faqService.selectById(id));
    }

    /** 新增 → @FaqSync(Action.INSERT) → AOP 自动向量化 */
    @PreAuthorize("@ss.hasPermi('business:faq:add')")
    @Log(title = "FAQ管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody KnowledgeFaq faq) {
        faq.setCreateBy(getUsername());
        return toAjax(faqService.insert(faq));
    }

    /** 修改 → @FaqSync(Action.UPDATE) → AOP 自动更新向量 */
    @PreAuthorize("@ss.hasPermi('business:faq:edit')")
    @Log(title = "FAQ管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody KnowledgeFaq faq) {
        faq.setUpdateBy(getUsername());
        return toAjax(faqService.update(faq));
    }

    /** 删除 → @FaqSync(Action.DELETE) → AOP 自动删向量 */
    @PreAuthorize("@ss.hasPermi('business:faq:remove')")
    @Log(title = "FAQ管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public AjaxResult remove(@PathVariable Long id) {
        faqService.deleteById(id);
        return success();
    }

    /** 导出 Excel 模板 */
    @PreAuthorize("@ss.hasPermi('business:faq:import')")
    @GetMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<KnowledgeFaq> util = new ExcelUtil<>(KnowledgeFaq.class);
        util.importTemplateExcel(response, "FAQ数据");
    }

    /** 批量导入 → 每条 insert 都走 @FaqSync → AOP 自动向量化 */
    @PreAuthorize("@ss.hasPermi('business:faq:import')")
    @Log(title = "FAQ管理", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file) throws Exception {
        ExcelUtil<KnowledgeFaq> util = new ExcelUtil<>(KnowledgeFaq.class);
        List<KnowledgeFaq> list = util.importExcel(file.getInputStream());
        String msg = faqService.importFaqs(list, getUsername());
        return success(msg);
    }
}
