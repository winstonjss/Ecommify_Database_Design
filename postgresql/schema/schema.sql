-- Crear el tipo de datos ADDRESS
CREATE TYPE address_type AS ( line_1 TEXT, line_2 TEXT, neighborhood TEXT, directions TEXT ); 

-- 1. Tablas Maestras (Independientes)
CREATE TABLE geolocations (
    zip_code_prefix INT PRIMARY KEY,
    location GEOMETRY(Point,4326) FLOAT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(2) NOT NULL
);

CREATE TABLE order_statuses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE payment_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Tablas con Dependencias Simples
CREATE TABLE customers (
    identification_number VARCHAR(50) PRIMARY KEY,
    geolocation_zip_code_prefix INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(10) NOT NULL,
    address ADDRESS NOT NULL,
    FOREIGN KEY (geolocation_zip_code_prefix) REFERENCES geolocations(zip_code_prefix)
);

CREATE TABLE sellers (
    id SERIAL PRIMARY KEY,
    zip_code_prefix INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(10) NOT NULL,
    FOREIGN KEY (zip_code_prefix) REFERENCES geolocations(zip_code_prefix)
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    specifications JSONB NOT NULL,
    photos TEXT[],
    FOREIGN KEY (category_id) REFERENCES categories(id)
);


-- 3. Tablas de Procesos (Pedidos y Relacionados)
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_identification_number VARCHAR(50) NOT NULL,
    order_status_id INT NOT NULL,
    purchase_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP,
    delivered_carrier_date TIMESTAMP,
    delivered_customer_date TIMESTAMP,
    estimated_delivery_date TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_identification_number) REFERENCES customers(identification_number),
    FOREIGN KEY (order_status_id) REFERENCES order_statuses(id)
)PARTITION BY RANGE (created_at);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    seller_id INT NOT NULL,
    order_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    shipping_limit_date TIMESTAMP NOT NULL,
    price FLOAT NOT NULL CHECK (price >= 0),
    freight_value FLOAT NOT NULL CHECK (freight_value >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (seller_id) REFERENCES sellers(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
)PARTITION BY RANGE (created_at);

CREATE TABLE order_payments (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    payment_type_id INT NOT NULL,
    sequential INT NOT NULL,
    installments INT NOT NULL CHECK (installments > 0),
    value FLOAT NOT NULL CHECK (value > 0),
    PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (payment_type_id) REFERENCES payment_types(id)
);
