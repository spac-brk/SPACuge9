from dao import ProductDAO, StockDAO, RestockDAO, OrderDAO, StoreDAO

def main():
    num_to_show = 5
    store_id_ = 1  # Example store ID
    product_id_ = 2  # Example product ID
    quantity_ = 20   # Example restock quantity


    # Fetch all products
    products = ProductDAO.get_all_products()
    print("Some Products:")
    for product in products[:num_to_show]:
        print(vars(product))

    # Fetch product by ID
    product = ProductDAO.get_product_by_id(product_id_)
    if product:
        print("\nProduct Details:")
        print(vars(product))

    # Fetch stock by store ID
    stock = StockDAO.get_stock_by_store(store_id_)
    print(f"\nSome of the stock for Store ID {store_id_}:")
    for item in stock[:5]:
        print(vars(item))

    # Fetch restock report
    restock_report = RestockDAO.get_restock_report(store_id_)
    print("Top of restock Report:")
    for report in restock_report[:num_to_show]:
        print(vars(report))

    # Add restock for a product
    success = RestockDAO.add_restock(store_id_, product_id_, quantity_)
    if success:
        print(f"Successfully restocked product {product_id_} with {quantity_} units.")
    else:
        print("Failed to add restock.")

    # Create a new order
    new_items = [
        {"item_id": 1, "product_id": 1, "quantity": 2, "list_price": 100.0, "discount": 0.0},
        {"item_id": 2, "product_id": 2, "quantity": 1, "list_price": 200.0, "discount": 10.0}
    ]
    success = OrderDAO.create_order(1, "2024-12-04", 1, new_items)
    print("Order created:", success)

    # Update an existing order
    updated_items = [
        {"item_id": 2, "product_id": 295, "quantity": 2, "list_price": 319.99, "discount": 10.0}
    ]
    success = OrderDAO.update_order(1600, 1, updated_items)
    print("Order updated:", success)

    # # Delete an order
    # success = OrderDAO.delete_order(1601)
    # print("Order deleted:", success)

    # Fetch all orders
    orders = OrderDAO.get_orders()
    print("Some orders and Items:")
    for order in orders[:num_to_show]:
        print(order)

    # Fetch all stores
    stores = StoreDAO.get_all_stores()
    print('Stores:')
    for store in stores:
        print(store)

    # Create product
    success = ProductDAO.create_product("Strider EasyRider QX8 - 2024", 6, 3, 2024,499.95)
    print("Product created:", success)

if __name__ == "__main__":
    main()