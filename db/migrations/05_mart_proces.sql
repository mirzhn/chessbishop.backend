DROP FUNCTION IF EXISTS get_birth_year;
CREATE FUNCTION get_birth_year(p_birthday VARCHAR(255), p_reprot_dt DATE) RETURNS SMALLINT
DETERMINISTIC
BEGIN
    DECLARE v_birth_year SMALLINT;
    DECLARE v_two_digit_year SMALLINT;
    DECLARE v_max_valid_birth_year SMALLINT;
    DECLARE v_min_valid_birth_year SMALLINT;

    -- Если уже полный год (YYYY), просто возвращаем его
    IF p_birthday REGEXP '^[1-2][0-9]{3}$' THEN
        RETURN CAST(p_birthday AS UNSIGNED);
    END IF;

    -- Если не соответствует формату DD.MM.YY, возвращаем NULL
    IF NOT p_birthday REGEXP '^[0-9]{2}\\.[0-9]{2}\\.[0-9]{2}$' THEN
        RETURN NULL;
    END IF;

    -- Извлекаем двузначный год
    SET v_two_digit_year = CAST(RIGHT(p_birthday, 2) AS UNSIGNED);

    -- Определяем "границу века" (120 лет назад и 5 лет назад)
    SET v_max_valid_birth_year = YEAR(p_reprot_dt) - 80; -- Старейший возможный шахматист
    SET v_min_valid_birth_year = YEAR(p_reprot_dt) - 3;   -- Самый младший шахматист

    -- Если двузначный год >= порога, это 19XX
    IF v_two_digit_year >= RIGHT(v_max_valid_birth_year, 2) THEN
        RETURN CONCAT('19', LPAD(v_two_digit_year, 2, '0'));

    -- Если год < порога, проверяем, не делает ли он шахматиста младше 5 лет
    ELSE 
        -- Если 20XX делает шахматиста моложе 5 лет, корректируем на 19XX
        IF CONCAT('20', LPAD(v_two_digit_year, 2, '0')) > v_min_valid_birth_year THEN
            RETURN CONCAT('19', LPAD(v_two_digit_year, 2, '0'));
        ELSE
            RETURN CONCAT('20', LPAD(v_two_digit_year, 2, '0'));
        END IF;
    END IF;
END;

DROP PROCEDURE IF EXISTS load_players_from_file;
CREATE PROCEDURE load_players_from_file(IN p_id_file INT UNSIGNED)
BEGIN
    DECLARE v_load_type VARCHAR(255);
    DECLARE v_reprot_dt DATE;

    -- Получаем тип загрузки и дату репорта
    SELECT load_type, reprot_dt 
    INTO v_load_type, v_reprot_dt
    FROM file_links
    WHERE id = p_id_file;

    -- Если файл типа old_type_2
    IF v_load_type = 'old_type_2' THEN
        INSERT INTO mart_players (id_number, name, id_title, id_country, sex, birth_year, inactive, last_id_file)
        SELECT 
            s.ID_NUMBER, 
            s.NAME, 
            t.id AS id_title,
            c.id AS id_country,
            NULL,  -- sex отсутствует в old_type_2
            get_birth_year(s.BIRTHDAY, v_reprot_dt), -- Теперь используем функцию
				COALESCE(s.FLAG, '') like '%i%' AS inactive,
            p_id_file
        FROM sa_old_type_2 s
	        LEFT JOIN file_links f ON f.id = s.id_file -- Получаем reprot_dt для функции
	        LEFT JOIN mart_title t ON s.TITLE = t.code
	        LEFT JOIN mart_country c ON s.COUNTRY = c.code
        WHERE NOT EXISTS (
            SELECT 1 
				FROM mart_players p 
            	JOIN file_links f2 ON f2.id = p.last_id_file
            WHERE p.id_number = s.ID_NUMBER 
					AND f2.reprot_dt >= v_reprot_dt
        )
		  		AND s.id_file = p_id_file
        ON DUPLICATE KEY UPDATE 
            mart_players.name = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(name), mart_players.name), mart_players.name),
            mart_players.id_title = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(id_title), mart_players.id_title), mart_players.id_title),
            mart_players.id_country = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(id_country), mart_players.id_country), mart_players.id_country),
            mart_players.birth_year = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(birth_year), mart_players.birth_year), mart_players.birth_year),
				mart_players.inactive = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(inactive), mart_players.inactive), mart_players.inactive),
            mart_players.last_id_file = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(last_id_file), mart_players.last_id_file), mart_players.last_id_file);

    -- Если файл типа standart
    ELSEIF v_load_type = 'standart' THEN
        INSERT INTO mart_players (id_number, name, id_title, id_country, sex, birth_year, inactive, last_id_file)
        SELECT 
            s.ID_NUMBER, 
            s.NAME, 
            t.id AS id_title,
            c.id AS id_country,
            CASE 
					WHEN s.SEX = 'M' THEN 1 
					WHEN s.SEX = 'F' THEN 0 
				END AS sex,
            get_birth_year(s.BIRTHDAY, v_reprot_dt), -- Используем функцию
				COALESCE(s.FLAG, '') like '%i%' AS inactive,
            p_id_file
        FROM sa_standart s
	        LEFT JOIN file_links f ON f.id = s.id_file -- Получаем reprot_dt
	        LEFT JOIN mart_title t ON COALESCE(s.TITLE, s.WTITLE, s.OTITLE) = t.code
	        LEFT JOIN mart_country c ON s.COUNTRY = c.code
        WHERE NOT EXISTS (
            SELECT 1 
				FROM mart_players p 
            	JOIN file_links f2 ON f2.id = p.last_id_file
            WHERE p.id_number = s.ID_NUMBER 
					AND f2.reprot_dt >= v_reprot_dt
        )
		  	AND s.id_file = p_id_file
        ON DUPLICATE KEY UPDATE 
			mart_players.name = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(name), mart_players.name), mart_players.name),
			mart_players.id_title = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(id_title), mart_players.id_title), mart_players.id_title),
			mart_players.id_country = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(id_country), mart_players.id_country), mart_players.id_country),
			mart_players.birth_year = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(birth_year), mart_players.birth_year), mart_players.birth_year),
			mart_players.inactive = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(inactive), mart_players.inactive), mart_players.inactive),
			mart_players.sex = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(sex), mart_players.sex), mart_players.sex),
			mart_players.last_id_file = IF(last_id_file IS NULL OR last_id_file < p_id_file, COALESCE(VALUES(last_id_file), mart_players.last_id_file), mart_players.last_id_file);
    
    -- Ошибка, если формат неизвестен
    ELSE 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Unsupported load_type';
    END IF;

END;


DROP PROCEDURE IF EXISTS load_players_from_range;
CREATE PROCEDURE load_players_from_range(IN p_first_id_file INT UNSIGNED, IN p_last_id_file INT UNSIGNED)
BEGIN
    DECLARE v_current_id_file INT UNSIGNED;

    -- Проверка на корректность диапазона
    IF p_first_id_file > p_last_id_file THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid file range: first_id_file must be <= last_id_file';
    END IF;

    -- Инициализируем переменную текущего файла
    SET v_current_id_file = p_first_id_file;

    -- Цикл по файлам
    WHILE v_current_id_file <= p_last_id_file DO
        -- Вызываем существующую процедуру для загрузки данных
        CALL load_players_from_file(v_current_id_file);

        -- Переход к следующему файлу
        SET v_current_id_file = v_current_id_file + 1;
    END WHILE;
END;

DROP PROCEDURE IF EXISTS load_fact_ratings_from_file;
CREATE PROCEDURE load_fact_ratings_from_file(IN p_id_file INT UNSIGNED)
BEGIN
    DECLARE v_load_type VARCHAR(255);
    DECLARE v_reprot_dt DATE;

    -- Получаем тип загрузки и дату репорта
    SELECT load_type, reprot_dt 
    INTO v_load_type, v_reprot_dt
    FROM file_links
    WHERE id = p_id_file;

    -- Если файл типа old_type_2
    IF v_load_type = 'old_type_2' THEN
        INSERT INTO fact_ratings (id_player, rating, games, id_kfactor, inaсtive, record_date)
        SELECT 
            p.id AS id_player,
            s.RAITING AS rating,
            s.GAMES AS games,
            null AS id_kfactor,
            COALESCE(s.FLAG, '') like '%i%' AS inactive,
            v_reprot_dt AS record_date
        FROM sa_old_type_2 s
	        JOIN mart_players p ON s.ID_NUMBER = p.id_number
        WHERE s.id_file = p_id_file;

    -- Если файл типа standart
    ELSEIF v_load_type = 'standart' THEN
        INSERT INTO fact_ratings (id_player, rating, games, id_kfactor, inaсtive, record_date)
        SELECT 
            p.id AS id_player,
            s.RAITING AS rating,
            s.GAMES AS games,
            k.id AS id_kfactor,
            COALESCE(s.FLAG, '') like '%i%' AS inactive,
            v_reprot_dt AS record_date
        FROM sa_standart s
	        JOIN mart_players p ON s.ID_NUMBER = p.id_number
	        LEFT JOIN mart_kfactor k ON s.KFACTOR = k.code
        WHERE s.id_file = p_id_file;
    
    -- Ошибка, если формат неизвестен
    ELSE 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Unsupported load_type';
    END IF;

END;

DROP PROCEDURE IF EXISTS load_fact_ratings_from_range;
CREATE PROCEDURE load_fact_ratings_from_range(IN p_first_id_file INT UNSIGNED, IN p_last_id_file INT UNSIGNED)
BEGIN
    DECLARE v_current_id_file INT UNSIGNED;

    -- Проверка на корректность диапазона
    IF p_first_id_file > p_last_id_file THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid file range: first_id_file must be <= last_id_file';
    END IF;

    -- Инициализируем переменную текущего файла
    SET v_current_id_file = p_first_id_file;

    -- Цикл по файлам
    WHILE v_current_id_file <= p_last_id_file DO
        -- Вызываем существующую процедуру для загрузки данных
        CALL load_fact_ratings_from_file(v_current_id_file);

        -- Переход к следующему файлу
        SET v_current_id_file = v_current_id_file + 1;
    END WHILE;
END;

