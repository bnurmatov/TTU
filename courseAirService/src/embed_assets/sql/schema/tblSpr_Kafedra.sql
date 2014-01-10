
CREATE TABLE IF NOT EXISTS `tblSpr_Kafedra` (
  `fKaf_Code` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `fKaf_Faculty` int(2) DEFAULT NULL,
  `fKaf_Name_tg_TJ` varchar(150) DEFAULT NULL,
  `fKaf_Name_ru_RU` varchar(150) DEFAULT NULL,
  `fKaf_Name_en_US` varchar(150) DEFAULT NULL,
  `fKaf_NameTajShort` varchar(15) DEFAULT NULL,
  `fKaf_NameRusShort` varchar(15) DEFAULT NULL,
  `fKaf_NameEngShort` varchar(15) DEFAULT NULL,
  `fKaf_ZavKafedra` varchar(150) DEFAULT NULL,
  `fKaf_Ord` int(4) DEFAULT NULL
);

