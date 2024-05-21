CREATE DATABASE invoicemgmt;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    salt TEXT NOT NULL,
    role VARCHAR(10) CHECK (role IN ('user', 'admin')) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    bank_details TEXT,
    attached_file TEXT,
    user_id UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    current_status VARCHAR(20) NOT NULL
);

CREATE TABLE invoice_status_changes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    invoice_id UUID REFERENCES invoices(id),
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id UUID REFERENCES users(id)
);

-- Create Roles
CREATE ROLE anon;
CREATE ROLE web_user;
CREATE ROLE admin;

-- Grant the roles the necessary permissions
GRANT USAGE ON SCHEMA public TO anon, web_user, admin;
GRANT SELECT ON users, invoices, invoice_status_changes TO web_user, admin;
GRANT INSERT, UPDATE ON invoices TO web_user, admin;
GRANT ALL PRIVILEGES ON users, invoices, invoice_status_changes TO admin;

-- Only allow web_user to update their own invoices
REVOKE UPDATE ON invoices FROM web_user;
GRANT UPDATE (name, date, amount, currency, bank_details, attached_file, current_status) ON invoices TO web_user;

-- Function to allow users to update their own invoices
CREATE OR REPLACE FUNCTION check_user_permission() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'UPDATE' AND NEW.user_id != current_setting('request.jwt.claim.sub', true)) THEN
    RAISE EXCEPTION 'You are only allowed to update your own invoices.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to use the function
CREATE TRIGGER check_user_permission_trigger
BEFORE UPDATE ON invoices
FOR EACH ROW
EXECUTE FUNCTION check_user_permission();



-- Create Users
INSERT INTO users (id, username, password, salt, role, active, created_at) VALUES 
(uuid_generate_v4(), 'user1', '$2y$11$EyRl.gK2fw6QV4WG5e8J4u/wNUut7DUwC1ey3qgFYyCTRMPJz7dsi', '', 'user', TRUE, now()),
(uuid_generate_v4(), 'user2', '$2y$11$EyRl.gK2fw6QV4WG5e8J4u/wNUut7DUwC1ey3qgFYyCTRMPJz7dsi', '', 'user', TRUE, now()),
(uuid_generate_v4(), 'admin1', '$2y$11$EyRl.gK2fw6QV4WG5e8J4u/wNUut7DUwC1ey3qgFYyCTRMPJz7dsi', '', 'admin', TRUE, now()),
(uuid_generate_v4(), 'admin2', '$2y$11$EyRl.gK2fw6QV4WG5e8J4u/wNUut7DUwC1ey3qgFYyCTRMPJz7dsi', '', 'admin', TRUE, now());

== password is "password"

-- TODO: hash passwords

-- Create indexes for faster lookup
CREATE INDEX idx_users_username ON users (username);
CREATE INDEX idx_invoices_user_id ON invoices (user_id);

-- Enable RLS
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoice_status_changes ENABLE ROW LEVEL SECURITY;

-- Policies for users
CREATE POLICY select_invoices ON invoices
    FOR SELECT USING (true);

CREATE POLICY insert_invoices ON invoices
    FOR INSERT WITH CHECK (current_setting('request.jwt.claim.role', true) = 'user');

CREATE POLICY update_own_invoices ON invoices
    FOR UPDATE USING (current_setting('request.jwt.claim.sub', true) = user_id::text)
    WITH CHECK (current_setting('request.jwt.claim.sub', true) = user_id::text);

CREATE POLICY select_invoice_status_changes ON invoice_status_changes
    FOR SELECT USING (true);

CREATE POLICY insert_invoice_status_changes ON invoice_status_changes
    FOR INSERT WITH CHECK (current_setting('request.jwt.claim.role', true) = 'user');
