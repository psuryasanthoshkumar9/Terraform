CREATE TABLE customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  age INT,
  phone VARCHAR(20)
);

CREATE TABLE policies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  policy_type VARCHAR(100),
  premium DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES customers(id)
);
