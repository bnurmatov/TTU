CREATE TABLE `tbl_Answers` (

  `answer_id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `question_uuid` VARCHAR(36) NOT NULL,
  `uuid` VARCHAR(36) NOT NULL,
  `text` CHAR(1024) DEFAULT NULL,
  `position` int(2) DEFAULT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT '0',
  
  UNIQUE (`uuid`, `answer_id`),
  CONSTRAINT `answer_question_uuid_fk` FOREIGN KEY (`question_uuid`) REFERENCES `tbl_Questions` (`uuid`) ON DELETE CASCADE

);