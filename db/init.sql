
DROP TABLE IF EXISTS file_format;
CREATE TABLE file_format (
	id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	name varchar(255) DEFAULT NULL,
	format json DEFAULT NULL,
	PRIMARY KEY (id)
)
ENGINE = INNODB,
AVG_ROW_LENGTH = 2048,
ROW_FORMAT = DYNAMIC;


DROP TABLE IF EXISTS file_links;
CREATE TABLE file_links (
	id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	file_url varchar(255) NOT NULL,
	load_type varchar(255) DEFAULT NULL,
	reprot_dt date DEFAULT NULL,
	id_file_format int(11) DEFAULT NULL,
	PRIMARY KEY (id)
)
ENGINE = INNODB,
AVG_ROW_LENGTH = 8192,
ROW_FORMAT = DYNAMIC;


DROP TABLE IF EXISTS file_load_log;
CREATE TABLE file_load_log (
	id_file int(10) UNSIGNED NOT NULL,
	load_status varchar(255) NOT NULL,
	dt datetime DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id_file)
)
ENGINE = INNODB,
AVG_ROW_LENGTH = 84,
ROW_FORMAT = DYNAMIC;


DROP TABLE IF EXISTS sa_old_type_2;
CREATE TABLE sa_old_type_2 (
	id_file int(10) UNSIGNED DEFAULT NULL,
	ID_NUMBER varchar(255) DEFAULT NULL,
	NAME varchar(255) DEFAULT NULL,
	TITLE varchar(255) DEFAULT NULL,
	COUNTRY varchar(255) DEFAULT NULL,
	RAITING varchar(255) DEFAULT NULL,
	GAMES varchar(255) DEFAULT NULL,
	BIRTHDAY varchar(255) DEFAULT NULL,
	FLAG varchar(255) DEFAULT NULL
)
ENGINE = INNODB,
AVG_ROW_LENGTH = 78,
ROW_FORMAT = DYNAMIC;

ALTER TABLE sa_old_type_2
ADD INDEX id_file (id_file);

ALTER TABLE sa_old_type_2
ADD INDEX ID_NUMBER (ID_NUMBER);

ALTER TABLE sa_old_type_2
ADD INDEX NAME (NAME);

DROP TABLE IF EXISTS sa_standart;
CREATE TABLE sa_standart (
	id_file int(10) UNSIGNED DEFAULT NULL,
	ID_NUMBER varchar(255) DEFAULT NULL,
	NAME varchar(255) DEFAULT NULL,
	COUNTRY varchar(255) DEFAULT NULL,
	SEX varchar(255) DEFAULT NULL,
	TITLE varchar(255) DEFAULT NULL,
	WTITLE varchar(255) DEFAULT NULL,
	OTITLE varchar(255) DEFAULT NULL,
	FOA varchar(255) DEFAULT NULL,
	RAITING varchar(255) DEFAULT NULL,
	GAMES varchar(255) DEFAULT NULL,
	KFACTOR varchar(255) DEFAULT NULL,
	BIRTHDAY varchar(255) DEFAULT NULL,
	FLAG varchar(255) DEFAULT NULL
)
ENGINE = INNODB,
AVG_ROW_LENGTH = 81,
ROW_FORMAT = DYNAMIC;

ALTER TABLE sa_standart
ADD INDEX id_file (id_file);

ALTER TABLE sa_standart
ADD INDEX ID_NUMBER (ID_NUMBER);

ALTER TABLE sa_standart
ADD INDEX NAME (NAME);

USE chessbi;

INSERT INTO file_format (id, name, format) VALUES
(1, 'old_type_2_without_bday', '{"columns": [{"name": "ID_NUMBER", "position": 0}, {"name": "NAME", "position": 12}, {"name": "TITLE", "position": 45}, {"name": "COUNTRY", "position": 51}, {"name": "RAITING", "position": 59}, {"name": "GAMES", "position": 66}, {"name": "BIRTHDAY", "position": null}, {"name": "FLAG", "position": 71}], "encoding": "unicode_escape", "skip_lines": 1}'),
(2, 'old_type_2', '{"columns": [{"name": "ID_NUMBER", "position": 0}, {"name": "NAME", "position": 12}, {"name": "TITLE", "position": 45}, {"name": "COUNTRY", "position": 51}, {"name": "RAITING", "position": 59}, {"name": "GAMES", "position": 66}, {"name": "BIRTHDAY", "position": 71}, {"name": "FLAG", "position": 80}], "encoding": "unicode_escape", "skip_lines": 1}'),
(3, 'old_type_2_2', '{"columns": [{"name": "ID_NUMBER", "position": 0}, {"name": "NAME", "position": 10}, {"name": "TITLE", "position": 43}, {"name": "COUNTRY", "position": 48}, {"name": "RAITING", "position": 53}, {"name": "GAMES", "position": 58}, {"name": "BIRTHDAY", "position": 63}, {"name": "FLAG", "position": 74}], "encoding": "unicode_escape", "skip_lines": 1}'),
(4, 'old_type_2_3', '{"columns": [{"name": "ID_NUMBER", "position": 0}, {"name": "NAME", "position": 10}, {"name": "TITLE", "position": 43}, {"name": "COUNTRY", "position": 46}, {"name": "RAITING", "position": 53}, {"name": "GAMES", "position": 59}, {"name": "BIRTHDAY", "position": 64}, {"name": "FLAG", "position": 73}], "encoding": "unicode_escape", "skip_lines": 0}'),
(5, 'old_type_2_4', '{"columns": [{"name": "ID_NUMBER", "position": 0}, {"name": "NAME", "position": 10}, {"name": "TITLE", "position": 43}, {"name": "COUNTRY", "position": 46}, {"name": "RAITING", "position": 51}, {"name": "GAMES", "position": 57}, {"name": "BIRTHDAY", "position": 62}, {"name": "FLAG", "position": 70}], "encoding": "unicode_escape", "skip_lines": 2}'),
(6, 'old_type_2_5', '{"columns": [{"name": "ID_NUMBER", "position": 0}, {"name": "NAME", "position": 10}, {"name": "TITLE", "position": 43}, {"name": "COUNTRY", "position": 46}, {"name": "RAITING", "position": 51}, {"name": "GAMES", "position": 57}, {"name": "BIRTHDAY", "position": 62}, {"name": "FLAG", "position": 70}], "encoding": "unicode_escape", "skip_lines": 1}'),
(7, 'standart_1', '{"columns": [{"name": "ID_NUMBER", "position": 0}, {"name": "NAME", "position": 14}, {"name": "COUNTRY", "position": 73}, {"name": "SEX", "position": 80}, {"name": "TITLE", "position": 84}, {"name": "WTITLE", "position": 89}, {"name": "OTITLE", "position": 94}, {"name": "FOA", "position": null}, {"name": "RAITING", "position": 109}, {"name": "GAMES", "position": 115}, {"name": "KFACTOR", "position": 119}, {"name": "BIRTHDAY", "position": 122}, {"name": "FLAG", "position": 128}], "encoding": "unicode_escape", "skip_lines": 1}'),
(8, 'standart_2', '{"columns": [{"name": "ID_NUMBER", "position": 0}, {"name": "NAME", "position": 14}, {"name": "COUNTRY", "position": 73}, {"name": "SEX", "position": 80}, {"name": "TITLE", "position": 84}, {"name": "WTITLE", "position": 89}, {"name": "OTITLE", "position": 94}, {"name": "FOA", "position": 109}, {"name": "RAITING", "position": 113}, {"name": "GAMES", "position": 119}, {"name": "KFACTOR", "position": 123}, {"name": "BIRTHDAY", "position": 126}, {"name": "FLAG", "position": 131}], "encoding": "unicode_escape", "skip_lines": 1}');

USE chessbi;

INSERT INTO file_links (id, file_url, load_type, reprot_dt, id_file_format) VALUES
(1, 'https://www.mark-weeks.com/chess/ratings/1975-01.zip', 'old_type', NULL, NULL),
(2, 'https://www.mark-weeks.com/chess/ratings/1976-01.zip', 'old_type', NULL, NULL),
(3, 'https://www.mark-weeks.com/chess/ratings/1977-01.zip', 'old_type', NULL, NULL),
(4, 'https://www.mark-weeks.com/chess/ratings/1978-01.zip', 'old_type', NULL, NULL),
(5, 'https://www.mark-weeks.com/chess/ratings/1979-01.zip', 'old_type', NULL, NULL),
(6, 'https://www.mark-weeks.com/chess/ratings/1980-01.zip', 'old_type', NULL, NULL),
(7, 'https://www.mark-weeks.com/chess/ratings/1981-01.zip', 'old_type', NULL, NULL),
(8, 'https://www.mark-weeks.com/chess/ratings/1982-01.zip', 'old_type', NULL, NULL),
(9, 'https://www.mark-weeks.com/chess/ratings/1983-01.zip', 'old_type', NULL, NULL),
(10, 'https://www.mark-weeks.com/chess/ratings/1984-01.zip', 'old_type', NULL, NULL),
(11, 'https://www.mark-weeks.com/chess/ratings/1985-01.zip', 'old_type', NULL, NULL),
(12, 'https://www.mark-weeks.com/chess/ratings/1986-01.zip', 'old_type', NULL, NULL),
(13, 'https://www.mark-weeks.com/chess/ratings/1987-01.zip', 'old_type', NULL, NULL),
(14, 'https://www.mark-weeks.com/chess/ratings/1988-01.zip', 'old_type', NULL, NULL),
(15, 'https://www.mark-weeks.com/chess/ratings/1989-01.zip', 'old_type', NULL, NULL),
(16, 'https://www.mark-weeks.com/chess/ratings/1990-01.zip', 'old_type', NULL, NULL),
(17, 'https://www.mark-weeks.com/chess/ratings/1991-01.zip', 'old_type', NULL, NULL),
(18, 'https://www.mark-weeks.com/chess/ratings/1992-01.zip', 'old_type', NULL, NULL),
(19, 'https://www.mark-weeks.com/chess/ratings/1993-01.zip', 'old_type', NULL, NULL),
(20, 'https://www.mark-weeks.com/chess/ratings/1994-01.zip', 'old_type', NULL, NULL),
(21, 'https://www.mark-weeks.com/chess/ratings/1995-01.zip', 'old_type', NULL, NULL),
(22, 'https://www.mark-weeks.com/chess/ratings/1996-01.zip', 'old_type', NULL, NULL),
(23, 'https://www.mark-weeks.com/chess/ratings/1997-01.zip', 'old_type', NULL, NULL),
(24, 'https://www.mark-weeks.com/chess/ratings/1998-01.zip', 'old_type', NULL, NULL),
(25, 'https://www.mark-weeks.com/chess/ratings/1999-01.zip', 'old_type', NULL, NULL),
(26, 'https://www.mark-weeks.com/chess/ratings/2000-01.zip', 'old_type', NULL, NULL),
(27, 'https://www.mark-weeks.com/chess/ratings/1971.zip', 'old_type', NULL, NULL),
(28, 'https://www.mark-weeks.com/chess/ratings/1972.zip', 'old_type', NULL, NULL),
(29, 'https://www.mark-weeks.com/chess/ratings/1973.zip', 'old_type', NULL, NULL),
(30, 'https://www.mark-weeks.com/chess/ratings/1974.zip', 'old_type', NULL, NULL),
(31, 'https://www.mark-weeks.com/chess/ratings/1990-07.zip', 'old_type', NULL, NULL),
(32, 'https://www.mark-weeks.com/chess/ratings/1991-07.zip', 'old_type', NULL, NULL),
(33, 'https://www.mark-weeks.com/chess/ratings/1992-07.zip', 'old_type', NULL, NULL),
(34, 'https://www.mark-weeks.com/chess/ratings/1993-07.zip', 'old_type', NULL, NULL),
(35, 'https://www.mark-weeks.com/chess/ratings/1994-07.zip', 'old_type', NULL, NULL),
(36, 'https://www.mark-weeks.com/chess/ratings/1995-07.zip', 'old_type', NULL, NULL),
(37, 'https://www.mark-weeks.com/chess/ratings/1996-07.zip', 'old_type', NULL, NULL),
(38, 'https://www.mark-weeks.com/chess/ratings/1997-07.zip', 'old_type', NULL, NULL),
(39, 'https://www.mark-weeks.com/chess/ratings/1998-07.zip', 'old_type', NULL, NULL),
(40, 'https://www.mark-weeks.com/chess/ratings/1999-07.zip', 'old_type', NULL, NULL),
(41, 'https://www.mark-weeks.com/chess/ratings/2000-07.zip', 'old_type', NULL, NULL),
(42, 'http://ratings.fide.com/download/jan01frl.zip', 'old_type_2', '2001-01-01', 1),
(43, 'http://ratings.fide.com/download/jan02frl.zip', 'old_type_2', '2002-01-01', 2),
(44, 'http://ratings.fide.com/download/jan03frl.zip', 'old_type_2', '2003-01-01', 3),
(45, 'http://ratings.fide.com/download/jan04frl.zip', 'old_type_2', '2004-01-01', 4),
(46, 'http://ratings.fide.com/download/jan05frl.zip', 'old_type_2', '2005-01-01', 3),
(47, 'http://ratings.fide.com/download/jan06frl.zip', 'old_type_2', '2006-01-01', 5),
(48, 'http://ratings.fide.com/download/jan07frl.zip', 'old_type_2', '2007-01-01', 6),
(49, 'http://ratings.fide.com/download/jan08frl.zip', 'old_type_2', '2008-01-01', 6),
(50, 'http://ratings.fide.com/download/jan09frl.zip', 'old_type_2', '2009-01-01', 6),
(51, 'http://ratings.fide.com/download/jan10frl.zip', 'old_type_2', '2010-01-01', 6),
(52, 'http://ratings.fide.com/download/jan11frl.zip', 'old_type_2', '2011-01-01', 6),
(53, 'http://ratings.fide.com/download/jan12frl.zip', 'old_type_2', '2012-01-01', 6),
(54, 'http://ratings.fide.com/download/standard_jan13frl.zip', 'standart', '2013-01-01', 7),
(55, 'http://ratings.fide.com/download/standard_feb13frl.zip', 'standart', '2013-02-01', 7),
(56, 'http://ratings.fide.com/download/standard_mar13frl.zip', 'standart', '2013-03-01', 7),
(57, 'http://ratings.fide.com/download/standard_apr13frl.zip', 'standart', '2013-04-01', 7),
(58, 'http://ratings.fide.com/download/standard_may13frl.zip', 'standart', '2013-05-01', 7),
(59, 'http://ratings.fide.com/download/standard_jun13frl.zip', 'standart', '2013-06-01', 7),
(60, 'http://ratings.fide.com/download/standard_jul13frl.zip', 'standart', '2013-07-01', 7),
(61, 'http://ratings.fide.com/download/standard_aug13frl.zip', 'standart', '2013-08-01', 7),
(62, 'http://ratings.fide.com/download/standard_sep13frl.zip', 'standart', '2013-09-01', 7),
(63, 'http://ratings.fide.com/download/standard_oct13frl.zip', 'standart', '2013-10-01', 7),
(64, 'http://ratings.fide.com/download/standard_nov13frl.zip', 'standart', '2013-11-01', 7),
(65, 'http://ratings.fide.com/download/standard_dec13frl.zip', 'standart', '2013-12-01', 7),
(66, 'http://ratings.fide.com/download/standard_jan14frl.zip', 'standart', '2014-01-01', 7),
(67, 'http://ratings.fide.com/download/standard_feb14frl.zip', 'standart', '2014-02-01', 7),
(68, 'http://ratings.fide.com/download/standard_mar14frl.zip', 'standart', '2014-03-01', 7),
(69, 'http://ratings.fide.com/download/standard_apr14frl.zip', 'standart', '2014-04-01', 7),
(70, 'http://ratings.fide.com/download/standard_may14frl.zip', 'standart', '2014-05-01', 7),
(71, 'http://ratings.fide.com/download/standard_jun14frl.zip', 'standart', '2014-06-01', 7),
(72, 'http://ratings.fide.com/download/standard_jul14frl.zip', 'standart', '2014-07-01', 7),
(73, 'http://ratings.fide.com/download/standard_aug14frl.zip', 'standart', '2014-08-01', 7),
(74, 'http://ratings.fide.com/download/standard_sep14frl.zip', 'standart', '2014-09-01', 7),
(75, 'http://ratings.fide.com/download/standard_oct14frl.zip', 'standart', '2014-10-01', 7),
(76, 'http://ratings.fide.com/download/standard_nov14frl.zip', 'standart', '2014-11-01', 7),
(77, 'http://ratings.fide.com/download/standard_dec14frl.zip', 'standart', '2014-12-01', 7),
(78, 'http://ratings.fide.com/download/standard_jan15frl.zip', 'standart', '2015-01-01', 7),
(79, 'http://ratings.fide.com/download/standard_feb15frl.zip', 'standart', '2015-02-01', 7),
(80, 'http://ratings.fide.com/download/standard_mar15frl.zip', 'standart', '2015-03-01', 7),
(81, 'http://ratings.fide.com/download/standard_apr15frl.zip', 'standart', '2015-04-01', 7),
(82, 'http://ratings.fide.com/download/standard_may15frl.zip', 'standart', '2015-05-01', 7),
(83, 'http://ratings.fide.com/download/standard_jun15frl.zip', 'standart', '2015-06-01', 7),
(84, 'http://ratings.fide.com/download/standard_jul15frl.zip', 'standart', '2015-07-01', 7),
(85, 'http://ratings.fide.com/download/standard_aug15frl.zip', 'standart', '2015-08-01', 7),
(86, 'http://ratings.fide.com/download/standard_sep15frl.zip', 'standart', '2015-09-01', 7),
(87, 'http://ratings.fide.com/download/standard_oct15frl.zip', 'standart', '2015-10-01', 7),
(88, 'http://ratings.fide.com/download/standard_nov15frl.zip', 'standart', '2015-11-01', 7),
(89, 'http://ratings.fide.com/download/standard_dec15frl.zip', 'standart', '2015-12-01', 7),
(90, 'http://ratings.fide.com/download/standard_jan16frl.zip', 'standart', '2016-01-01', 7),
(91, 'http://ratings.fide.com/download/standard_feb16frl.zip', 'standart', '2016-02-01', 7),
(92, 'http://ratings.fide.com/download/standard_mar16frl.zip', 'standart', '2016-03-01', 7),
(93, 'http://ratings.fide.com/download/standard_apr16frl.zip', 'standart', '2016-04-01', 7),
(94, 'http://ratings.fide.com/download/standard_may16frl.zip', 'standart', '2016-05-01', 7),
(95, 'http://ratings.fide.com/download/standard_jun16frl.zip', 'standart', '2016-06-01', 7),
(96, 'http://ratings.fide.com/download/standard_jul16frl.zip', 'standart', '2016-07-01', 7),
(97, 'http://ratings.fide.com/download/standard_aug16frl.zip', 'standart', '2016-08-01', 7),
(98, 'http://ratings.fide.com/download/standard_sep16frl.zip', 'standart', '2016-09-01', 8),
(99, 'http://ratings.fide.com/download/standard_oct16frl.zip', 'standart', '2016-10-01', 8),
(100, 'http://ratings.fide.com/download/standard_nov16frl.zip', 'standart', '2016-11-01', 8),
(101, 'http://ratings.fide.com/download/standard_dec16frl.zip', 'standart', '2016-12-01', 8),
(102, 'http://ratings.fide.com/download/standard_jan17frl.zip', 'standart', '2017-01-01', 8),
(103, 'http://ratings.fide.com/download/standard_feb17frl.zip', 'standart', '2017-02-01', 8),
(104, 'http://ratings.fide.com/download/standard_mar17frl.zip', 'standart', '2017-03-01', 8),
(105, 'http://ratings.fide.com/download/standard_apr17frl.zip', 'standart', '2017-04-01', 8),
(106, 'http://ratings.fide.com/download/standard_may17frl.zip', 'standart', '2017-05-01', 8),
(107, 'http://ratings.fide.com/download/standard_jun17frl.zip', 'standart', '2017-06-01', 8),
(108, 'http://ratings.fide.com/download/standard_jul17frl.zip', 'standart', '2017-07-01', 8),
(109, 'http://ratings.fide.com/download/standard_aug17frl.zip', 'standart', '2017-08-01', 8),
(110, 'http://ratings.fide.com/download/standard_sep17frl.zip', 'standart', '2017-09-01', 8),
(111, 'http://ratings.fide.com/download/standard_oct17frl.zip', 'standart', '2017-10-01', 8),
(112, 'http://ratings.fide.com/download/standard_nov17frl.zip', 'standart', '2017-11-01', 8),
(113, 'http://ratings.fide.com/download/standard_dec17frl.zip', 'standart', '2017-12-01', 8),
(114, 'http://ratings.fide.com/download/standard_jan18frl.zip', 'standart', '2018-01-01', 8),
(115, 'http://ratings.fide.com/download/standard_feb18frl.zip', 'standart', '2018-02-01', 8),
(116, 'http://ratings.fide.com/download/standard_mar18frl.zip', 'standart', '2018-03-01', 8),
(117, 'http://ratings.fide.com/download/standard_apr18frl.zip', 'standart', '2018-04-01', 8),
(118, 'http://ratings.fide.com/download/standard_may18frl.zip', 'standart', '2018-05-01', 8),
(119, 'http://ratings.fide.com/download/standard_jun18frl.zip', 'standart', '2018-06-01', 8),
(120, 'http://ratings.fide.com/download/standard_jul18frl.zip', 'standart', '2018-07-01', 8),
(121, 'http://ratings.fide.com/download/standard_aug18frl.zip', 'standart', '2018-08-01', 8),
(122, 'http://ratings.fide.com/download/standard_sep18frl.zip', 'standart', '2018-09-01', 8),
(123, 'http://ratings.fide.com/download/standard_oct18frl.zip', 'standart', '2018-10-01', 8),
(124, 'http://ratings.fide.com/download/standard_nov18frl.zip', 'standart', '2018-11-01', 8),
(125, 'http://ratings.fide.com/download/standard_dec18frl.zip', 'standart', '2018-12-01', 8),
(126, 'http://ratings.fide.com/download/standard_jan19frl.zip', 'standart', '2019-01-01', 8),
(127, 'http://ratings.fide.com/download/standard_feb19frl.zip', 'standart', '2019-02-01', 8),
(128, 'http://ratings.fide.com/download/standard_mar19frl.zip', 'standart', '2019-03-01', 8),
(129, 'http://ratings.fide.com/download/standard_apr19frl.zip', 'standart', '2019-04-01', 8),
(130, 'http://ratings.fide.com/download/standard_may19frl.zip', 'standart', '2019-05-01', 8),
(131, 'http://ratings.fide.com/download/standard_jun19frl.zip', 'standart', '2019-06-01', 8),
(132, 'http://ratings.fide.com/download/standard_jul19frl.zip', 'standart', '2019-07-01', 8),
(133, 'http://ratings.fide.com/download/standard_aug19frl.zip', 'standart', '2019-08-01', 8),
(134, 'http://ratings.fide.com/download/standard_sep19frl.zip', 'standart', '2019-09-01', 8),
(135, 'http://ratings.fide.com/download/standard_oct19frl.zip', 'standart', '2019-10-01', 8),
(136, 'http://ratings.fide.com/download/standard_nov19frl.zip', 'standart', '2019-11-01', 8),
(137, 'http://ratings.fide.com/download/standard_dec19frl.zip', 'standart', '2019-12-01', 8),
(138, 'http://ratings.fide.com/download/standard_jan20frl.zip', 'standart', '2020-01-01', 8),
(139, 'http://ratings.fide.com/download/standard_feb20frl.zip', 'standart', '2020-02-01', 8),
(140, 'http://ratings.fide.com/download/standard_mar20frl.zip', 'standart', '2020-03-01', 8),
(141, 'http://ratings.fide.com/download/standard_apr20frl.zip', 'standart', '2020-04-01', 8),
(142, 'http://ratings.fide.com/download/standard_may20frl.zip', 'standart', '2020-05-01', 8),
(143, 'http://ratings.fide.com/download/standard_jun20frl.zip', 'standart', '2020-06-01', 8),
(144, 'http://ratings.fide.com/download/standard_jul20frl.zip', 'standart', '2020-07-01', 8),
(145, 'http://ratings.fide.com/download/standard_aug20frl.zip', 'standart', '2020-08-01', 8),
(146, 'http://ratings.fide.com/download/standard_sep20frl.zip', 'standart', '2020-09-01', 8),
(147, 'http://ratings.fide.com/download/standard_oct20frl.zip', 'standart', '2020-10-01', 8),
(148, 'http://ratings.fide.com/download/standard_nov20frl.zip', 'standart', '2020-11-01', 8),
(149, 'http://ratings.fide.com/download/standard_dec20frl.zip', 'standart', '2020-12-01', 8),
(150, 'http://ratings.fide.com/download/standard_jan21frl.zip', 'standart', '2021-01-01', 8),
(151, 'http://ratings.fide.com/download/standard_feb21frl.zip', 'standart', '2021-02-01', 8),
(152, 'http://ratings.fide.com/download/standard_mar21frl.zip', 'standart', '2021-03-01', 8),
(153, 'http://ratings.fide.com/download/standard_apr21frl.zip', 'standart', '2021-04-01', 8),
(154, 'http://ratings.fide.com/download/standard_may21frl.zip', 'standart', '2021-05-01', 8),
(155, 'http://ratings.fide.com/download/standard_jun21frl.zip', 'standart', '2021-06-01', 8),
(156, 'http://ratings.fide.com/download/standard_jul21frl.zip', 'standart', '2021-07-01', 8),
(157, 'http://ratings.fide.com/download/standard_aug21frl.zip', 'standart', '2021-08-01', 8),
(158, 'http://ratings.fide.com/download/standard_sep21frl.zip', 'standart', '2021-09-01', 8),
(159, 'http://ratings.fide.com/download/standard_oct21frl.zip', 'standart', '2021-10-01', 8),
(160, 'http://ratings.fide.com/download/standard_nov21frl.zip', 'standart', '2021-11-01', 8),
(161, 'http://ratings.fide.com/download/standard_dec21frl.zip', 'standart', '2021-12-01', 8),
(162, 'http://ratings.fide.com/download/standard_jan22frl.zip', 'standart', '2022-01-01', 8),
(163, 'http://ratings.fide.com/download/standard_feb22frl.zip', 'standart', '2022-02-01', 8),
(164, 'http://ratings.fide.com/download/standard_mar22frl.zip', 'standart', '2022-03-01', 8),
(165, 'http://ratings.fide.com/download/standard_apr22frl.zip', 'standart', '2022-04-01', 8),
(166, 'http://ratings.fide.com/download/standard_may22frl.zip', 'standart', '2022-05-01', 8),
(167, 'http://ratings.fide.com/download/standard_jun22frl.zip', 'standart', '2022-06-01', 8),
(168, 'http://ratings.fide.com/download/standard_jul22frl.zip', 'standart', '2022-07-01', 8),
(169, 'http://ratings.fide.com/download/standard_aug22frl.zip', 'standart', '2022-08-01', 8),
(170, 'http://ratings.fide.com/download/standard_sep22frl.zip', 'standart', '2022-09-01', 8),
(171, 'http://ratings.fide.com/download/standard_oct22frl.zip', 'standart', '2022-10-01', 8),
(172, 'http://ratings.fide.com/download/standard_nov22frl.zip', 'standart', '2022-11-01', 8),
(173, 'http://ratings.fide.com/download/standard_dec22frl.zip', 'standart', '2022-12-01', 8),
(174, 'http://ratings.fide.com/download/standard_jan23frl.zip', 'standart', '2023-01-01', 8),
(175, 'http://ratings.fide.com/download/standard_feb23frl.zip', 'standart', '2023-02-01', 8),
(176, 'http://ratings.fide.com/download/standard_mar23frl.zip', 'standart', '2023-03-01', 8),
(177, 'http://ratings.fide.com/download/standard_apr23frl.zip', 'standart', '2023-04-01', 8),
(178, 'http://ratings.fide.com/download/standard_may23frl.zip', 'standart', '2023-05-01', 8),
(179, 'http://ratings.fide.com/download/standard_jun23frl.zip', 'standart', '2023-06-01', 8),
(180, 'http://ratings.fide.com/download/standard_jul23frl.zip', 'standart', '2023-07-01', 8),
(181, 'http://ratings.fide.com/download/standard_aug23frl.zip', 'standart', '2023-08-01', 8),
(182, 'http://ratings.fide.com/download/standard_sep23frl.zip', 'standart', '2023-09-01', 8),
(183, 'http://ratings.fide.com/download/standard_oct23frl.zip', 'standart', '2023-10-01', 8),
(184, 'http://ratings.fide.com/download/standard_nov23frl.zip', 'standart', '2023-11-01', 8),
(185, 'http://ratings.fide.com/download/standard_dec23frl.zip', 'standart', '2023-12-01', 8),
(186, 'http://ratings.fide.com/download/standard_jan24frl.zip', 'standart', '2024-01-01', 8),
(187, 'http://ratings.fide.com/download/standard_feb24frl.zip', 'standart', '2024-02-01', 8),
(188, 'http://ratings.fide.com/download/standard_mar24frl.zip', 'standart', '2024-03-01', 8),
(189, 'http://ratings.fide.com/download/standard_apr24frl.zip', 'standart', '2024-04-01', 8),
(190, 'http://ratings.fide.com/download/standard_may24frl.zip', 'standart', '2024-05-01', 8),
(191, 'http://ratings.fide.com/download/standard_jun24frl.zip', 'standart', '2024-06-01', 8),
(192, 'http://ratings.fide.com/download/standard_jul24frl.zip', 'standart', '2024-07-01', 8),
(193, 'http://ratings.fide.com/download/standard_aug24frl.zip', 'standart', '2024-08-01', 8),
(194, 'http://ratings.fide.com/download/standard_sep24frl.zip', 'standart', '2024-09-01', 8);

