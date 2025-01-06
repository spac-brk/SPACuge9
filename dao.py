from database_config import DatabaseConfig
from dto import Product, Stock, RestockReport, Store
import json

class ProductDAO:
    @staticmethod
    def get_all_products():
        """Fetch all products from the database."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return []
        cursor = connection.cursor()
        cursor.execute("""
            SELECT product_id, product_name, brand_id, category_id, model_year, list_price
            FROM products
        """)
        rows = cursor.fetchall()
        connection.close()
        return [Product(*row) for row in rows]

    @staticmethod
    def get_product_by_id(product_id):
        """Fetch a product by ID."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return None
        cursor = connection.cursor()
        cursor.execute("""
            SELECT product_id, product_name, brand_id, category_id, model_year, list_price
            FROM products
            WHERE product_id = %s
        """, (product_id,))
        row = cursor.fetchone()
        connection.close()
        return Product(*row) if row else None

    @staticmethod
    def create_product(product_name, brand_id, category_id, model_year, list_price):
        """Create a new product."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return None
        cursor = connection.cursor()
        try:
            # Create product and add to stocks with quantity 0.
            cursor.callproc("CreateProduct", [
                product_name, brand_id, category_id, model_year, list_price
            ])
            connection.commit()
            return True
        except Exception as e:
            print(f"Error creating product: {e}")
            connection.rollback()
            return False
        finally:
            connection.close()


class StockDAO:
    @staticmethod
    def get_stock_by_store(store_id):
        """Fetch all stock information for a store."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return []
        cursor = connection.cursor()
        cursor.execute("""
            SELECT store_id, product_id, quantity
            FROM stocks
            WHERE store_id = %s
        """, (store_id,))
        rows = cursor.fetchall()
        connection.close()
        return [Stock(*row) for row in rows]

    @staticmethod
    def add_stock(store_id, product_id, quantity):
        """Add restock data for a given store and product."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return False
        cursor = connection.cursor()
        try:
            cursor.callproc("AddRestock", [store_id, product_id, quantity])
            connection.commit()
            return True
        except Exception as e:
            print(f"Error adding restock: {e}")
            connection.rollback()
            return False
        finally:
            connection.close()

class RestockDAO:
    @staticmethod
    def get_restock_report(store_id):
        """Fetch restock report for a given store ID."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return []
        cursor = connection.cursor()
        cursor.callproc("GetRestockReport", [store_id])
        rows = cursor.fetchall()
        connection.close()
        return [RestockReport(*row) for row in rows]

    @staticmethod
    def add_restock(store_id, product_id, quantity):
        """Add restock data for a given store and product."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return False
        cursor = connection.cursor()
        try:
            cursor.callproc("AddRestock", [store_id, product_id, quantity])
            connection.commit()
            return True
        except Exception as e:
            print(f"Error adding restock: {e}")
            connection.rollback()
            return False
        finally:
            connection.close()

class OrderDAO:
    @staticmethod
    def create_order(customer_id, order_date, order_status, items):
        """Create a new order with items."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return None
        cursor = connection.cursor()
        try:
            cursor.callproc("CreateOrder", [
                customer_id,
                order_date,
                order_status,
                json.dumps(items)  # Convert Python list to JSON
            ])
            connection.commit()
            return True
        except Exception as e:
            print(f"Error creating order: {e}")
            connection.rollback()
            return False
        finally:
            connection.close()

    @staticmethod
    def update_order(order_id, order_status, items):
        """Update an order and its items."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return False
        cursor = connection.cursor()
        try:
            cursor.callproc("UpdateOrder", [
                order_id,
                order_status,
                json.dumps(items)  # Convert Python list to JSON
            ])
            connection.commit()
            return True
        except Exception as e:
            print(f"Error updating order: {e}")
            connection.rollback()
            return False
        finally:
            connection.close()

    @staticmethod
    def delete_order(order_id):
        """Delete an order and its items."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return False
        cursor = connection.cursor()
        try:
            cursor.callproc("DeleteOrder", [order_id])
            connection.commit()
            return True
        except Exception as e:
            print(f"Error deleting order: {e}")
            connection.rollback()
            return False
        finally:
            connection.close()

    @staticmethod
    def get_orders():
        """Fetch all orders with their items."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return []
        cursor = connection.cursor()
        try:
            cursor.execute("SELECT * FROM vw_orders")
            rows = cursor.fetchall()
            connection.close()
            return rows
        except Exception as e:
            print(f"Error fetching orders: {e}")
            return []

class StoreDAO:
    @staticmethod
    def get_all_stores():
        """Fetch all stores from the database."""
        connection = DatabaseConfig.get_connection()
        if not connection:
            return []
        cursor = connection.cursor()
        cursor.execute("""
            SELECT store_id, store_name, phone, email, street, city, state, zip_code
            FROM stores
        """)
        rows = cursor.fetchall()
        connection.close()
        return rows