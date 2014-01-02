
CREATE TABLE `tbl_Lessons` (

  `lesson_id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  
  `uuid` varchar(36) NOT NULL,
	
  `name` varchar(255) DEFAULT NULL,
  
  `description` varchar(255) DEFAULT NULL,

  `appcreator_name` varchar(255) DEFAULT NULL,

  `creator` varchar(255) DEFAULT NULL,
  
  `about_creator` varchar(255) DEFAULT NULL,

  `creator_url` varchar(255) DEFAULT NULL,

  `creation_date` datetime DEFAULT NULL,
  
  `last_modified_date` datetime DEFAULT NULL,

  `departmentId` INTEGER NOT NULL,
  
  `specialityId` INTEGER NOT NULL,
  
  `discipline` varchar(255) DEFAULT NULL,
  
  `list_state` varchar(255) NOT NULL,

  `visibility` varchar(7) NOT NULL,
  
  `ordered` bit(1) NOT NULL,

  `lesson_version` bigint(20) DEFAULT NULL,
  
  `changed` tinyint(1) NOT NULL DEFAULT '1',

  `published` tinyint(1) NOT NULL DEFAULT '0',
  
  `view_index` INTEGER NOT NULL,
  
  `max_active_view_index` INTEGER NOT NULL,
  
  `locale` varchar(10) NOT NULL,

  UNIQUE (`uuid`, `published`),

  UNIQUE (`name`,`departmentId`,`specialityId`, `discipline`, `published`)

);
