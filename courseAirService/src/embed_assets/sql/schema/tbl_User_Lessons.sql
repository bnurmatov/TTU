CREATE TABLE `tbl_User_Lessons` (

  `users_user_id` bigint(20) NOT NULL,

  `lessons_lesson_id` bigint(20) NOT NULL,

  PRIMARY KEY (`users_user_id`,`lessons_lesson_id`),

  UNIQUE (`lessons_lesson_id`),

  CONSTRAINT `lesson_id_fk` FOREIGN KEY (`users_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,

  CONSTRAINT `FK84996807C73DDF7B` FOREIGN KEY (`lessons_lesson_id`) REFERENCES `tbl_Lessons` (`lesson_id`) ON DELETE CASCADE

);