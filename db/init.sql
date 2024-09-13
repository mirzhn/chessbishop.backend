
DROP TABLE file_links;
CREATE TABLE file_links (
	id int UNSIGNED AUTO_INCREMENT KEY,
	file_url varchar(255) NOT NULL,
	load_type varchar(255) DEFAULT NULL
)
ENGINE = INNODB;


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


select * 
FROM file_links;