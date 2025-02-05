use chessbi;

CREATE TABLE IF NOT EXISTS mart_title (
	id  SMALLINT UNSIGNED AUTO_INCREMENT,
    code varchar(3) NOT NULL,
    old_code varchar(3) NULL,
    description varchar(255) NOT NULL,
    PRIMARY KEY(id), 
    UNIQUE INDEX uq_mart_title_code(code), 
    INDEX ix_mart_title_old_code(old_code)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_general_ci,
ROW_FORMAT = DYNAMIC;

INSERT INTO mart_title (code, old_code, description)
VALUES
('CM','c', 'Candidate Master'),
('FM','f', 'FIDE Master'),
('GM','g', 'Grandmaster'),
('HM','gh', 'Honorary Grandmaster'),
('h','h', 'Unknown'),
('hg','hg', 'Honorary Grandmaster'),
('IM','m','International Master'),
('WCM','wc','Woman Candidate Master'),
('WC','','Woman Candidate Master'),
('WFM','wf','Woman FIDE Master'),
('WF','-','Woman FIDE Master'),
('WGM','wg','Woman Grandmaster'),
('WH','wh','Woman Honorary Grandmaster'),
('WIM','wm','Woman Intl. Master')
ON DUPLICATE KEY UPDATE
description = VALUES(description), old_code = VALUES(old_code);





use chessbi;

CREATE TABLE IF NOT EXISTS mart_kfactor (
	id  SMALLINT UNSIGNED AUTO_INCREMENT,
    code varchar(3) NOT NULL,
    PRIMARY KEY(id), 
    UNIQUE INDEX uq_mart_kfactor_code(code)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_general_ci,
ROW_FORMAT = DYNAMIC;

INSERT INTO mart_kfactor (code)
VALUES
('10'),
('15'),
('20'),
('30'),
('40');