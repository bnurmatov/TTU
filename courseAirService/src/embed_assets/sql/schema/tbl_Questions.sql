CREATE TABLE `tbl_Questions` (

  `question_id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `chapter_uuid` VARCHAR(36) NOT NULL,
  `uuid` VARCHAR(36) NOT NULL,
  `text` CHAR(1024) DEFAULT NULL,
  `incorrect_answer_hint` VARCHAR(255) DEFAULT NULL,
  
  UNIQUE (`uuid`, `question_id`),
  CONSTRAINT `question_chapter_uuid_fk` FOREIGN KEY (`chapter_uuid`) REFERENCES `tbl_Chapters` (`uuid`) ON DELETE CASCADE

);