-- Reporte Mensual de Ventas
CREATE INDEX idx_orders_purchase_month ON orders ((DATE_TRUNC('month', purchase_timestamp)::DATE));
CREATE INDEX idx_order_items_composite ON order_items (order_id, created_at);
CREATE INDEX ON public.orders USING btree (order_status_id);
CREATE INDEX ON public.order_items USING btree (order_id);

--  Perfil transaccional en el Checkout
CREATE INDEX idx_orders_customer_id ON orders (customer_identification_number);

--  Historial de Órdenes del Cliente
CREATE INDEX idx_orders_customer_created_at ON orders (customer_identification_number, created_at DESC) INCLUDE (id, order_status_id, purchase_timestamp, estimated_delivery_date);

-- Búsqueda Semiestructurada de Productos
CREATE INDEX idx_products_specifications_gin ON products USING gin (specifications jsonb_path_ops);

-- Logística Espacial (Cálculo de Distancia Cliente - Vendedor)
CREATE INDEX idx_geolocations_zip_prefix ON geolocations (zip_code_prefix);
