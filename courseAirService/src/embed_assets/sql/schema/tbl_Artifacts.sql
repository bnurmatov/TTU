CREATE TABLE `tbl_Artifacts` (

  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `lesson_uuid` VARCHAR(36) NOT NULL,
  `artifact_url` VARCHAR(255) DEFAULT NULL,
  `artifact_type` VARCHAR(36) DEFAULT NULL,
  
  UNIQUE (`id`),
  CONSTRAINT `resource_lesson_uuid_fk` FOREIGN KEY (`lesson_uuid`) REFERENCES `tbl_Lessons` (`uuid`) ON DELETE CASCADE
);