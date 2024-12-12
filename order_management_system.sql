-- Database Schema for E-commerce Order Management System

-- Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Addresses table
CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    address_id INT NOT NULL REFERENCES addresses(address_id) ON DELETE RESTRICT,
    status VARCHAR(50) DEFAULT 'Pending',
    total_price NUMERIC(10, 2) NOT NULL CHECK (total_price >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order items table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for optimization
CREATE INDEX idx_customer_email ON customers(email);
CREATE INDEX idx_product_name ON products(name);
CREATE INDEX idx_order_customer_id ON orders(customer_id);
CREATE INDEX idx_order_item_order_id ON order_items(order_id);

-- Populate tables with sample data

-- Insert customers
INSERT INTO customers (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321');

-- Insert addresses
INSERT INTO addresses (customer_id, address_line1, address_line2, city, state, postal_code, country) VALUES
(1, '123 Main St', NULL, 'Springfield', 'IL', '62701', 'USA'),
(2, '456 Elm St', 'Apt 5', 'Greenville', 'NC', '27858', 'USA');

-- Insert products
INSERT INTO products (name, description, price, stock) VALUES
('Laptop', '15-inch display, 256GB SSD', 999.99, 50),
('Headphones', 'Noise-cancelling over-ear headphones', 199.99, 200),
('Mouse', 'Wireless ergonomic mouse', 49.99, 150);

-- Insert orders
INSERT INTO orders (customer_id, address_id, status, total_price) VALUES
(1, 1, 'Pending', 1249.97),
(2, 2, 'Completed', 249.98);

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),
(1, 2, 1, 199.99),
(1, 3, 1, 49.99),
(2, 2, 1, 199.99),
(2, 3, 1, 49.99);


-- Example Queries

-- 1. Retrieve all customers and their associated addresses:
SELECT c.customer_id, c.first_name, c.last_name, c.email, a.address_line1, a.city, a.state, a.postal_code, a.country
FROM customers c
LEFT JOIN addresses a ON c.customer_id = a.customer_id;

-- 2. List all products with their stock and price:
SELECT product_id, name, stock, price FROM products;

-- 3. Get details of all orders with their total price and customer information:
SELECT o.order_id, o.total_price, o.status, c.first_name, c.last_name, c.email
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- 4. Retrieve all items in a specific order (e.g., order_id = 1):
SELECT oi.order_item_id, p.name, oi.quantity, oi.unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = 1;

-- 5. Calculate the total revenue from completed orders:
SELECT SUM(total_price) AS total_revenue
FROM orders
WHERE status = 'Completed';

-- 6. Check stock availability for a specific product (e.g., product_id = 1):
SELECT name, stock FROM products WHERE product_id = 1;

-- 7. Retrieve orders for a specific customer (e.g., customer_id = 1):
SELECT o.order_id, o.total_price, o.status, o.created_at
FROM orders o
WHERE o.customer_id = 1;