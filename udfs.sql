USE bike_store;
DROP FUNCTION IF EXISTS format_$;
DROP FUNCTION IF EXISTS format_pct;

DELIMITER $$

CREATE FUNCTION format_$(amount double)
RETURNS CHAR(10)
NO SQL
BEGIN
RETURN CONCAT('$',FORMAT(amount,2));
END$$

CREATE FUNCTION format_pct(num double, decim int)
RETURNS CHAR(10)
NO SQL
BEGIN
RETURN CONCAT(FORMAT(100*num,decim),'%');
END$$

DELIMITER ;

COMMIT;