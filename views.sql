USE `bike_store`;

CREATE OR REPLACE VIEW staff_sales AS
	SELECT s.staff_id, s.first_name, s.last_name,
		   format_$(SUM(oi.quantity*oi.list_price*(1-oi.discount))) AS total_sales,
		   format_pct(SUM(oi.quantity*oi.list_price*oi.discount)/SUM(oi.quantity*oi.list_price),1) AS avg_discount
	  FROM (staffs s JOIN orders o ON s.staff_id = o.staff_id) 
	  JOIN order_items oi ON o.order_id = oi.order_id
	 WHERE o.order_status <> 3
	GROUP BY s.staff_id, s.first_name, s.last_name
	ORDER BY s.staff_id;

CREATE OR REPLACE VIEW staff_orders AS
	SELECT s.staff_id, s.first_name, s.last_name, os.order_status_name, COUNT(o.order_id)
	  FROM staffs s JOIN orders o ON s.staff_id = o.staff_id JOIN order_statuses os ON o.order_status = os.order_status
	GROUP BY s.staff_id, s.first_name, s.last_name, o.order_status
	ORDER BY o.order_status, s.staff_id;

CREATE OR REPLACE VIEW customer_revenues AS
	SELECT c.customer_id, c.first_name, c.last_name, count(o.order_id) as num_orders, SUM(oi.quantity) AS items_bought,
		   format_$(SUM(oi.quantity*oi.list_price*(1-oi.discount))) AS total_spent,
		   format_pct(SUM(oi.quantity*oi.list_price*oi.discount)/SUM(oi.quantity*oi.list_price),1) AS avg_discount
	  FROM (customers c JOIN orders o ON c.customer_id = o.customer_id) 
	  JOIN order_items oi ON o.order_id = oi.order_id
	 WHERE o.order_status <> 3
	GROUP BY c.customer_id, c.first_name, c.last_name
	ORDER BY SUM(oi.quantity*oi.list_price*(1-oi.discount)) DESC;
  
CREATE OR REPLACE VIEW vw_orders AS
SELECT 
    o.order_id, o.customer_id, o.order_date, o.order_status,
    oi.item_id, oi.product_id, oi.quantity, oi.list_price, oi.discount
FROM orders o LEFT JOIN order_items oi ON o.order_id = oi.order_id;

COMMIT;
