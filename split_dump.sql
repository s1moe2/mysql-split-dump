DELIMITER //
DROP PROCEDURE IF EXISTS split_dump //

CREATE PROCEDURE split_dump (IN table_name VARCHAR(50), IN sel_condition VARCHAR(256), IN rows INT, IN out_dir VARCHAR(128))
BEGIN
DECLARE row_counter INT;
DECLARE table_counter INT;
DECLARE total_row INT;

SET row_counter = 0;
SET table_counter = 1;


-- count the total rows of the select statement as @total_row
SET @SQLString1 = CONCAT('SELECT COUNT(*) INTO @total_row FROM ', table_name, ' ', sel_condition);
PREPARE task_1 FROM @SQLString1;
EXECUTE task_1;

WHILE row_counter <= @total_row DO

-- export the rows from select statement with limit
SET @SQLString = CONCAT('SELECT * FROM ', table_name, ' ', sel_condition, ' LIMIT ', row_counter, ',' , rows, ' INTO OUTFILE "', out_dir, table_name, '-', table_counter, '.csv" FIELDS TERMINATED BY '', '' OPTIONALLY ENCLOSED BY ''"'' LINES TERMINATED BY ''\n''');
PREPARE task_2 FROM @SQLString;
EXECUTE task_2;

SET row_counter = row_counter + rows;
SET table_counter = table_counter + 1;

END WHILE;

END //
DELIMITER ;