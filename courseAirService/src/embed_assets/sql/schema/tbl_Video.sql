CREATE TABLE "tbl_Video" (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
  target_uuid VARCHAR(36) NOT NULL, 
  video_url VARCHAR(255) NOT NULL, 
  location VARCHAR(6), 
  text_position INT(10), 
  padding_left NUMERIC, 
  padding_right NUMERIC, 
  padding_top NUMERIC, 
  padding_bottom NUMERIC);