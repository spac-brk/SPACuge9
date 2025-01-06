import pandas as pd
import numpy as np
import mysql.connector
import subprocess
import os

# Get query as DataFrame
def df_from_sql(conn, query):
    cursor_ = conn.cursor()
    cursor_.execute(query)
    cols = [x[0] for x in cursor_.description]
    rows = cursor_.fetchall()
    return pd.DataFrame.from_records(rows, columns=cols)


# Write dataframe to database
def write_df_to_sql(df, connection, table_name):
    cursor = connection.cursor()

    # Generate column names for SQL insert
    columns = ", ".join(df.columns)
    placeholders = ", ".join(["%s"] * len(df.columns))
    insert_sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"

    # Write rows to the database
    try:
        for _, row in df.iterrows():
            cursor.execute(insert_sql, tuple(row))
        connection.commit()
        print(f"Data successfully written to {table_name}.")
    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
    finally:
        cursor.close()


def main():
    # # Rounding up SQL scripts
    # filenames = ['create_tables.sql', 'udfs.sql', 'views.sql', 'stored_procs.sql']
    # with open('create_database.sql', 'w') as outfile:
    #     for fname in filenames:
    #         with open(fname) as infile:
    #             outfile.write(infile.read())

    # Execute SQL script from file
    cnx_bs = mysql.connector.connect(user='brk', password='12345678', database='bike_store')
    with open('create_tables.sql', 'r') as f:
        with cnx_bs.cursor() as cursor:
            cursor.execute(f.read(), multi=True)

    # # Trying (unsuccessfully) to run SQL in MySQL from OS CLI
    # command = ("C:/Program Files/MySQL/MySQL Server 8.4/bin/mysql -u brk --password=12345678 "
    #            "< C:/Users/SPAC-45/PycharmProjects/SPACuge9/create_database.sql").split()
    # p = subprocess.Popen(command, stdout=subprocess.PIPE)
    # p.communicate()
    # os.remove('create_database.sql')

    # Read data from files
    path = 'data/'
    customers = pd.read_csv(path + 'customers.csv', dtype='str')
    brands = pd.read_csv(path + 'brands.csv', dtype='str')
    categories = pd.read_csv(path + 'categories.csv', dtype='str')
    stores = pd.read_csv(path + 'stores.csv', dtype='str')
    products = pd.read_csv(path + 'products.csv', dtype='str')
    order_statuses = pd.read_csv(path + 'order_statuses.csv', dtype='str')
    staffs = pd.read_csv(path + 'staffs.csv', dtype='str')
    orders = pd.read_csv(path + 'orders.csv', dtype='str')
    order_items = pd.read_csv(path + 'order_items.csv', dtype='str')
    stocks = pd.read_csv(path + 'stocks.csv', dtype='str')

    # Adjust data
    customers = customers.replace({np.nan: None})
    staffs = staffs.replace({np.nan: None})
    orders = orders.replace({np.nan: None})

    # Data changes
    staffs['manager_id'] = staffs['manager_id'].replace('7','8')
    orders['staff_id'] = orders['staff_id'].replace({'6':'5','7':'6','8':'9','9':'10'})

    # Write data to database
    cnx_bs = mysql.connector.connect(user='brk', password='12345678', database='bike_store')
    write_df_to_sql(customers, cnx_bs, 'customers')
    write_df_to_sql(brands, cnx_bs, 'brands')
    write_df_to_sql(categories, cnx_bs, 'categories')
    write_df_to_sql(stores, cnx_bs, 'stores')
    write_df_to_sql(products, cnx_bs, 'products')
    write_df_to_sql(order_statuses, cnx_bs, 'order_statuses')
    write_df_to_sql(staffs, cnx_bs, 'staffs')
    write_df_to_sql(orders, cnx_bs, 'orders')
    write_df_to_sql(order_items, cnx_bs, 'order_items')
    write_df_to_sql(stocks, cnx_bs, 'stocks')

    # Close connection
    cnx_bs.close()


if __name__ == '__main__':
    main()