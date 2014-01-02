
CREATE TABLE IF NOT EXISTS `tblSpr_Kafedra` (
  `fKaf_Code` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `fKaf_Faculty` int(2) DEFAULT NULL,
  `fKaf_NameTaj` varchar(150) DEFAULT NULL,
  `fKaf_NameRus` varchar(150) DEFAULT NULL,
  `fKaf_NameEng` varchar(150) DEFAULT NULL,
  `fKaf_NameTajShort` varchar(15) DEFAULT NULL,
  `fKaf_NameRusShort` varchar(15) DEFAULT NULL,
  `fKaf_NameEngShort` varchar(15) DEFAULT NULL,
  `fKaf_ZavKafedra` varchar(150) DEFAULT NULL,
  `fKaf_Ord` int(4) DEFAULT NULL
);

