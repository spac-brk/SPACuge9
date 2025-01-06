USE bike_store;
DROP PROCEDURE IF EXISTS GetAllProducts;
DROP PROCEDURE IF EXISTS CreateProduct;
DROP PROCEDURE IF EXISTS GetAllCustomers;
DROP PROCEDURE IF EXISTS RestockProducts;
DROP PROCEDURE IF EXISTS GetRestockReport;
DROP PROCEDURE IF EXISTS AddRestock;
DROP PROCEDURE IF EXISTS CreateOrder;
DROP PROCEDURE IF EXISTS UpdateOrder;
DROP PROCEDURE IF EXISTS DeleteOrder;
DROP PROCEDURE IF EXISTS CountAllTables;

DELIMITER $$

CREATE PROCEDURE GetAllProducts()
BEGIN
	SELECT *  FROM products;
END$$

CREATE PROCEDURE GetAllCustomers()
BEGIN
	SELECT *  FROM customers;
END$$

CREATE PROCEDURE RestockProducts(IN store_id INT)
BEGIN
    -- Temporary table to hold restocking data
    CREATE TEMPORARY TABLE RestockReport (
        product_id INT,
        product_name VARCHAR(255),
        brand_name VARCHAR(255),
        quantity_required INT
    );

    -- Insert data into the temporary table
    INSERT INTO RestockReport (product_id, product_name, brand_name, quantity_required)
    SELECT
        p.product_id,
        p.product_name,
        b.brand_name,
        (30 - s.quantity) AS quantity_required -- Assuming threshold is 30 units
    FROM
        stocks s
    INNER JOIN products p ON s.product_id = p.product_id
    INNER JOIN brands b ON p.brand_id = b.brand_id
    WHERE
        s.store_id = store_id
        AND s.quantity < 5 -- Restocking threshold
	ORDER BY b.brand_name;

    -- Display the restocking report
    SELECT * FROM RestockReport;

    -- Drop the temporary table
    DROP TEMPORARY TABLE RestockReport;
END$$

CREATE PROCEDURE GetRestockReport(IN store_id INT)
BEGIN
    SELECT
        p.product_id,
        p.product_name,
        b.brand_name,
        s.quantity AS current_stock,
        p.list_price
    FROM
        products p
    JOIN
        stocks s ON p.product_id = s.product_id
    JOIN
        brands b ON p.brand_id = b.brand_id
    WHERE
        s.store_id = store_id
          AND s.quantity < 5;
END$$

CREATE PROCEDURE AddRestock(
    IN store_id INT,
    IN product_id INT,
    IN quantity INT
)
BEGIN
    UPDATE stocks
    SET quantity = quantity + quantity
    WHERE store_id = store_id AND product_id = product_id;

    IF ROW_COUNT() = 0 THEN
        INSERT INTO stocks (store_id, product_id, quantity)
        VALUES (store_id, product_id, quantity);
    END IF;
END$$

CREATE PROCEDURE CreateOrder(
    IN customer_id INT,
    IN order_date DATE,
    IN order_status VARCHAR(50),
    IN items JSON
)
BEGIN
    DECLARE new_order_id INT;

    -- Insert into orders table
    INSERT INTO orders (customer_id, order_date, order_status)
    VALUES (customer_id, order_date, order_status);

    SET new_order_id = LAST_INSERT_ID();

    -- Insert into order_items using JSON input
    INSERT INTO order_items (order_id, item_id, product_id, quantity, list_price, discount)
    SELECT 
        new_order_id,
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.item_id')),
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.product_id')),
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.quantity')),
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.list_price')),
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.discount'))
    FROM JSON_TABLE(items, '$[*]' COLUMNS (
        item JSON PATH '$'
    )) as jt;
END$$

CREATE PROCEDURE UpdateOrder(
    IN order_id INT,
    IN order_status VARCHAR(50),
    IN items JSON
)
BEGIN
    -- Update orders table
    UPDATE orders 
    SET order_status = order_status
    WHERE order_id = order_id;

    -- Update or replace order_items
    DELETE FROM order_items WHERE order_id = order_id;

    INSERT INTO order_items (order_id, item_id, product_id, quantity, list_price, discount)
    SELECT 
        order_id,
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.item_id')),
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.product_id')),
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.quantity')),
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.list_price')),
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.discount'))
    FROM JSON_TABLE(items, '$[*]' COLUMNS (
        item JSON PATH '$'
    )) as jt;
END$$

CREATE PROCEDURE DeleteOrder(IN order_id INT)
BEGIN
    DELETE FROM order_items WHERE order_id = order_id;
    DELETE FROM orders WHERE order_id = order_id;
END$$

CREATE PROCEDURE CreateProduct(
    product_name VARCHAR(255),
    brand_id INT,
    category_id INT,
    model_year INT, 
    list_price DOUBLE
)
BEGIN
    DECLARE new_product_id INT;

    -- Insert into products table
	INSERT INTO products (product_name, brand_id, category_id, model_year, list_price)
	VALUES (product_name, brand_id, category_id, model_year, list_price);

    SET new_product_id = LAST_INSERT_ID();

    -- Insert into stocks for every store
    INSERT INTO stocks (store_id, product_id, quantity)
    SELECT stores.store_id, new_product_id, 0 FROM stores;
END$$

-- CREATE PROCEDURE CountAllTables()
-- BEGIN
-- 	DROP IF EXISTS TABLE TableCounts;
--     
-- 	SELECT 'brands: ' + cast(count(*) AS CHAR) + ' rows' FROM brands;
-- 	SELECT 'categories: ' + cast(count(*) AS CHAR) + ' rows' FROM categories;
-- 	SELECT 'customers: ' + cast(count(*) AS CHAR) + ' rows' FROM customers;
-- 	SELECT 'order_items: ' + cast(count(*) AS CHAR) + ' rows' FROM order_items;
-- 	SELECT 'order_statuses: ' + cast(count(*) AS CHAR) + ' rows' FROM order_statuses;
-- 	SELECT 'orders: ' + cast(count(*) AS CHAR) + ' rows' FROM orders;
-- 	SELECT 'products: ' + cast(count(*) AS CHAR) + ' rows' FROM products;
-- 	SELECT 'staffs: ' + cast(count(*) AS CHAR) + ' rows' FROM staffs;
-- 	SELECT 'stocks: ' + cast(count(*) AS CHAR) + ' rows' FROM stocks;
-- 	SELECT 'stores: ' + cast(count(*) AS CHAR) + ' rows' FROM stores;
-- END$$

DELIMITER ;

COMMIT;