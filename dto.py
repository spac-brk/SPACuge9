class Product:
    def __init__(self, product_id, product_name, brand_id, category_id, model_year, list_price):
        self.product_id = product_id
        self.product_name = product_name
        self.brand_id = brand_id
        self.category_id = category_id
        self.model_year = model_year
        self.list_price = list_price

class Stock:
    def __init__(self, store_id, product_id, quantity):
        self.store_id = store_id
        self.product_id = product_id
        self.quantity = quantity

class Order:
    def __init__(self, order_id, customer_id, order_status, order_date, required_date, store_id, staff_id):
        self.order_id = order_id
        self.customer_id = customer_id,
        self.order_status = order_status,
        self.order_date = order_date,
        self.required_date = required_date,
        self.store_id = store_id,
        self.staff_id = staff_id,

class OrderItem:
    def __init__(self, order_id, item_id, product_id, quantity, list_price, discount):
        self.order_id = order_id
        self.item_id = item_id,
        self.product_id = product_id,
        self.quantity = quantity,
        self.list_price = list_price,
        self.discount = discount

class RestockReport:
    def __init__(self, product_id, product_name, brand_name, current_stock, list_price):
        self.product_id = product_id
        self.product_name = product_name
        self.brand_name = brand_name
        self.current_stock = current_stock
        self.list_price = list_price

class Store:
    def __init__(self, store_id, store_name, phone, email, street, city, state, zip_code):
        self.store_id = store_id
        self.store_name = store_name
        self.phone = phone
        self.email = email
        self.street = street
        self.city = city
        self.state = state
        self.zip_code = zip_code