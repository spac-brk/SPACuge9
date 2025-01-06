import mysql.connector
from mysql.connector import Error

class DatabaseConfig:
    @staticmethod
    def get_connection():
        """Get a database connection."""
        try:
            connection = mysql.connector.connect(
                host="localhost",        # Replace with your host
                user="brk",             # Replace with your username
                password="12345678",     # Replace with your password
                database="bike_store"    # Replace with your database name
            )
            return connection
        except Error as e:
            print(f"Error connecting to database: {e}")
            return None
