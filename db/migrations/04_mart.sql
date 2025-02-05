CREATE TABLE IF NOT EXISTS mart_players (
    id INT UNSIGNED AUTO_INCREMENT,
    id_number VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    id_title SMALLINT UNSIGNED NULL,
    id_country SMALLINT UNSIGNED NULL,
    sex SMALLINT UNSIGNED NULL,
    birth_year SMALLINT UNSIGNED NULL,
	 last_id_file INT UNSIGNED NULL,
    UNIQUE INDEX uq_mart_players_id_number (id_number),
	 INDEX ix_mart_players_id_title (id_title),
	 INDEX ix_mart_players_id_country (id_country),
	 PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_general_ci,
ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS fact_ratings (
    id INT UNSIGNED AUTO_INCREMENT,
    id_player INT UNSIGNED NOT NULL,
    rating INT UNSIGNED NOT NULL,
    games INT UNSIGNED NOT NULL,
    id_kfactor SMALLINT UNSIGNED NULL,
    record_date DATE NOT NULL,
    PRIMARY KEY (id, record_date),
    INDEX ix_fact_ratings_id_player (id_player),
    INDEX ix_fact_ratings_id_kfactor (id_kfactor)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
ROW_FORMAT = DYNAMIC
PARTITION BY RANGE COLUMNS(record_date) (
    PARTITION p200001 VALUES LESS THAN ('2000-01-01')
);

CREATE PROCEDURE add_partitions_fact_ratings(IN start_date DATE, IN end_date DATE)
BEGIN
    DECLARE partition_date DATE;
    DECLARE partition_name VARCHAR(64);
    DECLARE next_partition_date DATE;
    DECLARE sql_statement TEXT;

    SET partition_date = start_date;
    
    WHILE partition_date < end_date DO
        -- Вычисляем имя партиции (pYYYYMM)
        SET partition_name = CONCAT('p', DATE_FORMAT(partition_date, '%Y%m'));

        -- Дата конца партиции (следующий месяц)
        SET next_partition_date = DATE_ADD(partition_date, INTERVAL 1 MONTH);

        -- Создаём команду ALTER TABLE с динамическим SQL
        SET @sql_statement = CONCAT(
            'ALTER TABLE fact_ratings ADD PARTITION (
                PARTITION ', partition_name, ' VALUES LESS THAN (\'', 
                DATE_FORMAT(next_partition_date, '%Y-%m-01'), '\')
            )'
        );

        -- Выполняем команду
        PREPARE stmt FROM @sql_statement;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        -- Переходим к следующему месяцу
        SET partition_date = next_partition_date;
    END WHILE;
END;

CALL add_partitions_fact_ratings('2000-02-01', '2030-01-01');

