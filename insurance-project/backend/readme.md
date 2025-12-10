# Backend (Node.js + Express)

## Setup (with docker-compose)
You already have the project root `docker-compose.yml` that starts mysql, backend, frontend.

From project root:
  docker compose up --build

This will:
- start mysql (creates insurance_db using db/init.sql)
- build and start backend on port 5000

## API endpoints
Customers:
  GET  /api/customers?q=search      (search or list)
  GET  /api/customers/:id
  POST /api/customers               (body: { name, age, phone })
  PUT  /api/customers/:id
  DELETE /api/customers/:id

Policies:
  GET  /api/policies?q=search
  GET  /api/policies/:id
  POST /api/policies               (body: { customer_id, policy_type, premium })
  PUT  /api/policies/:id
  DELETE /api/policies/:id
