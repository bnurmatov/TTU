CREATE TABLE `tbl_Chapters` (

  `chapter_id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `lesson_uuid` VARCHAR(36) NOT NULL,
  `uuid` VARCHAR(36) NOT NULL,
  `chapter_title` VARCHAR(255) DEFAULT NULL,
  `chapter_text` CLOB DEFAULT NULL,
  `chapter_comment` VARCHAR(255) DEFAULT NULL,
  `creation_date` DATETIME DEFAULT NULL,
  `last_modified_date` DATETIME DEFAULT NULL,
  `chapter_position` INT(11) NOT NULL,
  `published` TINYINT(1) NOT NULL DEFAULT '0',
  `version` INT(11) NOT NULL,
  
  UNIQUE (`uuid`, `published`),
  CONSTRAINT `chapter_lesson_uuid_fk` FOREIGN KEY (`lesson_uuid`) REFERENCES `tbl_Lessons` (`uuid`) ON DELETE CASCADE

);
