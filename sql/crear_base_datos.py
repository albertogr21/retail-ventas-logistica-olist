"""
Construye sql/olist.db a partir de los CSV crudos de Olist en data/raw/
(descargalos del dataset de Kaggle "Brazilian E-Commerce Public Dataset by Olist"
antes de ejecutar este script -- no se suben a GitHub por su tamaño).

Uso:
    cd sql/
    python3 crear_base_datos.py
"""
import sqlite3
import os
import pandas as pd

RAW = "../data/raw"
DBPATH = "olist.db"

if os.path.exists(DBPATH):
    os.remove(DBPATH)

conn = sqlite3.connect(DBPATH)

orders = pd.read_csv(f"{RAW}/olist_orders_dataset.csv")
items = pd.read_csv(f"{RAW}/olist_order_items_dataset.csv")
customers = pd.read_csv(f"{RAW}/olist_customers_dataset.csv")
products = pd.read_csv(f"{RAW}/olist_products_dataset.csv")
sellers = pd.read_csv(f"{RAW}/olist_sellers_dataset.csv")
payments = pd.read_csv(f"{RAW}/olist_order_payments_dataset.csv")
reviews = pd.read_csv(f"{RAW}/olist_order_reviews_dataset.csv")
cat_translation = pd.read_csv(f"{RAW}/product_category_name_translation.csv")

products = products.merge(cat_translation, on="product_category_name", how="left")
products["product_category_name_english"] = (
    products["product_category_name_english"].fillna(products["product_category_name"])
)

orders.to_sql("orders", conn, index=False, if_exists="replace")
items.to_sql("order_items", conn, index=False, if_exists="replace")
customers.to_sql("customers", conn, index=False, if_exists="replace")
products.to_sql("products", conn, index=False, if_exists="replace")
sellers.to_sql("sellers", conn, index=False, if_exists="replace")
payments.to_sql("order_payments", conn, index=False, if_exists="replace")
reviews.to_sql("order_reviews", conn, index=False, if_exists="replace")

conn.commit()
conn.close()
print(f"Base de datos creada en {DBPATH} -- ya puedes ejecutar consultas.sql sobre ella.")
