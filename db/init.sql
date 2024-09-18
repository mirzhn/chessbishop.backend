#step 1

DROP TABLE IF EXISTS file_links;
CREATE TABLE file_links (
	id int UNSIGNED AUTO_INCREMENT KEY,
	file_url varchar(255) NOT NULL,
	load_type varchar(255) DEFAULT NULL
)
ENGINE = INNODB;

DROP TABLE IF EXISTS file_load_log;
CREATE TABLE file_load_log (
	id_file int UNSIGNED KEY,
	load_status varchar(255) NOT NULL,
	dt datetime DEFAULT now()
)
ENGINE = INNODB;


INSERT INTO file_links(file_url, load_type)
VALUES 
('https://www.mark-weeks.com/chess/ratings/1975-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1976-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1977-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1978-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1979-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1980-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1981-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1982-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1983-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1984-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1985-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1986-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1987-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1988-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1989-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1990-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1991-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1992-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1993-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1994-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1995-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1996-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1997-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1998-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1999-01.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/2000-01.zip', 'old_type');


INSERT INTO file_links(file_url, load_type)
VALUES 
('https://www.mark-weeks.com/chess/ratings/1971.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1972.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1973.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1974.zip', 'old_type');


INSERT INTO file_links(file_url, load_type)
VALUES 
('https://www.mark-weeks.com/chess/ratings/1990-07.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1991-07.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1992-07.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1993-07.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1994-07.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1995-07.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1996-07.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1997-07.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1998-07.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/1999-07.zip', 'old_type'),
('https://www.mark-weeks.com/chess/ratings/2000-07.zip', 'old_type');


#step 2
INSERT INTO file_links(file_url, load_type)
VALUES
('http://ratings.fide.com/download/jan01frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan02frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan03frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan04frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan05frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan06frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan07frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan08frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan09frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan10frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan11frl.zip', 'old_type'),
('http://ratings.fide.com/download/jan12frl.zip', 'old_type');


INSERT INTO file_links(file_url, load_type)
VALUES
-- 2013
('http://ratings.fide.com/download/standard_jan13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_feb13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_mar13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_apr13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_may13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_jun13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_jul13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_aug13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_sep13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_oct13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_nov13frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_dec13frl.zip', 'old_standard'),
-- 2014
('http://ratings.fide.com/download/standard_jan14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_feb14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_mar14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_apr14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_may14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_jun14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_jul14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_aug14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_sep14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_oct14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_nov14frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_dec14frl.zip', 'old_standard'),
-- 2015
('http://ratings.fide.com/download/standard_jan15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_feb15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_mar15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_apr15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_may15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_jun15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_jul15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_aug15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_sep15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_oct15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_nov15frl.zip', 'old_standard'),
('http://ratings.fide.com/download/standard_dec15frl.zip', 'old_standard');


