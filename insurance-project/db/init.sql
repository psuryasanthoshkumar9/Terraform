CREATE DATABASE IF NOT EXISTS insurance;
USE insurance;

CREATE TABLE IF NOT EXISTS policies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    policy_number VARCHAR(20) NOT NULL,
    policy_holder VARCHAR(50) NOT NULL,
    premium DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

INSERT INTO policies (policy_number, policy_holder, premium, start_date, end_date)
VALUES 
('P-1001','John Doe',5000,'2025-01-01','2026-01-01'),
('P-1002','Jane Smith',7500,'2025-03-01','2026-03-01');
