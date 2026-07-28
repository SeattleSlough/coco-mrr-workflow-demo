CREATE DATABASE IF NOT EXISTS SAAS_BILLING;
CREATE SCHEMA IF NOT EXISTS SAAS_BILLING.RAW;
USE DATABASE SAAS_BILLING;
USE SCHEMA RAW;

CREATE OR REPLACE TABLE RAW.CUSTOMERS (
    customer_id INT,
    name STRING,
    signup_date DATE
);

CREATE OR REPLACE TABLE RAW.SUBSCRIPTIONS (
    subscription_id INT,
    customer_id INT,
    plan_name STRING,
    monthly_price NUMBER(10,2),
    start_date DATE,
    status STRING
);

CREATE OR REPLACE TABLE RAW.PLAN_CHANGES (
    change_id INT,
    subscription_id INT,
    change_date DATE,
    old_plan STRING,
    old_price NUMBER(10,2),
    new_plan STRING,
    new_price NUMBER(10,2)
);

CREATE OR REPLACE TABLE RAW.INVOICES (
    invoice_id INT,
    subscription_id INT,
    invoice_date DATE,
    amount NUMBER(10,2)
);

CREATE OR REPLACE TABLE RAW.CANCELLATIONS (
    cancellation_id INT,
    subscription_id INT,
    cancellation_date DATE,
    reason STRING
);

INSERT INTO RAW.CUSTOMERS VALUES
  (1, 'Acme Co', '2025-01-10'),
  (2, 'Beta LLC', '2025-01-15'),
  (3, 'Gamma Inc', '2025-02-01'),
  (4, 'Delta Systems', '2025-02-10'),
  (5, 'Epsilon Group', '2025-03-01');

INSERT INTO RAW.SUBSCRIPTIONS VALUES
  (1, 1, 'Starter', 29.00, '2025-01-10', 'active'),
  (2, 2, 'Pro', 79.00, '2025-01-15', 'active'),
  (3, 3, 'Starter', 29.00, '2025-02-01', 'active'),
  (4, 4, 'Pro', 79.00, '2025-02-10', 'cancelled'),
  (5, 5, 'Enterprise', 199.00, '2025-03-01', 'active');

INSERT INTO RAW.PLAN_CHANGES VALUES
  (1, 1, '2025-03-01', 'Starter', 29.00, 'Pro', 79.00),
  (2, 3, '2025-04-01', 'Starter', 29.00, 'Enterprise', 199.00);

INSERT INTO RAW.INVOICES VALUES
  (1, 1, '2025-01-10', 29.00),
  (2, 1, '2025-02-10', 29.00),
  (3, 1, '2025-03-10', 79.00),
  (4, 1, '2025-04-10', 79.00),
  (5, 2, '2025-01-15', 79.00),
  (6, 2, '2025-02-15', 79.00),
  (7, 2, '2025-03-15', 79.00),
  (8, 2, '2025-04-15', 79.00),
  (9, 3, '2025-02-01', 29.00),
  (10, 3, '2025-03-01', 29.00),
  (11, 3, '2025-04-01', 199.00),
  (12, 4, '2025-02-10', 79.00),
  (13, 4, '2025-03-10', 79.00),
  (14, 5, '2025-03-01', 199.00),
  (15, 5, '2025-04-01', 199.00);

INSERT INTO RAW.CANCELLATIONS VALUES
  (1, 4, '2025-03-25', 'budget cuts');