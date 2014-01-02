CREATE TABLE `tbl_Resources` (

  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `lesson_uuid` VARCHAR(36) NOT NULL,
  `resource_uuid` VARCHAR(36) NOT NULL,
  `resource_title` VARCHAR(255) DEFAULT NULL,
  `resource_url` VARCHAR(255) DEFAULT NULL,
  `resource_path` VARCHAR(255) DEFAULT NULL,
  `resource_comment` VARCHAR(255) DEFAULT NULL,
  `resouce_type` VARCHAR(36) DEFAULT NULL,
  `resource_position` INT(11) NOT NULL,
  `published` TINYINT(1) NOT NULL DEFAULT '0',
  `version` INT(11) NOT NULL,
  
  UNIQUE (`resource_uuid`, `id`),
  CONSTRAINT `resource_lesson_uuid_fk` FOREIGN KEY (`lesson_uuid`) REFERENCES `tbl_Lessons` (`uuid`) ON DELETE CASCADE

);
