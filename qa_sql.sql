-- SQL для тестирования БД

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    status VARCHAR(20),
    balance DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_num VARCHAR(50) UNIQUE,
    amount DECIMAL(10,2),
    tax DECIMAL(10,2),
    total DECIMAL(10,2),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    qty INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO users VALUES
(1, 'john', 'john@test.com', 'active', 1500.00, NOW()),
(2, 'jane', 'jane@test.com', 'active', -100.00, NOW()),
(3, 'test', 'test@test.com', 'banned', 0.00, NOW());

INSERT INTO products VALUES
(1, 'Laptop', 999.99, 5),
(2, 'Mouse', 29.99, -5),
(3, 'Keyboard', 79.99, 0);

INSERT INTO orders VALUES
(1, 1, 'ORD-001', 999.99, 100.00, 1099.99, 'completed', NOW()),
(2, 2, 'ORD-002', 79.99, 8.00, 87.99, 'pending', NOW()),
(3, 5, 'ORD-003', 50.00, 5.00, 55.00, 'completed', NOW());

INSERT INTO order_items VALUES
(1, 1, 1, 1),
(2, 2, 3, 1),
(3, 3, 1, 2);

-- проверка orphaned заказов (заказ без юзера)
-- SELECT * FROM orders o WHERE NOT EXISTS (SELECT 1 FROM users u WHERE u.id = o.user_id);

-- ошибка в расчетах (total должна быть = amount + tax)
-- SELECT id, amount, tax, total, (amount + tax) as should_be FROM orders WHERE total != (amount + tax);

-- товары с отрицательным стоком
-- SELECT name, stock FROM products WHERE stock < 0;

-- юзеры с отрицательным балансом
-- SELECT username, balance FROM users WHERE balance < 0;

-- заказы без товаров
-- SELECT o.id FROM orders o WHERE NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.order_id = o.id);

-- все ордеры юзера
-- SELECT * FROM orders WHERE user_id = 1 ORDER BY created_at DESC;

-- сколько потратил юзер
-- SELECT SUM(total) FROM orders WHERE user_id = 1 AND status = 'completed';
