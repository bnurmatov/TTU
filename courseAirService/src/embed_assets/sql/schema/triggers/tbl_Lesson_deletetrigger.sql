/*
 * AIR/SQLite does not support ON DELETE CASCADE. 
 * Delete all assets associated with this list. - remove user lesson mappings, and chapters.
 */
CREATE TRIGGER tbl_Lessons_deletetrigger BEFORE DELETE ON tbl_Lessons
BEGIN
  	DELETE FROM tbl_Chapters 		WHERE lesson_uuid = old.uuid AND published = old.published;
  	DELETE FROM tbl_Resources 		WHERE lesson_uuid = old.uuid AND published = old.published;
  	DELETE FROM tbl_Artifacts 		WHERE lesson_uuid = old.uuid;
   	DELETE FROM tbl_Images 			WHERE target_uuid = old.uuid;
  	DELETE FROM tbl_Sounds 			WHERE target_uuid = old.uuid;
  	DELETE FROM tbl_User_Lessons 	WHERE lessons_lesson_id = old.lesson_id;
END;