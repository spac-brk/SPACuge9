DROP SCHEMA IF EXISTS `bike_store`;
CREATE SCHEMA IF NOT EXISTS `bike_store`;
USE `bike_store`;
GRANT ALL ON `bike_store`.* TO 'brk'@'%';

CREATE TABLE `customers` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `first_name` text,
  `last_name` text,
  `phone` text,
  `email` text,
  `street` text,
  `city` text,
  `state` text,
  `zip_code` text,
  PRIMARY KEY (`customer_id`)
);

CREATE TABLE `brands` (
  `brand_id` int NOT NULL AUTO_INCREMENT,
  `brand_name` text,
  PRIMARY KEY (`brand_id`)
);

CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` text,
  PRIMARY KEY (`category_id`)
);

CREATE TABLE `stores` (
  `store_id` int NOT NULL AUTO_INCREMENT,
  `store_name` text,
  `phone` text,
  `email` text,
  `street` text,
  `city` text,
  `state` text,
  `zip_code` text,
  PRIMARY KEY (`store_id`)
);

CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` text,
  `brand_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `model_year` int DEFAULT NULL,
  `list_price` double DEFAULT NULL,
  PRIMARY KEY (`product_id`)
);

CREATE TABLE `order_statuses` (
  `order_status` int NOT NULL,
  `order_status_name` text,
  PRIMARY KEY (`order_status`)
);

CREATE TABLE `staffs` (
  `staff_id` int NOT NULL AUTO_INCREMENT,
  `first_name` text,
  `last_name` text,
  `email` text,
  `phone` text,
  `active` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `manager_id` int DEFAULT NULL,
  PRIMARY KEY (`staff_id`),
  CONSTRAINT `fk_staffs_store_id`
  FOREIGN KEY (`store_id`) 
  REFERENCES `stores`(`store_id`),
  CONSTRAINT `fk_staffs_manager_id`
  FOREIGN KEY (`manager_id`) 
  REFERENCES `staffs`(`staff_id`)
);

CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `order_status` int DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `required_date` datetime DEFAULT NULL,
  `shipped_date` datetime DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  CONSTRAINT `fk_orders_customer_id`
  FOREIGN KEY (`customer_id`) 
  REFERENCES `customers`(`customer_id`)
  ON DELETE CASCADE,
  CONSTRAINT `fk_orders_order_status`
  FOREIGN KEY (`order_status`)
  REFERENCES `order_statuses`(`order_status`),
  CONSTRAINT `fk_orders_store_id`
  FOREIGN KEY (`store_id`)
  REFERENCES `stores`(`store_id`),
  CONSTRAINT `fk_orders_staff_id`
  FOREIGN KEY (`staff_id`) 
  REFERENCES `staffs`(`staff_id`)
);

CREATE TABLE `order_items` (
  `order_id` int NOT NULL,
  `item_id` int NOT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `list_price` double DEFAULT NULL,
  `discount` double DEFAULT NULL,
  PRIMARY KEY (`order_id`, `item_id`),
  CONSTRAINT `fk_order_items_order_id`
  FOREIGN KEY (`order_id`)
  REFERENCES `orders`(`order_id`)
  ON DELETE CASCADE,
  CONSTRAINT `fk_order_items_product_id`
  FOREIGN KEY (`product_id`)
  REFERENCES `products`(`product_id`)
);

CREATE TABLE `stocks` (
  `store_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`store_id`, `product_id`),
  CONSTRAINT `fk_stocks_store_id`
  FOREIGN KEY (`store_id`)
  REFERENCES `stores`(`store_id`),
  CONSTRAINT `fk_stocks_product_id`
  FOREIGN KEY (`product_id`)
  REFERENCES `products`(`product_id`)
);

COMMIT;

-- LOAD DATA INFILE 'C:/Users/SPAC-45/PycharmProjects/SPACuge9/data/customers.csv' INTO TABLE `customers`
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
-- LOAD DATA INFILE 'C:/Users/SPAC-45/PycharmProjects/SPACuge9/data/brands.csv' INTO TABLE `brands`
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
-- LOAD DATA INFILE 'C:/Users/SPAC-45/PycharmProjects/SPACuge9/data/categories.csv' INTO TABLE `categories`
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
-- LOAD DATA INFILE 'C:/Users/SPAC-45/PycharmProjects/SPACuge9/data/stores.csv' INTO TABLE `stores`
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
-- LOAD DATA INFILE 'C:/Users/SPAC-45/PycharmProjects/SPACuge9/data/products.csv' INTO TABLE `products`
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
-- LOAD DATA INFILE 'C:/Users/SPAC-45/PycharmProjects/SPACuge9/data/staffs.csv' INTO TABLE `staffs`
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
-- LOAD DATA INFILE 'C:/Users/SPAC-45/PycharmProjects/SPACuge9/data/orders.csv' INTO TABLE `orders`
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
-- LOAD DATA INFILE 'C:/Users/SPAC-45/PycharmProjects/SPACuge9/data/order_items.csv' INTO TABLE `order_items`
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
-- LOAD DATA INFILE 'C:/Users/SPAC-45/PycharmProjects/SPACuge9/data/stocks.csv' INTO TABLE `stocks`
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

COMMIT;
