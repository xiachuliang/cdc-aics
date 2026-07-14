-- 若依后台菜单：AI管理 > FAQ管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_time)
SELECT 'FAQ管理', m.menu_id, 4, 'faq', 'ai/faq/index', 1, 0, 'C', '0', '0', 'business:faq:list', '#', 'admin', sysdate(), sysdate()
FROM sys_menu m WHERE m.menu_name = 'AI管理' AND m.menu_type = 'M';
