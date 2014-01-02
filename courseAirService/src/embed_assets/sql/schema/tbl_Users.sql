CREATE TABLE users

(
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,

  `login` varchar(64) NOT NULL UNIQUE,

  `nickname` varchar(64) UNIQUE,

  `password` varchar(64) NOT NULL,

  `role` varchar(255) NOT NULL,

  `fullName` varchar(255) DEFAULT NULL,

  `grade` varchar(255) NOT NULL DEFAULT 'REGULAR',

  `comment` varchar(255) DEFAULT NULL,

  `email` varchar(255) DEFAULT NULL,

  `languageOfInterest` varchar(128) DEFAULT NULL,

  `receiveUpdates` tinyint(1) DEFAULT '0',

  `phone` varchar(128) DEFAULT NULL,

  `gender` varchar(255) NOT NULL DEFAULT 'UNSPECIFIED',

  `studentID` varchar(64) DEFAULT NULL,

  `greetMe` tinyint(1) NOT NULL DEFAULT '1',

  `source` varchar(255) DEFAULT NULL,

  `owner` unsigned int(10) DEFAULT NULL,

  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,

  `firstTimeUser` tinyint(1) NOT NULL DEFAULT '0',

  `oldUI` tinyint(1) DEFAULT NULL,

  CONSTRAINT `user_user_fk` FOREIGN KEY (`owner`) REFERENCES `users` (`id`) ON DELETE CASCADE

);

