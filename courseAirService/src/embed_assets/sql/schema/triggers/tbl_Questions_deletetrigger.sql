/*
 * AIR/SQLite does not support ON DELETE CASCADE. 
 * Delete all answers associated with this question
 */
CREATE TRIGGER tbl_Questions_deletetrigger BEFORE DELETE ON tbl_Questions
BEGIN
  DELETE FROM tbl_Answers 		WHERE question_uuid = old.uuid;
END;