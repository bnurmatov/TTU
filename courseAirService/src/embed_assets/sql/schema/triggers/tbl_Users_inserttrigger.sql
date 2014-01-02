/*
 * Add settings associated with this user
 */
CREATE TRIGGER tbl_Users_inserttrigger AFTER INSERT ON users
BEGIN
INSERT INTO tbl_UserSettings(`user_id`)	VALUES(	new.id);
END;