-- ============================================================
-- Lab 10: Azure Database for PostgreSQL
-- SQL Script: Schema Definition + CRUD Operations
-- Database: lab10db
-- Server: lab10-pg-ade.postgres.database.azure.com
-- Author: pgadmin10
-- Date: 2026-06-15
-- ============================================================


-- ------------------------------------------------------------
-- SECTION 1: CREATE TABLES (Schema Definition)
-- ------------------------------------------------------------

-- Customers table: stores customer information
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table: stores orders linked to customers
-- customer_id is a foreign key referencing customers(customer_id)
-- This enforces referential integrity: no order without a valid customer
CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product     VARCHAR(100) NOT NULL,
    quantity    INT NOT NULL,
    order_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ------------------------------------------------------------
-- SECTION 2: INSERT DATA (Create)
-- ------------------------------------------------------------

-- Insert three customers
INSERT INTO customers (name, email) VALUES
    ('Ada Lovelace',  'ada@email.com'),
    ('Alan Turing',   'alan@email.com'),
    ('Grace Hopper',  'grace@email.com');

-- Insert orders linked to customers
INSERT INTO orders (customer_id, product, quantity) VALUES
    (1, 'Laptop',   2),
    (2, 'Keyboard', 1),
    (3, 'Monitor',  3);


-- ------------------------------------------------------------
-- SECTION 3: READ DATA (Select)
-- ------------------------------------------------------------

-- View all customers
SELECT * FROM customers;

-- View all orders
SELECT * FROM orders;

-- Join: view orders with customer names
SELECT
    o.order_id,
    c.name        AS customer_name,
    o.product,
    o.quantity,
    o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;


-- ------------------------------------------------------------
-- SECTION 4: UPDATE DATA (Update)
-- ------------------------------------------------------------

-- Update Alan Turing's email address
UPDATE customers
SET email = 'alan.turing@newmail.com'
WHERE customer_id = 2;

-- Confirm the update
SELECT * FROM customers WHERE customer_id = 2;


-- ------------------------------------------------------------
-- SECTION 5: DELETE DATA (Delete)
-- ------------------------------------------------------------

-- Must delete the order first due to foreign key constraint
-- (cannot delete a customer who still has orders)
DELETE FROM orders
WHERE customer_id = 3;

-- Now safely delete Grace Hopper
DELETE FROM customers
WHERE customer_id = 3;

-- Confirm final state — should show only Ada and Alan
SELECT * FROM customers;
