/*
 * AIR/SQLite does not support ON DELETE CASCADE. 
 * Delete all assets associated with this chapter
 */
CREATE TRIGGER tbl_Chapters_deletetrigger BEFORE DELETE ON tbl_Chapters
BEGIN
  DELETE FROM tbl_Images 		WHERE target_uuid = old.uuid;
  DELETE FROM tbl_Sounds 		WHERE target_uuid = old.uuid;
  DELETE FROM tbl_Video  		WHERE target_uuid = old.uuid;
  DELETE FROM tbl_Questions  	WHERE chapter_uuid = old.uuid;
END;