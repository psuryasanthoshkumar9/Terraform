-- seed.sql
-- Insert sample users, customers, policies and claims


-- App users
INSERT INTO app_users (email, password_hash, role)
VALUES
('admin@insurance.local', 'changeme-hash', 'admin')
ON CONFLICT (email) DO NOTHING;


-- Customers
INSERT INTO customers (first_name, last_name, email, phone, dob)
VALUES
('Krishna', 'Pingala', 'krishna@example.com', '9999999999', '1990-05-20')
ON CONFLICT (email) DO NOTHING;


-- Create a sample policy for the customer
WITH c AS (
SELECT id FROM customers WHERE email = 'krishna@example.com'
)
INSERT INTO policies (policy_number, customer_id, policy_type, start_date, end_date, premium_amount, status)
SELECT 'POL-1001', c.id, 'Term Life', '2025-01-01', '2035-01-01', 12000.00, 'active' FROM c
ON CONFLICT (policy_number) DO NOTHING;


-- Sample claim
WITH p AS (
SELECT id FROM policies WHERE policy_number = 'POL-1001'
)
INSERT INTO claims (claim_number, policy_id, claim_date, amount, status, description)
SELECT 'CLM-1001', p.id, '2025-06-01', 50000.00, 'filed', 'Accidental hospitalization' FROM p
ON CONFLICT (claim_number) DO NOTHING;


-- Sample payment
WITH p AS (
SELECT id FROM policies WHERE policy_number = 'POL-1001'
)
INSERT INTO payments (policy_id, payment_date, amount, payment_method)
SELECT p.id, '2025-01-01', 12000.00, 'online' FROM p;