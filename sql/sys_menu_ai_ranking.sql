-- 排行榜管理，放在「业务管理」一级菜单下
-- 父菜单「业务管理」已存在（menu_id=2000），无需创建
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_time)
SELECT '排行榜管理', m.menu_id, 8, 'ranking', 'ai/ranking/index', 1, 0, 'C', '0', '0', 'business:ranking:list', '#', 'admin', sysdate(), sysdate()
FROM sys_menu m WHERE m.menu_name = '业务管理' AND m.menu_type = 'M';
