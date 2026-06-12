-- Reporte de Ventas en Tiempo Real
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT 
    DATE_TRUNC('month', o.purchase_timestamp)::DATE AS sales_month,
    c.id AS category_id,
    c.name AS category_name,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.quantity * oi.price)::numeric, 2) AS gross_revenue,
    ROUND(SUM(oi.freight_value)::numeric, 2) AS total_freight_cost
FROM orders o
JOIN order_items oi ON o.id = oi.order_id AND o.created_at = oi.created_at
JOIN products p ON oi.product_id = p.id
JOIN categories c ON p.category_id = c.id
WHERE o.order_status_id NOT IN (SELECT id FROM order_statuses WHERE name = 'Canceled')
GROUP BY 1, 2, 3
ORDER BY sales_month DESC, gross_revenue DESC;

--  Perfil transaccional en el Checkout
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT 
    c.identification_number AS customer_id,
    EXTRACT(DAY FROM NOW() - MAX(o.purchase_timestamp))::INT AS recency_days,
    COUNT(DISTINCT o.id) AS order_frequency,
    ROUND(SUM(oi.quantity * oi.price)::numeric, 2) AS total_monetary_value
FROM customers c
JOIN orders o ON c.identification_number = o.customer_identification_number
JOIN order_items oi ON o.id = oi.order_id AND o.created_at = oi.created_at
WHERE c.identification_number = '123456789' -- Reemplazar por un ID de prueba real
GROUP BY c.identification_number;

-- Historial de Órdenes del Cliente
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT id, order_status_id, purchase_timestamp, estimated_delivery_date
FROM orders
WHERE customer_identification_number = '123456789' -- Reemplazar por ID real
  AND created_at >= '2026-05-01 00:00:00' -- Restringe la búsqueda a la zona HOT
ORDER BY created_at DESC;

-- Búsqueda Semiestructurada de Productos
-- ANTES
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT id, name, specifications, photos
FROM products
WHERE category_id = 5 -- Reemplazar por ID de categoría real
  AND specifications ->> 'brand' = 'Sony' -- Filtro interno de JSONB
  AND specifications ->> 'color' = 'Black'
ORDER BY name ASC
LIMIT 20;

-- DESPUES
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT id, name, specifications, photos
FROM products
WHERE category_id = 5
  -- Cambiamos las flechas ->> por el operador de contención JSONB
  AND specifications @> '{"brand": "Sony", "color": "Black"}'
ORDER BY name ASC
LIMIT 20;

-- Logística Espacial (Cálculo de Distancia Cliente - Vendedor)
EXPLAIN (ANALYZE)
SELECT 
    o.id AS order_id,
    c.identification_number AS customer_id,
    s.id AS seller_id,
    ST_Distance(g_cust.location, g_sell.location) AS distance_meters
FROM orders o
JOIN order_items oi ON o.id = oi.order_id AND o.created_at = oi.created_at
JOIN customers c ON o.customer_identification_number = c.identification_number
JOIN geolocations g_cust ON c.geolocation_zip_code_prefix = g_cust.zip_code_prefix
JOIN sellers s ON oi.seller_id = s.id
JOIN geolocations g_sell ON s.zip_code_prefix = g_sell.zip_code_prefix
WHERE o.id = 98765 -- Reemplazar por ID de orden real
  AND o.created_at >= '2026-05-01 00:00:00';

  
