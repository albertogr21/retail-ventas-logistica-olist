-- ============================================================
-- Panel de ventas y logística — Olist
-- 8 consultas de negocio sobre la base sql/olist.db
-- (cómo se genera esa base: ver sql/README.md)
-- ============================================================

-- 1) Ingresos y número de pedidos por mes
SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS mes,
    COUNT(DISTINCT o.order_id)                     AS pedidos,
    ROUND(SUM(oi.price + oi.freight_value), 2)      AS ingresos
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY mes
ORDER BY mes;


-- 2) Top 10 categorías de producto por ingresos
SELECT
    p.product_category_name_english AS categoria,
    COUNT(*)                        AS unidades_vendidas,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS ingresos
FROM order_items oi
JOIN orders o    ON o.order_id = oi.order_id
JOIN products p  ON p.product_id = oi.product_id
WHERE o.order_status = 'delivered'
GROUP BY categoria
ORDER BY ingresos DESC
LIMIT 10;


-- 3) Top 10 estados de cliente por ingresos
SELECT
    c.customer_state AS estado,
    COUNT(DISTINCT o.order_id) AS pedidos,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS ingresos
FROM order_items oi
JOIN orders o     ON o.order_id = oi.order_id
JOIN customers c  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY estado
ORDER BY ingresos DESC
LIMIT 10;


-- 4) Ticket medio por estado (solo estados con >= 100 pedidos, para que sea representativo)
SELECT
    c.customer_state AS estado,
    COUNT(DISTINCT o.order_id) AS pedidos,
    ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id), 2) AS ticket_medio
FROM order_items oi
JOIN orders o     ON o.order_id = oi.order_id
JOIN customers c  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY estado
HAVING pedidos >= 100
ORDER BY ticket_medio DESC
LIMIT 10;


-- 5) % de pedidos entregados a tiempo por estado (peor a mejor, mínimo 100 pedidos)
SELECT
    c.customer_state AS estado,
    COUNT(*) AS pedidos,
    ROUND(100.0 * SUM(
        CASE WHEN julianday(o.order_delivered_customer_date) <= julianday(o.order_estimated_delivery_date)
             THEN 1 ELSE 0 END
    ) / COUNT(*), 1) AS pct_a_tiempo
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY estado
HAVING pedidos >= 100
ORDER BY pct_a_tiempo ASC
LIMIT 10;


-- 6) Top 10 vendedores por ingresos, con su ciudad y estado
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS pedidos,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS ingresos
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN sellers s  ON s.seller_id = oi.seller_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY ingresos DESC
LIMIT 10;


-- 7) Distribución de métodos de pago
SELECT
    payment_type AS metodo_pago,
    COUNT(DISTINCT order_id) AS pedidos,
    ROUND(100.0 * COUNT(DISTINCT order_id) / (SELECT COUNT(DISTINCT order_id) FROM order_payments), 1) AS pct_pedidos,
    ROUND(AVG(payment_installments), 1) AS cuotas_promedio
FROM order_payments
GROUP BY metodo_pago
ORDER BY pedidos DESC;


-- 8) Categorías con peor puntuación media de reseña (mínimo 30 pedidos, para que sea representativo)
SELECT
    p.product_category_name_english AS categoria,
    COUNT(DISTINCT o.order_id) AS pedidos,
    ROUND(AVG(r.review_score), 2) AS puntuacion_media
FROM order_items oi
JOIN orders o          ON o.order_id = oi.order_id
JOIN products p        ON p.product_id = oi.product_id
JOIN order_reviews r   ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY categoria
HAVING pedidos >= 30
ORDER BY puntuacion_media ASC
LIMIT 10;
