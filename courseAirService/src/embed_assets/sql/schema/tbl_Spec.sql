
CREATE TABLE IF NOT EXISTS `tbl_Spec` 
(
  `fID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `fSpec_Faculty` int(10) DEFAULT NULL,
  `fSpec_Name_tg_TJ` varchar(150) DEFAULT NULL,
  `fSpec_Name_ru_RU` varchar(150) DEFAULT NULL,
  `fSpec_Name_en_US` varchar(150) DEFAULT NULL,
  `fSpec_NameTajShort` varchar(30) DEFAULT NULL,
  `fSpec_NameRusShort` varchar(30) DEFAULT NULL,
  `fSpec_NameEngShort` varchar(30) DEFAULT NULL,
  `fSpec_Shifr` varchar(30) DEFAULT NULL
);


