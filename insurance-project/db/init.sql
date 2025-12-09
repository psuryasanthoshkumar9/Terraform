-- init.sql
-- Creates schema and tables for the insurance app


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- Users (for backend authentication)
CREATE TABLE IF NOT EXISTS app_users (
id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
email VARCHAR(255) UNIQUE NOT NULL,
password_hash VARCHAR(255) NOT NULL,
role VARCHAR(50) NOT NULL DEFAULT 'agent', -- agent, admin, customer
created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);


-- Customers
CREATE TABLE IF NOT EXISTS customers (
id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100),
email VARCHAR(255) UNIQUE NOT NULL,
phone VARCHAR(30),
dob DATE,
created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);


-- Policies
CREATE TABLE IF NOT EXISTS policies (
id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
policy_number VARCHAR(50) UNIQUE NOT NULL,
customer_id UUID REFERENCES customers(id) ON DELETE CASCADE,
policy_type VARCHAR(100) NOT NULL,
start_date DATE NOT NULL,
end_date DATE NOT NULL,
premium_amount NUMERIC(12,2) NOT NULL,
status VARCHAR(50) NOT NULL DEFAULT 'active', -- active, lapsed, cancelled
created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);


-- Claims
CREATE TABLE IF NOT EXISTS claims (
id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
claim_number VARCHAR(50) UNIQUE NOT NULL,
policy_id UUID REFERENCES policies(id) ON DELETE CASCADE,
claim_date DATE NOT NULL,
amount NUMERIC(12,2) NOT NULL,
status VARCHAR(50) NOT NULL DEFAULT 'filed', -- filed, approved, rejected, paid
description TEXT,
created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);


-- Payments
CREATE TABLE IF NOT EXISTS payments (
id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
policy_id UUID REFERENCES policies(id) ON DELETE CASCADE,
payment_date DATE NOT NULL,
amount NUMERIC(12,2) NOT NULL,
payment_method VARCHAR(50),
created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);


-- Indexes to speed up common queries
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_policies_policy_number ON policies(policy_number);
CREATE INDEX IF NOT EXISTS idx_claims_claim_number ON claims(claim_number);