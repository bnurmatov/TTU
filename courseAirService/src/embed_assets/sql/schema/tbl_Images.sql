CREATE TABLE "tbl_Images" (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
  target_uuid VARCHAR(36) NOT NULL, 
  image_url VARCHAR(255) NOT NULL, 
  original_image_url VARCHAR(255), 
  width VARCHAR(5) NOT NULL, 
  height VARCHAR(5) NOT NULL, 
  location VARCHAR(6), 
  text_position INT(10), 
  padding_left NUMERIC, 
  padding_right NUMERIC, 
  padding_top NUMERIC, 
  padding_bottom NUMERIC);