-- 若依后台菜单：AI管理 > 对话日志
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_time)
SELECT '对话日志', m.menu_id, 2, 'chatlog', 'ai/eval/chatlog', 1, 0, 'C', '0', '0', 'ai:chatlog:list', '#', 'admin', sysdate(), sysdate()
FROM sys_menu m WHERE m.menu_name = 'AI管理' AND m.menu_type = 'M';
