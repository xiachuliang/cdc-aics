-- 若依后台菜单：AI管理 > AI评测
-- 1. 父菜单「AI管理」
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_time)
VALUES ('AI管理', 0, 9, 'ai', NULL, 1, 0, 'M', '0', '0', NULL, 'monitor', 'admin', sysdate(), sysdate());

-- 2. 子菜单「AI评测」
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_time)
SELECT 'AI评测', m.menu_id, 1, 'eval', 'ai/eval/index', 1, 0, 'C', '0', '0', 'ai:eval:list', '#', 'admin', sysdate(), sysdate()
FROM sys_menu m WHERE m.menu_name = 'AI管理' AND m.menu_type = 'M';
