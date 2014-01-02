
CREATE TABLE IF NOT EXISTS `tbl_Spec` 
(
  `fID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `fSpec_Faculty` int(10) DEFAULT NULL,
  `fSpec_NameTaj` varchar(150) DEFAULT NULL,
  `fSpec_NameRus` varchar(150) DEFAULT NULL,
  `fSpec_NameEng` varchar(150) DEFAULT NULL,
  `fSpec_NameTajShort` varchar(30) DEFAULT NULL,
  `fSpec_NameRusShort` varchar(30) DEFAULT NULL,
  `fSpec_NameEngShort` varchar(30) DEFAULT NULL,
  `fSpec_Shifr` varchar(30) DEFAULT NULL
);


