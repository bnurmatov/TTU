CREATE TABLE `tbl_UserSettings` (

  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  
  `user_id` bigint(20) NOT NULL,
  
  `lesson_uuid` varchar(36) NULL,
	
  `view_index` INTEGER NOT NULL DEFAULT '0',

  `locale` varchar(10) NOT NULL DEFAULT 'tg_TJ'
);
