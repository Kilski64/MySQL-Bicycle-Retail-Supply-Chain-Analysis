-- Connect to a database --

SHOW DATABASES;
USE bicycles_db;

-- SET UP DATABASE --
-- CREATE TABLES --

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    brand_id INT,
    category_id INT,
    model_year INT,
    list_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE staffs (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    active TINYINT NOT NULL DEFAULT 1, -- Assuming 1=active, 0=inactive
    store_id INT,
    manager_id INT NULL
);

CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT NOT NULL DEFAULT 0,
    PRIMARY KEY (store_id, product_id) -- Composite key
);

CREATE TABLE stores (
    store_id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10)
);

CREATE TABLE brands (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10)
);

CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT NOT NULL DEFAULT 1,
    list_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0.00,
    PRIMARY KEY (order_id, item_id) -- Composite key
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_status VARCHAR(20) NOT NULL,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    store_id INT NULL,
    staff_id INT
);

SHOW TABLES;

-- INSERT EXCEL DATA INTO MYSQL --
LOAD DATA INFILE 'C:\\Users\\bgkil\\Downloads\\mysql database analysis/brands.csv' INTO TABLE brands FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (brand_id, brand_name);
LOAD DATA INFILE 'C:\\Users\\bgkil\\Downloads\\mysql database analysis/categories.csv' INTO TABLE categories FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (category_id, category_name);
LOAD DATA INFILE 'C:\\Users\\bgkil\\Downloads\\mysql database analysis/customers.csv' INTO TABLE customers FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (customer_id, first_name, last_name, phone, email, street, city, state, zip_code);
LOAD DATA INFILE 'C:\\Users\\bgkil\\Downloads\\mysql database analysis/orders.csv' INTO TABLE orders FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (order_id, customer_id, order_status, order_date, required_date, shipped_date, @store_id, staff_id) SET store_id = CASE WHEN @store_id REGEXP '^[0-9]+$' THEN @store_id ELSE NULL END;
LOAD DATA INFILE 'C:\\Users\\bgkil\\Downloads\\mysql database analysis/order_items.csv' INTO TABLE order_items FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (order_id, item_id, product_id, quantity, list_price, discount);
LOAD DATA INFILE 'C:\\Users\\bgkil\\Downloads\\mysql database analysis/products.csv' INTO TABLE products FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (product_id, product_name, brand_id, category_id, model_year, list_price);
LOAD DATA INFILE 'C:\\Users\\bgkil\\Downloads\\mysql database analysis/staffs.csv' INTO TABLE staffs FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (staff_id, first_name, last_name, email, phone, active, store_id, @manager_id) SET manager_id = CASE WHEN @manager_id REGEXP '^[0-9]+$' THEN @manager_id ELSE NULL END;
LOAD DATA INFILE 'C:\\Users\\bgkil\\Downloads\\mysql database analysis/stocks.csv' INTO TABLE stocks FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (store_id, product_id, quantity);
LOAD DATA INFILE 'C:\\Users\\bgkil\\Downloads\\mysql database analysis/stores.csv' INTO TABLE stores FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (store_id, store_name, phone, email, street, city, state, zip_code);

-- VIEW DATA IN TABLES--
SELECT * FROM products LIMIT 5;
SELECT * FROM staffs LIMIT 5;
SELECT * FROM stocks LIMIT 5;
SELECT * FROM stores LIMIT 5;
SELECT * FROM brands LIMIT 5;
SELECT * FROM categories LIMIT 5;
SELECT * FROM customers LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM orders LIMIT 5;

-- VIEW TABLES ATTRIBUTES --
DESCRIBE products;
DESCRIBE staffs;
DESCRIBE stocks;
DESCRIBE stores;
DESCRIBE brands;
DESCRIBE categories;
DESCRIBE customers;
DESCRIBE order_items;
DESCRIBE orders;

-- DELETE TABLES --
DROP TABLE products;
DROP TABLE staffs;
DROP TABLE stocks;
DROP TABLE stores;
DROP TABLE brands;
DROP TABLE categories;
DROP TABLE customers;
DROP TABLE order_items;
DROP TABLE orders;

-- ERASE CONTENT IN TABLES --
TRUNCATE TABLE products;
TRUNCATE TABLE staffs;
TRUNCATE TABLE stocks;
TRUNCATE TABLE stores;
TRUNCATE TABLE brands;
TRUNCATE TABLE categories;
TRUNCATE TABLE customers;
TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;

-- SHOW FILE PATH TO DISABLE SECURE_FILE_PRIV --
SHOW VARIABLES LIKE 'secure_file_priv';

-- CUSTOMER RELATED INFORMATION --
-- Which customers have made the most purchases in terms of total order value? --
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.list_price * (1-oi.discount)) AS total_order_value
FROM 
    customers c
INNER JOIN
    orders o ON c.customer_id = o.customer_id
INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    c.customer_id, c.first_name, c.last_name
ORDER BY
    total_order_value DESC
LIMIT 1;

-- How many customers are from each state? --
SELECT
    state,
    COUNT(customer_id) AS customer_count
FROM
    customers
GROUP BY
    state
ORDER BY
    state ASC;

-- How many customers are from each city? --
SELECT
    city,
    COUNT(customer_id) AS customer_count
FROM
    customers
GROUP BY
    city
ORDER BY
    city ASC;

-- Which customers haven't placed an order in the last 6 months? --
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM
    customers c
LEFT JOIN
    orders o ON c.customer_id = o.customer_id
    AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
WHERE
    o.order_id IS NULL
ORDER BY
    c.customer_id;

-- What is the average number of orders per customer? --
SELECT
    AVG(order_count) AS avg_orders_per_customer
FROM (
    SELECT 
        c.customer_id,
        COUNT(o.order_id) AS order_count
    FROM 
        customers c
    LEFT JOIN 
        orders o ON c.customer_id = o.customer_id
    GROUP BY 
        c.customer_id
) AS customer_orders;

-- Which customers have email addresses from a specific domain (e.g., '@gmail.com')? --
SELECT
    customer_id,
    first_name,
    last_name,
    email 
FROM
    customers
WHERE
    email like '%@gmail.com'
ORDER BY
    customer_id;


-- ORDER RELATED QUESTIONS --
-- What is the total revenue generated by orders in a specific year (e.g., 2024)? --

SELECT
    YEAR(o.order_date) AS order_year,
    SUM(oi.quantity * oi.list_price * (1-oi.discount)) AS total_sales
FROM
    orders o
INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_date)
ORDER BY
    order_year ASC;

-- Which month has the highest number of orders? --

SELECT
    MONTH(order_date) AS order_month,
    COUNT(order_id) AS order_count
FROM
    orders
GROUP BY
    MONTH(order_date)
ORDER BY
    order_count DESC
LIMIT 1;

-- What is the average order value per store? --

SELECT
    s.store_id,
    s.store_name,
    AVG(order_value) AS avg_order_value
FROM
    store s
LEFT JOIN
    orders o ON s.store_id = o.store_id
LEFT JOIN (
    SELECT
        order_id,
        SUM(quantity * list_price * (1 - discount)) AS order_value
    FROM
        order_items
    GROUP BY
        order_id
) oi ON o.order_id = oi.order_id
GROUP BY
    s.store_id, s.store_name
ORDER BY
    s.store_id;

-- Which products have a list price above the average price of all products? --
SELECT
    product_id,
    product_name,
    list_price
FROM
    products
WHERE
    list_price > (SELECT AVG(list_price) FROM products)
ORDER BY
    list_price ASC;

-- STORE AND STAFF RELATED QUESTIONS --
-- Which store has the highest total sales? --
SELECT
    s.store_id,
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1-oi.discount)) AS total_sales
FROM
    stores s
INNER JOIN
    orders o ON s.store_id = o.store_id
INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    s.store_id,
    s.store_name
ORDER BY
    total_sales DESC
LIMIT 1;

-- How many staff members work at each store? --
SELECT
    s.store_id,
    s.store_name,
    COUNT(DISTINCT st.staff_id) AS staff_count
FROM
    stores s
LEFT JOIN
    staffs st ON s.store_id = st.store_id
GROUP BY
    s.store_id,
    s.store_name
ORDER BY
    s.store_name;

-- Which staff member has processed the most orders? --
SELECT
    st.staff_id,
    st.first_name,
    st.last_name,
    COUNT(o.staff_id) AS order_count
FROM
    staffs st
LEFT JOIN
    orders o ON st.staff_id = o.staff_id
GROUP BY
    st.staff_id,
    st.first_name,
    st.last_name
ORDER BY
    order_count DESC
LIMIT 1;

-- What is the total revenue generated by orders handled by each staff member? --
SELECT 
    s.staff_id,
    s.first_name,
    s.last_name,
    COALESCE(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_revenue
FROM 
    staffs s
LEFT JOIN 
    orders o ON s.staff_id = o.staff_id
LEFT JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    s.staff_id, s.first_name, s.last_name
ORDER BY 
    total_revenue DESC;

-- MIXED ANALYTICS QUESTIONS --
-- Which customers ordered the most expensive products? --
WITH max_price AS (
    SELECT
        MAX(list_price) AS highest_price
    FROM
        order_items
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    p.product_name,
    p.list_price
FROM
    customers c
INNER JOIN
    orders o ON c.customer_id = o.customer_id
INNER JOIN
    order_items oi ON o.order_id = oi.order_id
INNER JOIN
    products p ON oi.product_id = p.product_id
INNER JOIN
    max_price mp 
WHERE
    oi.list_price = mp.highest_price
ORDER BY
    c.customer_id,
    c.first_name,
    c.last_name,
    p.product_name,
    p.list_price DESC;
    
-- What is the total discount applied to orders per customer? --
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COALESCE(ROUND(SUM(oi.quantity * oi.list_price * oi.discount), 2), 0) AS total_discount
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
LEFT JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    total_discount DESC;

-- Which product categories are most popular in each state? --
WITH state_category_totals AS (
    SELECT
        c.state,
        cat.category_id,
        cat.category_name,
        SUM(oi.quantity) AS total_quantity,
        ROW_NUMBER() OVER (PARTITION BY c.state ORDER BY SUM(oi.quantity) DESC) AS rnk
    FROM
        customers c
    INNER JOIN
        orders o ON c.customer_id = o.customer_id
    INNER JOIN
        order_items oi ON o.order_id = oi.order_id
    INNER JOIN
        products p ON oi.product_id = p.product_id
    INNER JOIN
        categories cat ON p.category_id = cat.category_id
    GROUP BY
        c.state, cat.category_id, cat.category_name
)
SELECT
    state,
    category_id,
    category_name,
    total_quantity
FROM
    state_category_totals
WHERE
    rnk = 1
ORDER BY
    total_quantity DESC;
-- How many orders were placed by customers who live in the same city as the store? --
SELECT 
    COUNT(*) AS same_city_orders
FROM 
    customers c
INNER JOIN 
    orders o ON c.customer_id = o.customer_id
INNER JOIN 
    stores s ON o.store_id = s.store_id
WHERE 
    c.city = s.city;

-- Aggregation and Trends --
-- What is the year-over-year growth in order volume? --
WITH yearly_orders AS (
    SELECT
        YEAR(order_date) AS order_year,
        COUNT(order_id) AS order_count
    FROM
        orders
    GROUP BY
        YEAR(order_date)
)
SELECT
    order_year,
    order_count AS current_year_orders,
    LAG(order_count) OVER (ORDER BY order_year) AS previous_year_orders,
    ROUND(
        CASE
            WHEN LAG(order_count) OVER (ORDER BY order_year) IS NULL THEN NULL
            ELSE ((order_count - LAG(order_count) OVER (ORDER BY order_year)) / LAG(order_count) OVER (ORDER BY order_year)) * 100
        END,
        2
    ) AS yoy_growth_percent
FROM
    yearly_orders
ORDER BY
    order_year;
-- Which day of the week has the most orders? --
SELECT
    DAYNAME(order_date) AS day_of_week,
    COUNT(order_id) AS order_count
FROM
    orders
GROUP BY
    DAYNAME(order_date)
ORDER BY
    order_count DESC
LIMIT 1;
-- How many customers made repeat purchases (more than one order)? --
SELECT 
    COUNT(*) AS repeat_customers
FROM (
    SELECT 
        customer_id
    FROM 
        orders
    GROUP BY 
        customer_id
    HAVING 
        COUNT(order_id) > 1
) AS repeaters;

-- What is the average time between order placement and shipment? --
SELECT 
    ROUND(AVG(DATEDIFF(shipped_date, order_date)), 2) AS avg_days_to_ship
FROM 
    orders
WHERE 
    shipped_date IS NOT NULL;












































