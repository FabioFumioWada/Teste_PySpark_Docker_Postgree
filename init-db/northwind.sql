-- Este é um script SQL simplificado para criar uma tabela de exemplo
-- e popular o banco de dados 'northwind' para simular o ERP.

-- Tabela de Clientes (Customers)
CREATE TABLE customers (
    customer_id CHAR(5) NOT NULL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24),
    fax VARCHAR(24)
);

-- Inserção de dados de exemplo
INSERT INTO customers (customer_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, fax) VALUES
('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Sales Representative', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', '030-0074321', '030-0076545'),
('ANATR', 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Owner', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico', '(5) 555-4729', '(5) 555-3745'),
('ANTON', 'Antonio Moreno Taquería', 'Antonio Moreno', 'Owner', 'Mataderos 2312', 'México D.F.', NULL, '05023', 'Mexico', '(5) 555-3932', NULL),
('AROUT', 'Around the Horn', 'Thomas Hardy', 'Sales Representative', '120 Hanover Sq.', 'London', NULL, 'WA1 1DP', 'UK', '(171) 555-7788', '(171) 555-6750'),
('BERGS', 'Berglunds snabbköp', 'Christina Berglund', 'Order Administrator', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden', '0921-12 34 65', '0921-12 34 67');

-- Tabela de Pedidos (Orders)
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id CHAR(5) REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    required_date DATE NOT NULL,
    shipped_date DATE,
    freight REAL,
    ship_name VARCHAR(40),
    ship_address VARCHAR(60),
    ship_city VARCHAR(15),
    ship_region VARCHAR(15),
    ship_postal_code VARCHAR(10),
    ship_country VARCHAR(15)
);

-- Inserção de dados de exemplo
INSERT INTO orders (customer_id, order_date, required_date, shipped_date, freight, ship_name, ship_address, ship_city, ship_country) VALUES
('ALFKI', '1996-07-04', '1996-08-01', '1996-07-16', 32.38, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', 'Germany'),
('ANATR', '1996-07-05', '1996-08-02', '1996-07-10', 11.61, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', 'Mexico'),
('ANTON', '1996-07-08', '1996-08-05', '1996-07-12', 51.30, 'Antonio Moreno Taquería', 'Mataderos 2312', 'México D.F.', 'Mexico');
