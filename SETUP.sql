-- =============================================
-- SQL 100 CHALLENGE SERIES - DATABASE SETUP
-- Two 2NF Databases: COMPANY_DB and SCHOOL_DB
-- Contains intentional data quality issues for discovery
-- =============================================

-- =============================================
-- DATABASE 1: COMPANY_DB
-- =============================================

DROP DATABASE IF EXISTS company_db;
CREATE DATABASE company_db;
USE company_db;

-- Departments Table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    budget DECIMAL(15,2),
    location VARCHAR(50),
    established_date DATE,
    is_active TINYINT(1)
);

-- Employees Table (has orphan records, duplicate emails, NULL traps)
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    termination_date DATE,
    dept_id INT,
    manager_id INT,
    salary DECIMAL(12,2),
    commission_pct DECIMAL(4,2),
    job_title VARCHAR(50),
    employment_type VARCHAR(20),
    is_active TINYINT(1),
    created_at DATETIME,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

-- Projects Table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(15,2),
    actual_cost DECIMAL(15,2),
    status VARCHAR(20),
    priority VARCHAR(10),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Employee_Projects (Many-to-Many with hours worked)
CREATE TABLE employee_projects (
    emp_id INT,
    project_id INT,
    role VARCHAR(50),
    hours_worked DECIMAL(8,2),
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Salaries History (for tracking raises, has gaps and overlaps)
CREATE TABLE salary_history (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    salary DECIMAL(12,2),
    effective_date DATE,
    end_date DATE,
    change_reason VARCHAR(50),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Clients Table
CREATE TABLE clients (
    client_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    contact_name VARCHAR(100),
    contact_email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    industry VARCHAR(50),
    annual_revenue DECIMAL(15,2),
    employee_count INT,
    acquisition_date DATE,
    is_active TINYINT(1)
);

-- Contracts Table (links clients to projects)
CREATE TABLE contracts (
    contract_id INT PRIMARY KEY,
    client_id INT,
    project_id INT,
    contract_value DECIMAL(15,2),
    start_date DATE,
    end_date DATE,
    payment_terms VARCHAR(50),
    status VARCHAR(20),
    signed_date DATE,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Invoices Table
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY,
    contract_id INT,
    invoice_date DATE,
    due_date DATE,
    amount DECIMAL(12,2),
    tax_amount DECIMAL(10,2),
    total_amount DECIMAL(12,2),
    status VARCHAR(20),
    paid_date DATE,
    paid_amount DECIMAL(12,2),
    FOREIGN KEY (contract_id) REFERENCES contracts(contract_id)
);

-- Expenses Table
CREATE TABLE expenses (
    expense_id INT PRIMARY KEY,
    emp_id INT,
    project_id INT,
    expense_date DATE,
    category VARCHAR(50),
    description VARCHAR(200),
    amount DECIMAL(10,2),
    status VARCHAR(20),
    approved_by INT,
    approved_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (approved_by) REFERENCES employees(emp_id)
);

-- Performance Reviews
CREATE TABLE performance_reviews (
    review_id INT PRIMARY KEY,
    emp_id INT,
    reviewer_id INT,
    review_date DATE,
    review_period_start DATE,
    review_period_end DATE,
    rating INT,
    goals_met_pct DECIMAL(5,2),
    comments TEXT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (reviewer_id) REFERENCES employees(emp_id)
);

-- Office Locations
CREATE TABLE office_locations (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(50),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    country VARCHAR(50),
    capacity INT,
    monthly_rent DECIMAL(12,2),
    lease_start DATE,
    lease_end DATE
);

-- Employee Attendance (has missing punches, anomalies)
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    work_date DATE,
    clock_in TIME,
    clock_out TIME,
    hours_worked DECIMAL(5,2),
    status VARCHAR(20),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Leave Requests
CREATE TABLE leave_requests (
    leave_id INT PRIMARY KEY,
    emp_id INT,
    leave_type VARCHAR(30),
    start_date DATE,
    end_date DATE,
    days_requested DECIMAL(4,1),
    status VARCHAR(20),
    approved_by INT,
    request_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (approved_by) REFERENCES employees(emp_id)
);

-- Skills Table
CREATE TABLE skills (
    skill_id INT PRIMARY KEY,
    skill_name VARCHAR(50),
    category VARCHAR(30)
);

-- Employee Skills (Many-to-Many)
CREATE TABLE employee_skills (
    emp_id INT,
    skill_id INT,
    proficiency_level INT,
    years_experience DECIMAL(4,1),
    last_used_date DATE,
    PRIMARY KEY (emp_id, skill_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);

-- Training Programs
CREATE TABLE training_programs (
    training_id INT PRIMARY KEY,
    program_name VARCHAR(100),
    description TEXT,
    duration_hours INT,
    cost DECIMAL(10,2),
    provider VARCHAR(100),
    is_mandatory TINYINT(1)
);

-- Employee Training (enrollment and completion)
CREATE TABLE employee_training (
    emp_id INT,
    training_id INT,
    enrollment_date DATE,
    completion_date DATE,
    score DECIMAL(5,2),
    status VARCHAR(20),
    PRIMARY KEY (emp_id, training_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (training_id) REFERENCES training_programs(training_id)
);

-- =============================================
-- POPULATING COMPANY_DB DATA
-- =============================================

-- Departments (including one inactive, one with NULL budget)
INSERT INTO departments VALUES
(1, 'Engineering', 2500000.00, 'New York', '2010-01-15', 1),
(2, 'Marketing', 1200000.00, 'Los Angeles', '2010-03-20', 1),
(3, 'Sales', 1800000.00, 'Chicago', '2010-01-15', 1),
(4, 'Human Resources', 800000.00, 'New York', '2010-06-01', 1),
(5, 'Finance', 950000.00, 'New York', '2010-01-15', 1),
(6, 'Operations', 1500000.00, 'Dallas', '2012-08-10', 1),
(7, 'Legal', 600000.00, 'New York', '2011-04-15', 1),
(8, 'Research', NULL, 'Boston', '2015-09-01', 1),
(9, 'Customer Support', 700000.00, 'Phoenix', '2013-02-28', 1),
(10, 'IT Infrastructure', 1100000.00, 'Seattle', '2011-11-11', 1),
(11, 'Product', 1400000.00, 'San Francisco', '2014-07-07', 1),
(12, 'Defunct Division', 0.00, 'Detroit', '2008-01-01', 0);

-- Employees (50 rows with various traps)
-- Traps: duplicate emails, orphan dept references fixed, NULL salaries, terminated but is_active=1, circular manager refs, future hire dates
INSERT INTO employees VALUES
(1, 'Michael', 'Anderson', 'manderson@company.com', '212-555-0101', '2010-01-15', NULL, 1, NULL, 185000.00, NULL, 'CTO', 'Full-time', 1, '2010-01-15 09:00:00'),
(2, 'Sarah', 'Williams', 'swilliams@company.com', '212-555-0102', '2010-02-01', NULL, 1, 1, 145000.00, NULL, 'VP Engineering', 'Full-time', 1, '2010-02-01 09:00:00'),
(3, 'James', 'Johnson', 'jjohnson@company.com', '212-555-0103', '2010-03-15', NULL, 1, 2, 125000.00, NULL, 'Senior Engineer', 'Full-time', 1, '2010-03-15 09:00:00'),
(4, 'Emily', 'Brown', 'ebrown@company.com', '310-555-0104', '2010-04-01', NULL, 2, NULL, 160000.00, NULL, 'VP Marketing', 'Full-time', 1, '2010-04-01 09:00:00'),
(5, 'David', 'Miller', 'dmiller@company.com', '312-555-0105', '2010-05-15', NULL, 3, NULL, 170000.00, 0.15, 'VP Sales', 'Full-time', 1, '2010-05-15 09:00:00'),
(6, 'Jennifer', 'Davis', 'jdavis@company.com', '212-555-0106', '2011-01-10', NULL, 4, NULL, 130000.00, NULL, 'HR Director', 'Full-time', 1, '2011-01-10 09:00:00'),
(7, 'Robert', 'Wilson', 'rwilson@company.com', '212-555-0107', '2011-02-15', NULL, 5, NULL, 155000.00, NULL, 'CFO', 'Full-time', 1, '2011-02-15 09:00:00'),
(8, 'Jessica', 'Taylor', 'jtaylor@company.com', '214-555-0108', '2012-03-01', NULL, 6, NULL, 140000.00, NULL, 'Operations Director', 'Full-time', 1, '2012-03-01 09:00:00'),
(9, 'Christopher', 'Moore', 'cmoore@company.com', '212-555-0109', '2011-06-15', NULL, 7, NULL, 175000.00, NULL, 'General Counsel', 'Full-time', 1, '2011-06-15 09:00:00'),
(10, 'Amanda', 'White', 'awhite@company.com', '617-555-0110', '2015-09-15', NULL, 8, NULL, 165000.00, NULL, 'Research Director', 'Full-time', 1, '2015-09-15 09:00:00'),
(11, 'Matthew', 'Harris', 'mharris@company.com', '602-555-0111', '2013-04-01', NULL, 9, NULL, 120000.00, NULL, 'Support Manager', 'Full-time', 1, '2013-04-01 09:00:00'),
(12, 'Ashley', 'Clark', 'aclark@company.com', '206-555-0112', '2012-01-15', NULL, 10, NULL, 145000.00, NULL, 'IT Director', 'Full-time', 1, '2012-01-15 09:00:00'),
(13, 'Daniel', 'Lewis', 'dlewis@company.com', '415-555-0113', '2014-08-01', NULL, 11, NULL, 170000.00, NULL, 'Product Director', 'Full-time', 1, '2014-08-01 09:00:00'),
(14, 'Nicole', 'Robinson', 'nrobinson@company.com', '212-555-0114', '2012-06-15', NULL, 1, 2, 115000.00, NULL, 'Software Engineer', 'Full-time', 1, '2012-06-15 09:00:00'),
(15, 'Andrew', 'Martinez', 'amartinez@company.com', '212-555-0115', '2013-02-01', NULL, 1, 2, 118000.00, NULL, 'Software Engineer', 'Full-time', 1, '2013-02-01 09:00:00'),
(16, 'Stephanie', 'Garcia', 'sgarcia@company.com', '212-555-0116', '2014-07-15', NULL, 1, 3, 95000.00, NULL, 'Junior Engineer', 'Full-time', 1, '2014-07-15 09:00:00'),
(17, 'Joshua', 'Lee', 'jlee@company.com', '212-555-0117', '2015-03-01', NULL, 1, 3, 92000.00, NULL, 'Junior Engineer', 'Full-time', 1, '2015-03-01 09:00:00'),
(18, 'Lauren', 'Walker', 'lwalker@company.com', '310-555-0118', '2011-09-15', NULL, 2, 4, 95000.00, NULL, 'Marketing Manager', 'Full-time', 1, '2011-09-15 09:00:00'),
(19, 'Ryan', 'Hall', 'rhall@company.com', '310-555-0119', '2013-05-01', NULL, 2, 18, 72000.00, NULL, 'Marketing Specialist', 'Full-time', 1, '2013-05-01 09:00:00'),
(20, 'Megan', 'Allen', 'mallen@company.com', '310-555-0120', '2014-11-15', NULL, 2, 18, 68000.00, NULL, 'Marketing Coordinator', 'Full-time', 1, '2014-11-15 09:00:00'),
(21, 'Kevin', 'Young', 'kyoung@company.com', '312-555-0121', '2011-04-01', NULL, 3, 5, 95000.00, 0.12, 'Sales Manager', 'Full-time', 1, '2011-04-01 09:00:00'),
(22, 'Rachel', 'King', 'rking@company.com', '312-555-0122', '2012-08-15', NULL, 3, 21, 75000.00, 0.10, 'Sales Representative', 'Full-time', 1, '2012-08-15 09:00:00'),
(23, 'Brandon', 'Wright', 'bwright@company.com', '312-555-0123', '2013-12-01', NULL, 3, 21, 72000.00, 0.10, 'Sales Representative', 'Full-time', 1, '2013-12-01 09:00:00'),
(24, 'Amber', 'Scott', 'ascott@company.com', '312-555-0124', '2015-06-15', NULL, 3, 21, 65000.00, 0.08, 'Junior Sales Rep', 'Full-time', 1, '2015-06-15 09:00:00'),
(25, 'Justin', 'Green', 'jgreen@company.com', '212-555-0125', '2012-02-01', NULL, 4, 6, 85000.00, NULL, 'HR Manager', 'Full-time', 1, '2012-02-01 09:00:00'),
(26, 'Brittany', 'Adams', 'badams@company.com', '212-555-0126', '2014-04-15', NULL, 4, 25, 62000.00, NULL, 'HR Specialist', 'Full-time', 1, '2014-04-15 09:00:00'),
(27, 'Tyler', 'Nelson', 'tnelson@company.com', '212-555-0127', '2013-07-01', NULL, 5, 7, 95000.00, NULL, 'Senior Accountant', 'Full-time', 1, '2013-07-01 09:00:00'),
(28, 'Samantha', 'Carter', 'scarter@company.com', '212-555-0128', '2015-01-15', NULL, 5, 27, 72000.00, NULL, 'Accountant', 'Full-time', 1, '2015-01-15 09:00:00'),
(29, 'Jason', 'Mitchell', 'jmitchell@company.com', '214-555-0129', '2013-10-01', NULL, 6, 8, 88000.00, NULL, 'Operations Manager', 'Full-time', 1, '2013-10-01 09:00:00'),
(30, 'Heather', 'Perez', 'hperez@company.com', '214-555-0130', '2015-04-15', NULL, 6, 29, 58000.00, NULL, 'Operations Analyst', 'Full-time', 1, '2015-04-15 09:00:00'),
-- Terminated employee still marked active (TRAP)
(31, 'Eric', 'Roberts', 'eroberts@company.com', '212-555-0131', '2014-01-15', '2023-06-30', 7, 9, 125000.00, NULL, 'Associate Counsel', 'Full-time', 1, '2014-01-15 09:00:00'),
(32, 'Michelle', 'Turner', 'mturner@company.com', '617-555-0132', '2016-02-01', NULL, 8, 10, 110000.00, NULL, 'Research Scientist', 'Full-time', 1, '2016-02-01 09:00:00'),
(33, 'Jacob', 'Phillips', 'jphillips@company.com', '617-555-0133', '2017-05-15', NULL, 8, 32, 95000.00, NULL, 'Research Associate', 'Full-time', 1, '2017-05-15 09:00:00'),
(34, 'Kayla', 'Campbell', 'kcampbell@company.com', '602-555-0134', '2014-08-01', NULL, 9, 11, 65000.00, NULL, 'Support Specialist', 'Full-time', 1, '2014-08-01 09:00:00'),
(35, 'Nathan', 'Parker', 'nparker@company.com', '602-555-0135', '2016-11-15', NULL, 9, 11, 58000.00, NULL, 'Support Specialist', 'Full-time', 1, '2016-11-15 09:00:00'),
(36, 'Victoria', 'Evans', 'vevans@company.com', '206-555-0136', '2013-03-01', NULL, 10, 12, 105000.00, NULL, 'System Administrator', 'Full-time', 1, '2013-03-01 09:00:00'),
(37, 'Austin', 'Edwards', 'aedwards@company.com', '206-555-0137', '2015-08-15', NULL, 10, 36, 85000.00, NULL, 'Network Engineer', 'Full-time', 1, '2015-08-15 09:00:00'),
(38, 'Morgan', 'Collins', 'mcollins@company.com', '415-555-0138', '2015-12-01', NULL, 11, 13, 125000.00, NULL, 'Product Manager', 'Full-time', 1, '2015-12-01 09:00:00'),
(39, 'Dylan', 'Stewart', 'dstewart@company.com', '415-555-0139', '2017-02-15', NULL, 11, 38, 95000.00, NULL, 'Product Analyst', 'Full-time', 1, '2017-02-15 09:00:00'),
-- Duplicate email (TRAP)
(40, 'Alexis', 'Morris', 'awhite@company.com', '415-555-0140', '2018-06-01', NULL, 11, 38, 78000.00, NULL, 'Associate PM', 'Full-time', 1, '2018-06-01 09:00:00'),
-- NULL salary (TRAP)
(41, 'Cameron', 'Rogers', 'crogers@company.com', '212-555-0141', '2019-01-15', NULL, 1, 3, NULL, NULL, 'Intern', 'Intern', 1, '2019-01-15 09:00:00'),
-- Part-time employee
(42, 'Jordan', 'Reed', 'jreed@company.com', '212-555-0142', '2018-09-01', NULL, 2, 18, 45000.00, NULL, 'Content Writer', 'Part-time', 1, '2018-09-01 09:00:00'),
-- Contractor
(43, 'Taylor', 'Cook', 'tcook@company.com', '312-555-0143', '2020-03-15', NULL, 3, 21, 80000.00, 0.05, 'Sales Contractor', 'Contractor', 1, '2020-03-15 09:00:00'),
-- Terminated properly
(44, 'Casey', 'Morgan', 'cmorgan@company.com', '214-555-0144', '2016-07-01', '2022-12-31', 6, 29, 72000.00, NULL, 'Ops Coordinator', 'Full-time', 0, '2016-07-01 09:00:00'),
-- Future hire date (TRAP)
(45, 'Riley', 'Bell', 'rbell@company.com', '617-555-0145', '2025-06-01', NULL, 8, 10, 88000.00, NULL, 'Future Researcher', 'Full-time', 1, '2024-01-15 09:00:00'),
(46, 'Parker', 'Murphy', 'pmurphy@company.com', '602-555-0146', '2019-04-15', NULL, 9, 11, 52000.00, NULL, 'Support Rep', 'Full-time', 1, '2019-04-15 09:00:00'),
(47, 'Quinn', 'Bailey', 'qbailey@company.com', '206-555-0147', '2020-08-01', NULL, 10, 36, 92000.00, NULL, 'Cloud Engineer', 'Full-time', 1, '2020-08-01 09:00:00'),
(48, 'Avery', 'Rivera', 'arivera@company.com', '212-555-0148', '2021-01-15', NULL, 1, 2, 105000.00, NULL, 'Software Engineer', 'Full-time', 1, '2021-01-15 09:00:00'),
(49, 'Blake', 'Cooper', 'bcooper@company.com', '310-555-0149', '2021-06-01', NULL, 2, 4, 78000.00, NULL, 'Digital Marketing', 'Full-time', 1, '2021-06-01 09:00:00'),
(50, 'Charlie', 'Richardson', 'crichardson@company.com', '312-555-0150', '2022-02-15', NULL, 3, 5, 68000.00, 0.08, 'Sales Associate', 'Full-time', 1, '2022-02-15 09:00:00');

-- Projects (20 projects with various states)
INSERT INTO projects VALUES
(1, 'Website Redesign', 1, '2022-01-15', '2022-06-30', 250000.00, 275000.00, 'Completed', 'High'),
(2, 'Mobile App Development', 1, '2022-03-01', '2023-01-31', 500000.00, 620000.00, 'Completed', 'High'),
(3, 'Brand Refresh Campaign', 2, '2022-06-01', '2022-12-31', 150000.00, 145000.00, 'Completed', 'Medium'),
(4, 'CRM Implementation', 3, '2022-09-01', '2023-06-30', 300000.00, 350000.00, 'Completed', 'High'),
(5, 'Employee Portal', 4, '2023-01-15', '2023-08-31', 180000.00, 175000.00, 'Completed', 'Medium'),
(6, 'Financial System Upgrade', 5, '2023-02-01', '2023-09-30', 400000.00, 425000.00, 'Completed', 'High'),
(7, 'Supply Chain Optimization', 6, '2023-04-01', '2024-03-31', 350000.00, 280000.00, 'In Progress', 'High'),
(8, 'Compliance Audit System', 7, '2023-06-01', '2024-05-31', 200000.00, 150000.00, 'In Progress', 'Medium'),
(9, 'AI Research Initiative', 8, '2023-09-01', '2025-08-31', 750000.00, 200000.00, 'In Progress', 'High'),
(10, 'Customer Support Chatbot', 9, '2023-07-01', '2024-06-30', 180000.00, 120000.00, 'In Progress', 'Medium'),
(11, 'Cloud Migration', 10, '2023-10-01', '2024-09-30', 600000.00, 250000.00, 'In Progress', 'High'),
(12, 'Product Analytics Platform', 11, '2024-01-01', '2024-12-31', 280000.00, 50000.00, 'In Progress', 'High'),
(13, 'Data Warehouse', 1, '2024-02-15', '2024-11-30', 320000.00, 80000.00, 'In Progress', 'High'),
(14, 'Social Media Campaign', 2, '2024-03-01', '2024-08-31', 100000.00, 45000.00, 'In Progress', 'Low'),
(15, 'Sales Territory Expansion', 3, '2024-04-01', '2025-03-31', 220000.00, 30000.00, 'Planning', 'Medium'),
-- Cancelled project (TRAP for analysis)
(16, 'Abandoned Initiative', 6, '2022-01-01', '2022-06-30', 180000.00, 95000.00, 'Cancelled', 'Low'),
-- Over budget significantly
(17, 'Legacy System Replacement', 10, '2021-06-01', '2023-12-31', 400000.00, 780000.00, 'Completed', 'High'),
-- End date before start date (TRAP)
(18, 'Quick Fix Project', 1, '2024-06-01', '2024-05-15', 50000.00, NULL, 'Planning', 'Low'),
(19, 'Security Enhancement', 10, '2024-05-01', '2024-10-31', 150000.00, 25000.00, 'In Progress', 'High'),
(20, 'Training Platform', 4, '2024-06-01', '2025-05-31', 120000.00, 10000.00, 'Planning', 'Medium');

-- Employee Projects assignments
INSERT INTO employee_projects VALUES
(3, 1, 'Lead Developer', 320.00, '2022-01-15', '2022-06-30'),
(14, 1, 'Developer', 280.00, '2022-01-15', '2022-06-30'),
(15, 1, 'Developer', 260.00, '2022-02-01', '2022-06-30'),
(2, 2, 'Project Sponsor', 80.00, '2022-03-01', '2023-01-31'),
(3, 2, 'Tech Lead', 450.00, '2022-03-01', '2023-01-31'),
(16, 2, 'Developer', 520.00, '2022-03-01', '2023-01-31'),
(17, 2, 'Developer', 480.00, '2022-03-01', '2023-01-31'),
(4, 3, 'Project Lead', 200.00, '2022-06-01', '2022-12-31'),
(18, 3, 'Marketing Lead', 350.00, '2022-06-01', '2022-12-31'),
(19, 3, 'Coordinator', 400.00, '2022-06-01', '2022-12-31'),
(5, 4, 'Project Sponsor', 60.00, '2022-09-01', '2023-06-30'),
(21, 4, 'Implementation Lead', 450.00, '2022-09-01', '2023-06-30'),
(22, 4, 'User Rep', 120.00, '2023-01-01', '2023-06-30'),
(6, 5, 'Project Lead', 280.00, '2023-01-15', '2023-08-31'),
(25, 5, 'Business Analyst', 320.00, '2023-01-15', '2023-08-31'),
(26, 5, 'Support', 180.00, '2023-03-01', '2023-08-31'),
(7, 6, 'Project Sponsor', 100.00, '2023-02-01', '2023-09-30'),
(27, 6, 'Lead Analyst', 400.00, '2023-02-01', '2023-09-30'),
(28, 6, 'Analyst', 350.00, '2023-02-01', '2023-09-30'),
(8, 7, 'Project Lead', 280.00, '2023-04-01', NULL),
(29, 7, 'Operations Lead', 350.00, '2023-04-01', NULL),
(30, 7, 'Analyst', 400.00, '2023-04-01', NULL),
(9, 8, 'Legal Advisor', 150.00, '2023-06-01', NULL),
(31, 8, 'Lead Counsel', 300.00, '2023-06-01', NULL),
(10, 9, 'Research Lead', 400.00, '2023-09-01', NULL),
(32, 9, 'Researcher', 500.00, '2023-09-01', NULL),
(33, 9, 'Associate', 450.00, '2023-09-01', NULL),
(11, 10, 'Project Lead', 200.00, '2023-07-01', NULL),
(34, 10, 'Support Lead', 280.00, '2023-07-01', NULL),
(35, 10, 'Implementation', 320.00, '2023-07-01', NULL),
(12, 11, 'Project Lead', 350.00, '2023-10-01', NULL),
(36, 11, 'System Lead', 420.00, '2023-10-01', NULL),
(37, 11, 'Network Lead', 380.00, '2023-10-01', NULL),
(47, 11, 'Cloud Specialist', 400.00, '2023-10-01', NULL),
(13, 12, 'Project Lead', 180.00, '2024-01-01', NULL),
(38, 12, 'Product Lead', 250.00, '2024-01-01', NULL),
(39, 12, 'Analyst', 280.00, '2024-01-01', NULL),
(1, 13, 'Exec Sponsor', 40.00, '2024-02-15', NULL),
(2, 13, 'Tech Advisor', 80.00, '2024-02-15', NULL),
(48, 13, 'Developer', 350.00, '2024-02-15', NULL),
(4, 14, 'Sponsor', 30.00, '2024-03-01', NULL),
(49, 14, 'Lead', 180.00, '2024-03-01', NULL),
(42, 14, 'Content', 200.00, '2024-03-01', NULL);

-- Salary History (with gaps and overlaps as traps)
INSERT INTO salary_history (emp_id, salary, effective_date, end_date, change_reason) VALUES
(1, 150000.00, '2010-01-15', '2012-12-31', 'Initial'),
(1, 165000.00, '2013-01-01', '2015-12-31', 'Annual Review'),
(1, 180000.00, '2016-01-01', '2020-12-31', 'Promotion'),
(1, 185000.00, '2021-01-01', NULL, 'Annual Review'),
(2, 120000.00, '2010-02-01', '2013-12-31', 'Initial'),
(2, 130000.00, '2014-01-01', '2017-12-31', 'Promotion'),
(2, 145000.00, '2018-01-01', NULL, 'Annual Review'),
(3, 85000.00, '2010-03-15', '2012-12-31', 'Initial'),
(3, 95000.00, '2013-01-01', '2015-12-31', 'Annual Review'),
(3, 110000.00, '2016-01-01', '2019-12-31', 'Promotion'),
(3, 125000.00, '2020-01-01', NULL, 'Annual Review'),
-- Gap in salary history (TRAP)
(14, 80000.00, '2012-06-15', '2014-12-31', 'Initial'),
(14, 95000.00, '2016-01-01', '2019-12-31', 'Promotion'),
(14, 115000.00, '2020-01-01', NULL, 'Annual Review'),
-- Overlapping salary periods (TRAP)
(21, 70000.00, '2011-04-01', '2014-06-30', 'Initial'),
(21, 80000.00, '2014-01-01', '2017-12-31', 'Promotion'),
(21, 95000.00, '2018-01-01', NULL, 'Annual Review'),
(5, 130000.00, '2010-05-15', '2013-12-31', 'Initial'),
(5, 150000.00, '2014-01-01', '2018-12-31', 'Promotion'),
(5, 170000.00, '2019-01-01', NULL, 'Annual Review'),
(22, 55000.00, '2012-08-15', '2015-12-31', 'Initial'),
(22, 65000.00, '2016-01-01', '2019-12-31', 'Annual Review'),
(22, 75000.00, '2020-01-01', NULL, 'Annual Review'),
(48, 95000.00, '2021-01-15', '2022-12-31', 'Initial'),
(48, 105000.00, '2023-01-01', NULL, 'Annual Review');

-- Clients (25 clients with various issues)
INSERT INTO clients VALUES
(1, 'Acme Corporation', 'John Smith', 'jsmith@acme.com', '555-100-0001', '123 Main St', 'New York', 'NY', '10001', 'Manufacturing', 50000000.00, 250, '2015-03-15', 1),
(2, 'TechStart Inc', 'Mary Johnson', 'mjohnson@techstart.com', '555-100-0002', '456 Tech Blvd', 'San Francisco', 'CA', '94102', 'Technology', 15000000.00, 85, '2016-07-20', 1),
(3, 'Global Retail Co', 'Robert Davis', 'rdavis@globalretail.com', '555-100-0003', '789 Commerce Ave', 'Chicago', 'IL', '60601', 'Retail', 120000000.00, 1200, '2014-11-10', 1),
(4, 'Healthcare Plus', 'Susan Wilson', 'swilson@healthplus.com', '555-100-0004', '321 Medical Dr', 'Boston', 'MA', '02101', 'Healthcare', 75000000.00, 450, '2017-02-28', 1),
(5, 'Finance First', 'Michael Brown', 'mbrown@financefirst.com', '555-100-0005', '654 Wall St', 'New York', 'NY', '10005', 'Finance', 200000000.00, 800, '2015-09-05', 1),
(6, 'EduLearn Systems', 'Patricia Miller', 'pmiller@edulearn.com', '555-100-0006', '987 Campus Rd', 'Austin', 'TX', '78701', 'Education', 8000000.00, 60, '2018-04-12', 1),
(7, 'Green Energy Corp', 'James Taylor', 'jtaylor@greenenergy.com', '555-100-0007', '147 Solar Way', 'Denver', 'CO', '80201', 'Energy', 45000000.00, 200, '2019-01-25', 1),
(8, 'Quick Logistics', 'Jennifer Anderson', 'janderson@quicklog.com', '555-100-0008', '258 Transport Ln', 'Dallas', 'TX', '75201', 'Logistics', 35000000.00, 350, '2016-08-30', 1),
(9, 'MediaMax Entertainment', 'David Thomas', 'dthomas@mediamax.com', '555-100-0009', '369 Hollywood Blvd', 'Los Angeles', 'CA', '90028', 'Entertainment', 25000000.00, 150, '2017-06-15', 1),
(10, 'SecureNet Solutions', 'Nancy Jackson', 'njackson@securenet.com', '555-100-0010', '741 Cyber St', 'Seattle', 'WA', '98101', 'Cybersecurity', 18000000.00, 95, '2019-08-20', 1),
-- Inactive client with active contracts (TRAP)
(11, 'Old Industries LLC', 'Thomas White', 'twhite@oldindustries.com', '555-100-0011', '852 Legacy Rd', 'Detroit', 'MI', '48201', 'Manufacturing', 30000000.00, 180, '2013-05-10', 0),
(12, 'Smart Home Tech', 'Karen Harris', 'kharris@smarthome.com', '555-100-0012', '963 IoT Ave', 'Phoenix', 'AZ', '85001', 'Technology', 12000000.00, 70, '2020-02-14', 1),
(13, 'Midwest Farming Co', 'Steven Martin', 'smartin@midwestfarm.com', '555-100-0013', '159 Rural Rte', 'Des Moines', 'IA', '50301', 'Agriculture', 22000000.00, 120, '2018-09-08', 1),
(14, 'Fashion Forward', 'Lisa Garcia', 'lgarcia@fashionforward.com', '555-100-0014', '357 Style St', 'Miami', 'FL', '33101', 'Retail', 40000000.00, 280, '2017-11-22', 1),
(15, 'Construction Kings', 'Kevin Martinez', 'kmartinez@constkings.com', '555-100-0015', '468 Builder Blvd', 'Houston', 'TX', '77001', 'Construction', 65000000.00, 420, '2016-03-17', 1),
-- Duplicate company name different contact (TRAP)
(16, 'Acme Corporation', 'Jane Doe', 'jdoe@acmecorp.com', '555-100-0016', '999 Other St', 'Los Angeles', 'CA', '90001', 'Manufacturing', 35000000.00, 150, '2020-07-01', 1),
(17, 'DataDriven Analytics', 'Chris Robinson', 'crobinson@datadriven.com', '555-100-0017', '246 Insight Way', 'Atlanta', 'GA', '30301', 'Technology', 9000000.00, 45, '2021-01-10', 1),
(18, 'Pharma Solutions', 'Amy Clark', 'aclark@pharmasol.com', '555-100-0018', '135 Research Pk', 'Philadelphia', 'PA', '19101', 'Healthcare', 55000000.00, 380, '2019-04-25', 1),
(19, 'Auto Excellence', 'Mark Lewis', 'mlewis@autoexcel.com', '555-100-0019', '579 Motor Dr', 'Detroit', 'MI', '48202', 'Automotive', 85000000.00, 520, '2015-12-03', 1),
(20, 'Hospitality Group', 'Laura Lee', 'llee@hospgroup.com', '555-100-0020', '680 Hotel Way', 'Las Vegas', 'NV', '89101', 'Hospitality', 110000000.00, 2500, '2016-06-28', 1),
-- Zero revenue (TRAP)
(21, 'StartupXYZ', 'Paul Walker', 'pwalker@startupxyz.com', '555-100-0021', '111 Venture St', 'San Jose', 'CA', '95101', 'Technology', 0.00, 5, '2023-08-15', 1),
(22, 'Legal Eagles LLP', 'Sarah Hall', 'shall@legaleagles.com', '555-100-0022', '222 Justice Ave', 'Washington', 'DC', '20001', 'Legal', 28000000.00, 120, '2018-10-30', 1),
(23, 'Food Services Inc', 'Brian Young', 'byoung@foodservices.com', '555-100-0023', '333 Culinary Ct', 'Portland', 'OR', '97201', 'Food Service', 42000000.00, 650, '2017-07-19', 1),
(24, 'Telecom Giants', 'Michelle King', 'mking@telecomgiants.com', '555-100-0024', '444 Signal St', 'Dallas', 'TX', '75202', 'Telecommunications', 180000000.00, 3200, '2014-02-11', 1),
(25, 'Insurance Partners', 'Ryan Wright', 'rwright@inspartners.com', '555-100-0025', '555 Coverage Ln', 'Hartford', 'CT', '06101', 'Insurance', 95000000.00, 680, '2015-05-06', 1);

-- Contracts
INSERT INTO contracts VALUES
(1, 1, 1, 275000.00, '2022-01-15', '2022-06-30', 'Net 30', 'Completed', '2022-01-10'),
(2, 2, 2, 500000.00, '2022-03-01', '2023-01-31', 'Net 45', 'Completed', '2022-02-15'),
(3, 3, 3, 150000.00, '2022-06-01', '2022-12-31', 'Net 30', 'Completed', '2022-05-20'),
(4, 5, 4, 350000.00, '2022-09-01', '2023-06-30', 'Net 60', 'Completed', '2022-08-15'),
(5, 4, 5, 180000.00, '2023-01-15', '2023-08-31', 'Net 30', 'Completed', '2023-01-05'),
(6, 5, 6, 425000.00, '2023-02-01', '2023-09-30', 'Net 45', 'Completed', '2023-01-20'),
(7, 8, 7, 350000.00, '2023-04-01', '2024-03-31', 'Net 30', 'Active', '2023-03-15'),
(8, 10, 8, 200000.00, '2023-06-01', '2024-05-31', 'Net 45', 'Active', '2023-05-20'),
(9, 17, 9, 750000.00, '2023-09-01', '2025-08-31', 'Net 60', 'Active', '2023-08-15'),
(10, 9, 10, 180000.00, '2023-07-01', '2024-06-30', 'Net 30', 'Active', '2023-06-15'),
(11, 10, 11, 600000.00, '2023-10-01', '2024-09-30', 'Net 45', 'Active', '2023-09-10'),
(12, 2, 12, 280000.00, '2024-01-01', '2024-12-31', 'Net 30', 'Active', '2023-12-15'),
(13, 1, 13, 320000.00, '2024-02-15', '2024-11-30', 'Net 30', 'Active', '2024-02-01'),
(14, 9, 14, 100000.00, '2024-03-01', '2024-08-31', 'Net 30', 'Active', '2024-02-20'),
-- Contract with inactive client (TRAP)
(15, 11, 17, 400000.00, '2021-06-01', '2023-12-31', 'Net 60', 'Completed', '2021-05-15'),
(16, 15, 7, 200000.00, '2023-06-01', '2024-05-31', 'Net 45', 'Active', '2023-05-25'),
(17, 19, 6, 250000.00, '2023-04-01', '2023-12-31', 'Net 30', 'Completed', '2023-03-20'),
(18, 24, 11, 350000.00, '2023-11-01', '2024-10-31', 'Net 45', 'Active', '2023-10-15'),
-- Cancelled contract
(19, 7, 16, 180000.00, '2022-01-01', '2022-06-30', 'Net 30', 'Cancelled', '2021-12-15'),
(20, 20, 19, 150000.00, '2024-05-01', '2024-10-31', 'Net 30', 'Active', '2024-04-20');

-- Invoices (with payment anomalies)
INSERT INTO invoices VALUES
(1, 1, '2022-02-01', '2022-03-03', 55000.00, 4950.00, 59950.00, 'Paid', '2022-02-28', 59950.00),
(2, 1, '2022-03-01', '2022-03-31', 55000.00, 4950.00, 59950.00, 'Paid', '2022-03-25', 59950.00),
(3, 1, '2022-04-01', '2022-05-01', 55000.00, 4950.00, 59950.00, 'Paid', '2022-04-28', 59950.00),
(4, 1, '2022-05-01', '2022-05-31', 55000.00, 4950.00, 59950.00, 'Paid', '2022-05-30', 59950.00),
(5, 1, '2022-06-01', '2022-07-01', 55000.00, 4950.00, 59950.00, 'Paid', '2022-06-28', 59950.00),
(6, 2, '2022-04-01', '2022-05-16', 100000.00, 9000.00, 109000.00, 'Paid', '2022-05-10', 109000.00),
(7, 2, '2022-07-01', '2022-08-15', 100000.00, 9000.00, 109000.00, 'Paid', '2022-08-10', 109000.00),
(8, 2, '2022-10-01', '2022-11-15', 100000.00, 9000.00, 109000.00, 'Paid', '2022-11-20', 109000.00),
(9, 2, '2023-01-01', '2023-02-15', 100000.00, 9000.00, 109000.00, 'Paid', '2023-02-10', 109000.00),
(10, 2, '2023-01-31', '2023-03-17', 100000.00, 9000.00, 109000.00, 'Paid', '2023-03-15', 109000.00),
(11, 3, '2022-07-01', '2022-07-31', 50000.00, 4500.00, 54500.00, 'Paid', '2022-07-28', 54500.00),
(12, 3, '2022-09-01', '2022-10-01', 50000.00, 4500.00, 54500.00, 'Paid', '2022-09-25', 54500.00),
(13, 3, '2022-12-01', '2022-12-31', 50000.00, 4500.00, 54500.00, 'Paid', '2022-12-28', 54500.00),
(14, 4, '2022-10-01', '2022-11-30', 87500.00, 7875.00, 95375.00, 'Paid', '2022-11-25', 95375.00),
(15, 4, '2023-01-01', '2023-03-02', 87500.00, 7875.00, 95375.00, 'Paid', '2023-02-28', 95375.00),
(16, 4, '2023-04-01', '2023-05-31', 87500.00, 7875.00, 95375.00, 'Paid', '2023-05-25', 95375.00),
(17, 4, '2023-06-30', '2023-08-29', 87500.00, 7875.00, 95375.00, 'Paid', '2023-08-28', 95375.00),
-- Partial payment (TRAP)
(18, 7, '2023-05-01', '2023-05-31', 70000.00, 6300.00, 76300.00, 'Paid', '2023-05-28', 70000.00),
(19, 7, '2023-08-01', '2023-08-31', 70000.00, 6300.00, 76300.00, 'Paid', '2023-08-30', 76300.00),
(20, 7, '2023-11-01', '2023-12-01', 70000.00, 6300.00, 76300.00, 'Paid', '2023-11-28', 76300.00),
(21, 7, '2024-02-01', '2024-03-02', 70000.00, 6300.00, 76300.00, 'Outstanding', NULL, NULL),
-- Overdue invoices (TRAP)
(22, 8, '2023-07-01', '2023-08-15', 50000.00, 4500.00, 54500.00, 'Paid', '2023-08-10', 54500.00),
(23, 8, '2023-10-01', '2023-11-15', 50000.00, 4500.00, 54500.00, 'Paid', '2023-11-20', 54500.00),
(24, 8, '2024-01-01', '2024-02-15', 50000.00, 4500.00, 54500.00, 'Overdue', NULL, NULL),
(25, 9, '2023-10-01', '2023-11-30', 150000.00, 13500.00, 163500.00, 'Paid', '2023-11-25', 163500.00),
(26, 9, '2024-01-01', '2024-02-29', 150000.00, 13500.00, 163500.00, 'Paid', '2024-02-28', 163500.00),
(27, 9, '2024-04-01', '2024-05-31', 150000.00, 13500.00, 163500.00, 'Outstanding', NULL, NULL),
(28, 10, '2023-08-01', '2023-08-31', 45000.00, 4050.00, 49050.00, 'Paid', '2023-08-28', 49050.00),
(29, 10, '2023-11-01', '2023-12-01', 45000.00, 4050.00, 49050.00, 'Paid', '2023-11-28', 49050.00),
(30, 10, '2024-02-01', '2024-03-02', 45000.00, 4050.00, 49050.00, 'Paid', '2024-02-29', 49050.00),
-- Tax mismatch (TRAP - tax doesn't match 9% rate)
(31, 11, '2023-11-01', '2023-12-16', 120000.00, 15000.00, 135000.00, 'Paid', '2023-12-10', 135000.00),
(32, 11, '2024-02-01', '2024-03-17', 120000.00, 10800.00, 130800.00, 'Paid', '2024-03-15', 130800.00),
(33, 12, '2024-02-01', '2024-03-02', 70000.00, 6300.00, 76300.00, 'Paid', '2024-02-28', 76300.00),
(34, 12, '2024-05-01', '2024-05-31', 70000.00, 6300.00, 76300.00, 'Outstanding', NULL, NULL),
(35, 13, '2024-03-15', '2024-04-14', 80000.00, 7200.00, 87200.00, 'Paid', '2024-04-10', 87200.00);

-- Expenses
INSERT INTO expenses VALUES
(1, 3, 1, '2022-02-15', 'Software', 'Development tools license', 1200.00, 'Approved', 2, '2022-02-18'),
(2, 14, 1, '2022-03-10', 'Hardware', 'Testing devices', 850.00, 'Approved', 2, '2022-03-12'),
(3, 18, 3, '2022-07-20', 'Marketing', 'Campaign materials', 3500.00, 'Approved', 4, '2022-07-22'),
(4, 19, 3, '2022-08-15', 'Travel', 'Client meeting travel', 1200.00, 'Approved', 4, '2022-08-18'),
(5, 21, 4, '2022-10-05', 'Software', 'CRM licenses', 5000.00, 'Approved', 5, '2022-10-08'),
(6, 22, 4, '2022-11-20', 'Training', 'CRM training', 800.00, 'Approved', 5, '2022-11-22'),
(7, 25, 5, '2023-02-28', 'Software', 'HR portal software', 2500.00, 'Approved', 6, '2023-03-02'),
(8, 27, 6, '2023-03-15', 'Consulting', 'Financial advisor', 8000.00, 'Approved', 7, '2023-03-18'),
(9, 29, 7, '2023-05-10', 'Equipment', 'Logistics equipment', 4500.00, 'Approved', 8, '2023-05-12'),
(10, 36, 11, '2023-11-15', 'Cloud', 'AWS migration costs', 15000.00, 'Approved', 12, '2023-11-18'),
(11, 47, 11, '2023-12-10', 'Cloud', 'Azure services', 12000.00, 'Approved', 12, '2023-12-12'),
(12, 32, 9, '2023-10-20', 'Research', 'Lab equipment', 25000.00, 'Approved', 10, '2023-10-25'),
(13, 33, 9, '2023-11-30', 'Research', 'Research materials', 8000.00, 'Approved', 10, '2023-12-02'),
(14, 34, 10, '2023-08-15', 'Software', 'Chatbot platform', 6000.00, 'Approved', 11, '2023-08-18'),
(15, 38, 12, '2024-02-10', 'Software', 'Analytics tools', 4500.00, 'Approved', 13, '2024-02-12'),
-- Pending expenses (no approval)
(16, 48, 13, '2024-03-20', 'Software', 'Dev environment', 3000.00, 'Pending', NULL, NULL),
(17, 49, 14, '2024-04-05', 'Marketing', 'Ad spend', 5000.00, 'Pending', NULL, NULL),
-- Rejected expense
(18, 30, 7, '2023-06-15', 'Entertainment', 'Team dinner', 2500.00, 'Rejected', 8, '2023-06-18'),
-- Self-approved expense (TRAP)
(19, 8, 7, '2023-07-20', 'Travel', 'Conference travel', 3500.00, 'Approved', 8, '2023-07-20'),
(20, 37, 11, '2024-01-15', 'Training', 'Cloud certification', 2000.00, 'Approved', 36, '2024-01-18');

-- Performance Reviews (with anomalies)
INSERT INTO performance_reviews VALUES
(1, 3, 2, '2023-01-15', '2022-01-01', '2022-12-31', 4, 92.50, 'Excellent technical skills and leadership'),
(2, 14, 2, '2023-01-20', '2022-01-01', '2022-12-31', 3, 78.00, 'Good performance, needs improvement in communication'),
(3, 15, 2, '2023-01-22', '2022-01-01', '2022-12-31', 4, 88.00, 'Strong contributor to team projects'),
(4, 16, 3, '2023-01-25', '2022-01-01', '2022-12-31', 3, 75.00, 'Meeting expectations'),
(5, 17, 3, '2023-01-25', '2022-01-01', '2022-12-31', 4, 85.00, 'Exceeding expectations for junior role'),
(6, 18, 4, '2023-02-01', '2022-01-01', '2022-12-31', 4, 90.00, 'Strong marketing campaigns'),
(7, 19, 18, '2023-02-05', '2022-01-01', '2022-12-31', 3, 72.00, 'Adequate performance'),
(8, 21, 5, '2023-02-10', '2022-01-01', '2022-12-31', 5, 98.00, 'Outstanding sales leadership'),
(9, 22, 21, '2023-02-12', '2022-01-01', '2022-12-31', 4, 88.00, 'Exceeded sales targets'),
(10, 23, 21, '2023-02-12', '2022-01-01', '2022-12-31', 3, 80.00, 'Met sales targets'),
-- Rating out of expected range (TRAP - assuming 1-5 scale)
(11, 24, 21, '2023-02-15', '2022-01-01', '2022-12-31', 7, 95.00, 'Exceptional first year'),
(12, 27, 7, '2023-02-20', '2022-01-01', '2022-12-31', 4, 87.00, 'Accurate and timely financial work'),
(13, 29, 8, '2023-02-25', '2022-01-01', '2022-12-31', 4, 85.00, 'Good operational improvements'),
(14, 36, 12, '2023-03-01', '2022-01-01', '2022-12-31', 4, 90.00, 'Strong system administration'),
-- Self-review (TRAP)
(15, 38, 38, '2023-03-05', '2022-01-01', '2022-12-31', 5, 100.00, 'Perfect performance'),
(16, 3, 2, '2024-01-15', '2023-01-01', '2023-12-31', 5, 95.00, 'Exceptional year, promoted to senior'),
(17, 14, 2, '2024-01-20', '2023-01-01', '2023-12-31', 4, 85.00, 'Significant improvement'),
(18, 48, 2, '2024-01-22', '2023-01-01', '2023-12-31', 4, 82.00, 'Strong first year'),
-- Goals met over 100% (TRAP)
(19, 22, 21, '2024-02-10', '2023-01-01', '2023-12-31', 4, 115.00, 'Significantly exceeded targets'),
(20, 47, 36, '2024-02-15', '2023-01-01', '2023-12-31', 4, 88.00, 'Strong cloud expertise');

-- Office Locations
INSERT INTO office_locations VALUES
(1, 'NYC Headquarters', '100 Park Avenue', 'New York', 'NY', '10017', 'USA', 500, 250000.00, '2010-01-01', '2030-12-31'),
(2, 'LA Office', '500 Wilshire Blvd', 'Los Angeles', 'CA', '90010', 'USA', 150, 85000.00, '2012-03-01', '2027-02-28'),
(3, 'Chicago Hub', '233 N Michigan Ave', 'Chicago', 'IL', '60601', 'USA', 200, 120000.00, '2011-06-01', '2026-05-31'),
(4, 'Dallas Center', '1700 Pacific Ave', 'Dallas', 'TX', '75201', 'USA', 175, 95000.00, '2013-09-01', '2028-08-31'),
(5, 'Boston Lab', '101 Huntington Ave', 'Boston', 'MA', '02199', 'USA', 100, 110000.00, '2015-09-01', '2025-08-31'),
(6, 'Seattle Tech', '999 3rd Ave', 'Seattle', 'WA', '98104', 'USA', 120, 105000.00, '2012-01-01', '2027-12-31'),
(7, 'SF Innovation', '50 Fremont St', 'San Francisco', 'CA', '94105', 'USA', 180, 180000.00, '2014-07-01', '2029-06-30'),
(8, 'Phoenix Support', '2020 N Central Ave', 'Phoenix', 'AZ', '85004', 'USA', 250, 55000.00, '2013-03-01', '2028-02-28'),
-- Expired lease (TRAP)
(9, 'Detroit Legacy', '150 W Jefferson Ave', 'Detroit', 'MI', '48226', 'USA', 100, 45000.00, '2008-01-01', '2020-12-31'),
(10, 'Denver Satellite', '1660 Lincoln St', 'Denver', 'CO', '80264', 'USA', 50, 35000.00, '2020-01-01', '2025-12-31');

-- Attendance records (with anomalies)
INSERT INTO attendance (emp_id, work_date, clock_in, clock_out, hours_worked, status) VALUES
(3, '2024-01-02', '08:55', '17:30', 8.58, 'Present'),
(3, '2024-01-03', '09:05', '18:00', 8.92, 'Present'),
(3, '2024-01-04', '08:45', '17:15', 8.50, 'Present'),
(3, '2024-01-05', '09:00', '17:30', 8.50, 'Present'),
(14, '2024-01-02', '09:00', '17:00', 8.00, 'Present'),
(14, '2024-01-03', '09:15', '17:30', 8.25, 'Present'),
(14, '2024-01-04', NULL, NULL, NULL, 'Absent'),
(14, '2024-01-05', '09:00', '17:00', 8.00, 'Present'),
(21, '2024-01-02', '08:30', '19:00', 10.50, 'Present'),
(21, '2024-01-03', '08:45', '20:30', 11.75, 'Present'),
(21, '2024-01-04', '08:30', '18:30', 10.00, 'Present'),
(21, '2024-01-05', '09:00', '17:00', 8.00, 'Present'),
-- Missing clock out (TRAP)
(22, '2024-01-02', '09:00', NULL, NULL, 'Present'),
(22, '2024-01-03', '09:00', '17:00', 8.00, 'Present'),
(22, '2024-01-04', '09:00', '17:00', 8.00, 'Present'),
-- Hours don't match clock times (TRAP)
(27, '2024-01-02', '09:00', '17:00', 10.00, 'Present'),
(27, '2024-01-03', '09:00', '17:00', 8.00, 'Present'),
(27, '2024-01-04', '09:00', '17:00', 8.00, 'Present'),
(36, '2024-01-02', '08:00', '16:30', 8.50, 'Present'),
(36, '2024-01-03', '08:15', '16:45', 8.50, 'Present'),
(36, '2024-01-04', '08:00', '16:30', 8.50, 'Present'),
(48, '2024-01-02', '09:30', '18:00', 8.50, 'Present'),
(48, '2024-01-03', '09:00', '17:30', 8.50, 'Present'),
(48, '2024-01-04', '09:15', '17:45', 8.50, 'Present'),
-- Weekend work (TRAP for pattern analysis)
(3, '2024-01-06', '10:00', '14:00', 4.00, 'Present'),
(3, '2024-01-07', '11:00', '15:00', 4.00, 'Present');

-- Leave Requests
INSERT INTO leave_requests VALUES
(1, 3, 'Vacation', '2024-02-19', '2024-02-23', 5.0, 'Approved', 2, '2024-01-15'),
(2, 14, 'Sick', '2024-01-04', '2024-01-04', 1.0, 'Approved', 2, '2024-01-04'),
(3, 18, 'Vacation', '2024-03-11', '2024-03-15', 5.0, 'Approved', 4, '2024-02-01'),
(4, 21, 'Personal', '2024-01-22', '2024-01-22', 1.0, 'Approved', 5, '2024-01-18'),
(5, 27, 'Vacation', '2024-04-01', '2024-04-05', 5.0, 'Pending', NULL, '2024-03-01'),
(6, 36, 'Sick', '2024-01-15', '2024-01-16', 2.0, 'Approved', 12, '2024-01-15'),
(7, 48, 'Vacation', '2024-03-25', '2024-03-29', 5.0, 'Approved', 2, '2024-02-20'),
-- Leave exceeds typical allowance pattern (TRAP)
(8, 22, 'Vacation', '2024-05-01', '2024-05-31', 23.0, 'Pending', NULL, '2024-03-15'),
-- Denied leave
(9, 29, 'Vacation', '2024-02-01', '2024-02-09', 7.0, 'Denied', 8, '2024-01-10'),
-- Self-approved leave (TRAP)
(10, 6, 'Personal', '2024-01-29', '2024-01-29', 1.0, 'Approved', 6, '2024-01-25'),
(11, 47, 'Sick', '2024-02-05', '2024-02-06', 2.0, 'Approved', 36, '2024-02-05'),
(12, 33, 'Vacation', '2024-04-15', '2024-04-19', 5.0, 'Approved', 10, '2024-03-10'),
-- Overlapping leave requests (TRAP)
(13, 3, 'Personal', '2024-02-21', '2024-02-22', 2.0, 'Approved', 2, '2024-02-10'),
(14, 19, 'Vacation', '2024-03-11', '2024-03-13', 3.0, 'Approved', 18, '2024-02-15'),
(15, 34, 'Sick', '2024-01-08', '2024-01-08', 1.0, 'Approved', 11, '2024-01-08');

-- Skills
INSERT INTO skills VALUES
(1, 'Python', 'Programming'),
(2, 'Java', 'Programming'),
(3, 'JavaScript', 'Programming'),
(4, 'SQL', 'Database'),
(5, 'AWS', 'Cloud'),
(6, 'Azure', 'Cloud'),
(7, 'Project Management', 'Management'),
(8, 'Data Analysis', 'Analytics'),
(9, 'Machine Learning', 'AI/ML'),
(10, 'React', 'Frontend'),
(11, 'Node.js', 'Backend'),
(12, 'Docker', 'DevOps'),
(13, 'Kubernetes', 'DevOps'),
(14, 'Salesforce', 'CRM'),
(15, 'Excel', 'Office'),
(16, 'Tableau', 'Analytics'),
(17, 'Communication', 'Soft Skills'),
(18, 'Leadership', 'Soft Skills'),
(19, 'Negotiation', 'Sales'),
(20, 'Financial Modeling', 'Finance');

-- Employee Skills
INSERT INTO employee_skills VALUES
(3, 1, 5, 10.0, '2024-01-15'),
(3, 2, 4, 8.0, '2023-12-01'),
(3, 4, 5, 12.0, '2024-01-15'),
(3, 5, 4, 5.0, '2024-01-10'),
(14, 1, 4, 6.0, '2024-01-15'),
(14, 3, 4, 7.0, '2024-01-10'),
(14, 10, 3, 4.0, '2023-11-01'),
(15, 2, 4, 5.0, '2024-01-12'),
(15, 11, 4, 4.0, '2024-01-05'),
(16, 1, 3, 2.0, '2024-01-15'),
(16, 3, 3, 2.5, '2024-01-10'),
(17, 2, 3, 2.0, '2024-01-08'),
(18, 7, 4, 8.0, '2024-01-15'),
(18, 17, 5, 12.0, '2024-01-15'),
(21, 14, 5, 8.0, '2024-01-15'),
(21, 19, 5, 10.0, '2024-01-15'),
(21, 17, 4, 10.0, '2024-01-12'),
(22, 14, 4, 6.0, '2024-01-10'),
(22, 19, 4, 7.0, '2024-01-10'),
(27, 4, 5, 8.0, '2024-01-15'),
(27, 20, 5, 7.0, '2024-01-15'),
(27, 15, 5, 10.0, '2024-01-12'),
(36, 5, 5, 8.0, '2024-01-15'),
(36, 12, 5, 6.0, '2024-01-10'),
(36, 13, 4, 4.0, '2023-12-01'),
(47, 5, 5, 4.0, '2024-01-15'),
(47, 6, 5, 4.0, '2024-01-15'),
(47, 12, 4, 3.0, '2024-01-10'),
(48, 1, 4, 3.0, '2024-01-15'),
(48, 4, 4, 3.0, '2024-01-12'),
(48, 5, 3, 2.0, '2023-11-01'),
-- Proficiency level out of range (TRAP)
(32, 9, 8, 5.0, '2024-01-10'),
(32, 1, 5, 6.0, '2024-01-15'),
(33, 9, 4, 3.0, '2024-01-08'),
(38, 7, 5, 6.0, '2024-01-15'),
(38, 8, 4, 5.0, '2024-01-12'),
(39, 8, 4, 3.0, '2024-01-10'),
(39, 16, 4, 3.0, '2024-01-08');

-- Training Programs
INSERT INTO training_programs VALUES
(1, 'New Employee Orientation', 'Company policies, culture, and systems overview', 8, 0.00, 'Internal', 1),
(2, 'Cybersecurity Awareness', 'Basic security practices and threat awareness', 4, 0.00, 'Internal', 1),
(3, 'Leadership Fundamentals', 'Basic leadership and management skills', 16, 500.00, 'External Training Co', 0),
(4, 'Advanced Python', 'Advanced Python programming techniques', 24, 800.00, 'Tech Academy', 0),
(5, 'AWS Solutions Architect', 'AWS certification preparation', 40, 2000.00, 'AWS', 0),
(6, 'Project Management Professional', 'PMP certification prep', 35, 1500.00, 'PMI Partner', 0),
(7, 'Sales Excellence', 'Advanced sales techniques and negotiation', 16, 600.00, 'Sales Masters Inc', 0),
(8, 'Data Analytics Bootcamp', 'SQL, Python, and visualization', 60, 3000.00, 'Data School', 0),
(9, 'Diversity and Inclusion', 'Workplace diversity training', 4, 0.00, 'Internal', 1),
(10, 'Financial Compliance', 'Regulatory compliance for finance', 8, 0.00, 'Internal', 1);

-- Employee Training
INSERT INTO employee_training VALUES
(3, 1, '2010-03-15', '2010-03-15', 95.00, 'Completed'),
(3, 2, '2022-01-10', '2022-01-10', 100.00, 'Completed'),
(3, 4, '2018-06-01', '2018-06-25', 92.00, 'Completed'),
(14, 1, '2012-06-15', '2012-06-15', 88.00, 'Completed'),
(14, 2, '2022-01-12', '2022-01-12', 95.00, 'Completed'),
(15, 1, '2013-02-01', '2013-02-01', 90.00, 'Completed'),
(15, 2, '2022-01-14', '2022-01-14', 92.00, 'Completed'),
(16, 1, '2014-07-15', '2014-07-15', 85.00, 'Completed'),
(17, 1, '2015-03-01', '2015-03-01', 88.00, 'Completed'),
(18, 1, '2011-09-15', '2011-09-15', 92.00, 'Completed'),
(18, 3, '2015-03-10', '2015-03-26', 88.00, 'Completed'),
(21, 1, '2011-04-01', '2011-04-01', 95.00, 'Completed'),
(21, 7, '2013-05-15', '2013-05-31', 96.00, 'Completed'),
(22, 1, '2012-08-15', '2012-08-15', 90.00, 'Completed'),
(22, 7, '2016-02-01', '2016-02-17', 85.00, 'Completed'),
(27, 1, '2013-07-01', '2013-07-01', 88.00, 'Completed'),
(27, 10, '2015-06-01', '2015-06-08', 92.00, 'Completed'),
(36, 1, '2013-03-01', '2013-03-01', 95.00, 'Completed'),
(36, 5, '2019-08-01', '2019-09-10', 90.00, 'Completed'),
(47, 1, '2020-08-01', '2020-08-01', 92.00, 'Completed'),
(47, 5, '2022-03-01', '2022-04-10', 88.00, 'Completed'),
(48, 1, '2021-01-15', '2021-01-15', 90.00, 'Completed'),
(48, 2, '2022-02-01', '2022-02-01', 95.00, 'Completed'),
-- Enrolled but not completed for long time (TRAP)
(16, 4, '2020-01-15', NULL, NULL, 'In Progress'),
(17, 4, '2020-01-15', NULL, NULL, 'In Progress'),
-- Completed mandatory training with low score
(41, 1, '2019-01-15', '2019-01-15', 55.00, 'Completed'),
(41, 2, '2022-01-20', NULL, NULL, 'Enrolled'),
-- Missing mandatory training (implied TRAP - no record for some employees)
(38, 3, '2020-06-01', '2020-06-17', 94.00, 'Completed'),
(38, 6, '2021-03-01', '2021-04-05', 91.00, 'Completed');


-- =============================================
-- DATABASE 2: SCHOOL_DB
-- =============================================

DROP DATABASE IF EXISTS school_db;
CREATE DATABASE school_db;
USE school_db;

-- Schools Table
CREATE TABLE schools (
    school_id INT PRIMARY KEY,
    school_name VARCHAR(100),
    school_type VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    phone VARCHAR(20),
    principal_name VARCHAR(100),
    established_year INT,
    total_capacity INT,
    is_active TINYINT(1)
);

-- Departments (Academic)
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    school_id INT,
    dept_name VARCHAR(50),
    dept_head_id INT,
    budget DECIMAL(12,2),
    FOREIGN KEY (school_id) REFERENCES schools(school_id)
);

-- Teachers
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    termination_date DATE,
    dept_id INT,
    salary DECIMAL(10,2),
    education_level VARCHAR(50),
    certification_date DATE,
    is_active TINYINT(1),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Add foreign key for dept_head after teachers table exists
ALTER TABLE departments ADD FOREIGN KEY (dept_head_id) REFERENCES teachers(teacher_id);

-- Students
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    enrollment_date DATE,
    graduation_date DATE,
    grade_level INT,
    gpa DECIMAL(3,2),
    status VARCHAR(20),
    school_id INT,
    FOREIGN KEY (school_id) REFERENCES schools(school_id)
);

-- Parents/Guardians
CREATE TABLE guardians (
    guardian_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    relationship VARCHAR(20),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    is_emergency_contact TINYINT(1)
);

-- Student-Guardian relationship
CREATE TABLE student_guardians (
    student_id INT,
    guardian_id INT,
    is_primary TINYINT(1),
    PRIMARY KEY (student_id, guardian_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (guardian_id) REFERENCES guardians(guardian_id)
);

-- Courses
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_code VARCHAR(20),
    course_name VARCHAR(100),
    dept_id INT,
    credits INT,
    max_enrollment INT,
    description TEXT,
    is_active TINYINT(1),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Class Sections
CREATE TABLE class_sections (
    section_id INT PRIMARY KEY,
    course_id INT,
    teacher_id INT,
    semester VARCHAR(20),
    academic_year VARCHAR(9),
    room_number VARCHAR(10),
    schedule_days VARCHAR(20),
    start_time TIME,
    end_time TIME,
    max_students INT,
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- Enrollments
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    section_id INT,
    enrollment_date DATE,
    status VARCHAR(20),
    final_grade VARCHAR(2),
    grade_points DECIMAL(3,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (section_id) REFERENCES class_sections(section_id)
);

-- Assignments
CREATE TABLE assignments (
    assignment_id INT PRIMARY KEY,
    section_id INT,
    title VARCHAR(100),
    description TEXT,
    assignment_type VARCHAR(30),
    due_date DATE,
    max_points INT,
    weight DECIMAL(5,2),
    FOREIGN KEY (section_id) REFERENCES class_sections(section_id)
);

-- Grades (Assignment Submissions)
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    assignment_id INT,
    points_earned DECIMAL(6,2),
    submitted_date DATE,
    graded_date DATE,
    feedback TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id)
);

-- Attendance
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    section_id INT,
    attendance_date DATE,
    status VARCHAR(20),
    notes VARCHAR(200),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (section_id) REFERENCES class_sections(section_id)
);

-- Discipline Records
CREATE TABLE discipline_records (
    record_id INT PRIMARY KEY,
    student_id INT,
    incident_date DATE,
    incident_type VARCHAR(50),
    description TEXT,
    action_taken VARCHAR(100),
    reported_by INT,
    resolved_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (reported_by) REFERENCES teachers(teacher_id)
);

-- Extracurricular Activities
CREATE TABLE activities (
    activity_id INT PRIMARY KEY,
    activity_name VARCHAR(100),
    category VARCHAR(30),
    advisor_id INT,
    meeting_schedule VARCHAR(100),
    max_members INT,
    budget DECIMAL(10,2),
    school_id INT,
    FOREIGN KEY (advisor_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (school_id) REFERENCES schools(school_id)
);

-- Activity Membership
CREATE TABLE activity_members (
    student_id INT,
    activity_id INT,
    join_date DATE,
    role VARCHAR(30),
    status VARCHAR(20),
    PRIMARY KEY (student_id, activity_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (activity_id) REFERENCES activities(activity_id)
);

-- Library Books
CREATE TABLE library_books (
    book_id INT PRIMARY KEY,
    isbn VARCHAR(20),
    title VARCHAR(200),
    author VARCHAR(100),
    publisher VARCHAR(100),
    publication_year INT,
    category VARCHAR(50),
    copies_owned INT,
    copies_available INT,
    location VARCHAR(20)
);

-- Book Loans
CREATE TABLE book_loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    student_id INT,
    checkout_date DATE,
    due_date DATE,
    return_date DATE,
    fine_amount DECIMAL(6,2),
    FOREIGN KEY (book_id) REFERENCES library_books(book_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Fees Table
CREATE TABLE fees (
    fee_id INT PRIMARY KEY,
    student_id INT,
    fee_type VARCHAR(50),
    amount DECIMAL(10,2),
    due_date DATE,
    paid_date DATE,
    paid_amount DECIMAL(10,2),
    status VARCHAR(20),
    academic_year VARCHAR(9),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- =============================================
-- POPULATING SCHOOL_DB DATA
-- =============================================

-- Schools
INSERT INTO schools VALUES
(1, 'Lincoln High School', 'Public', '500 Education Blvd', 'Springfield', 'IL', '62701', '217-555-0100', 'Dr. Margaret Thompson', 1965, 1800, 1),
(2, 'Washington Middle School', 'Public', '300 Learning Lane', 'Springfield', 'IL', '62702', '217-555-0200', 'Mr. Robert Chen', 1972, 900, 1),
(3, 'Jefferson Elementary', 'Public', '150 Academy Drive', 'Springfield', 'IL', '62703', '217-555-0300', 'Ms. Sarah Mitchell', 1980, 600, 1),
(4, 'St. Mary\'s Academy', 'Private', '800 Faith Street', 'Springfield', 'IL', '62704', '217-555-0400', 'Sister Catherine O\'Brien', 1955, 500, 1),
-- Inactive school (TRAP)
(5, 'Roosevelt High School', 'Public', '1000 Historic Ave', 'Springfield', 'IL', '62705', '217-555-0500', 'Dr. William Jackson', 1940, 1200, 0);

-- Departments
INSERT INTO departments VALUES
(1, 1, 'Mathematics', NULL, 180000.00),
(2, 1, 'Science', NULL, 220000.00),
(3, 1, 'English', NULL, 175000.00),
(4, 1, 'History', NULL, 150000.00),
(5, 1, 'Physical Education', NULL, 95000.00),
(6, 1, 'Arts', NULL, 85000.00),
(7, 1, 'Foreign Languages', NULL, 120000.00),
(8, 2, 'Core Academics', NULL, 250000.00),
(9, 2, 'Electives', NULL, 80000.00),
(10, 3, 'Primary Education', NULL, 200000.00),
(11, 4, 'Religious Studies', NULL, 60000.00),
(12, 4, 'Academics', NULL, 180000.00);

-- Teachers (30 teachers with various issues)
INSERT INTO teachers VALUES
(1, 'James', 'Morrison', 'jmorrison@school.edu', '217-555-1001', '2005-08-15', NULL, 1, 72000.00, 'Masters in Mathematics', '2005-06-01', 1),
(2, 'Elizabeth', 'Cooper', 'ecooper@school.edu', '217-555-1002', '2008-08-20', NULL, 1, 68000.00, 'Masters in Education', '2008-06-15', 1),
(3, 'William', 'Foster', 'wfoster@school.edu', '217-555-1003', '2010-08-18', NULL, 2, 75000.00, 'PhD in Biology', '2010-05-20', 1),
(4, 'Patricia', 'Hayes', 'phayes@school.edu', '217-555-1004', '2003-08-25', NULL, 2, 78000.00, 'PhD in Chemistry', '2003-05-15', 1),
(5, 'Michael', 'Barnes', 'mbarnes@school.edu', '217-555-1005', '2012-08-20', NULL, 3, 65000.00, 'Masters in English Literature', '2012-06-01', 1),
(6, 'Jennifer', 'Russell', 'jrussell@school.edu', '217-555-1006', '2007-08-22', NULL, 3, 70000.00, 'Masters in Education', '2007-06-10', 1),
(7, 'David', 'Price', 'dprice@school.edu', '217-555-1007', '2015-08-17', NULL, 4, 62000.00, 'Masters in History', '2015-06-05', 1),
(8, 'Susan', 'Morgan', 'smorgan@school.edu', '217-555-1008', '2009-08-24', NULL, 4, 67000.00, 'Masters in Social Studies', '2009-06-08', 1),
(9, 'Richard', 'Perry', 'rperry@school.edu', '217-555-1009', '2011-08-15', NULL, 5, 58000.00, 'Bachelors in Physical Education', '2011-05-20', 1),
(10, 'Nancy', 'Long', 'nlong@school.edu', '217-555-1010', '2014-08-18', NULL, 5, 55000.00, 'Bachelors in Sports Science', '2014-06-01', 1),
(11, 'Charles', 'Bell', 'cbell@school.edu', '217-555-1011', '2016-08-22', NULL, 6, 52000.00, 'Masters in Fine Arts', '2016-06-15', 1),
(12, 'Karen', 'Murphy', 'kmurphy@school.edu', '217-555-1012', '2006-08-20', NULL, 7, 64000.00, 'Masters in Spanish', '2006-06-01', 1),
(13, 'Daniel', 'Rivera', 'drivera@school.edu', '217-555-1013', '2013-08-19', NULL, 7, 60000.00, 'Masters in French', '2013-06-10', 1),
(14, 'Lisa', 'Ward', 'lward@school.edu', '217-555-1014', '2004-08-16', NULL, 8, 71000.00, 'Masters in Education', '2004-06-05', 1),
(15, 'Mark', 'Torres', 'mtorres@school.edu', '217-555-1015', '2010-08-23', NULL, 8, 66000.00, 'Masters in Education', '2010-06-12', 1),
(16, 'Amanda', 'Peterson', 'apeterson@school.edu', '217-555-1016', '2017-08-21', NULL, 9, 48000.00, 'Bachelors in Music', '2017-06-01', 1),
(17, 'Steven', 'Hughes', 'shughes@school.edu', '217-555-1017', '2008-08-18', NULL, 10, 69000.00, 'Masters in Elementary Education', '2008-06-08', 1),
(18, 'Donna', 'Butler', 'dbutler@school.edu', '217-555-1018', '2011-08-15', NULL, 10, 63000.00, 'Masters in Early Childhood', '2011-06-15', 1),
(19, 'Paul', 'Sanders', 'psanders@school.edu', '217-555-1019', '2015-08-24', NULL, 11, 58000.00, 'Masters in Theology', '2015-05-20', 1),
(20, 'Michelle', 'Gray', 'mgray@school.edu', '217-555-1020', '2009-08-17', NULL, 12, 66000.00, 'Masters in Education', '2009-06-01', 1),
-- Terminated teacher still in system (TRAP)
(21, 'Andrew', 'Watson', 'awatson@school.edu', '217-555-1021', '2012-08-20', '2023-05-31', 1, 64000.00, 'Masters in Mathematics', '2012-06-10', 1),
-- Expired certification (TRAP - cert date very old with no renewal)
(22, 'Rachel', 'Brooks', 'rbrooks@school.edu', '217-555-1022', '1995-08-15', NULL, 3, 82000.00, 'Masters in English', '1995-06-01', 1),
(23, 'Timothy', 'Kelly', 'tkelly@school.edu', '217-555-1023', '2018-08-20', NULL, 2, 56000.00, 'Masters in Physics', '2018-06-15', 1),
(24, 'Laura', 'Howard', 'lhoward@school.edu', '217-555-1024', '2019-08-19', NULL, 1, 54000.00, 'Bachelors in Mathematics', '2019-06-01', 1),
(25, 'Kevin', 'Cox', 'kcox@school.edu', '217-555-1025', '2020-08-17', NULL, 4, 52000.00, 'Masters in History', '2020-06-08', 1),
-- Duplicate email (TRAP)
(26, 'Angela', 'Richardson', 'jmorrison@school.edu', '217-555-1026', '2021-08-16', NULL, 6, 50000.00, 'Bachelors in Art', '2021-06-01', 1),
(27, 'Jason', 'Wood', 'jwood@school.edu', '217-555-1027', '2016-08-22', NULL, 8, 61000.00, 'Masters in Education', '2016-06-10', 1),
(28, 'Melissa', 'James', 'mjames@school.edu', '217-555-1028', '2014-08-18', NULL, 10, 65000.00, 'Masters in Education', '2014-06-05', 1),
-- NULL salary (TRAP)
(29, 'Brian', 'Stewart', 'bstewart@school.edu', '217-555-1029', '2022-08-15', NULL, 5, NULL, 'Bachelors in Physical Education', '2022-06-01', 1),
(30, 'Christina', 'Ross', 'cross@school.edu', '217-555-1030', '2017-08-21', NULL, 7, 57000.00, 'Masters in German', '2017-06-12', 1);

-- Update department heads
UPDATE departments SET dept_head_id = 1 WHERE dept_id = 1;
UPDATE departments SET dept_head_id = 3 WHERE dept_id = 2;
UPDATE departments SET dept_head_id = 6 WHERE dept_id = 3;
UPDATE departments SET dept_head_id = 8 WHERE dept_id = 4;
UPDATE departments SET dept_head_id = 9 WHERE dept_id = 5;
UPDATE departments SET dept_head_id = 11 WHERE dept_id = 6;
UPDATE departments SET dept_head_id = 12 WHERE dept_id = 7;
UPDATE departments SET dept_head_id = 14 WHERE dept_id = 8;
UPDATE departments SET dept_head_id = 16 WHERE dept_id = 9;
UPDATE departments SET dept_head_id = 17 WHERE dept_id = 10;
UPDATE departments SET dept_head_id = 19 WHERE dept_id = 11;
UPDATE departments SET dept_head_id = 20 WHERE dept_id = 12;

-- Students (50 students with various data issues)
INSERT INTO students VALUES
(1, 'Emma', 'Johnson', 'ejohnson@student.edu', '217-555-2001', '2007-03-15', 'Female', '123 Oak Street', 'Springfield', 'IL', '62701', '2021-09-01', NULL, 11, 3.85, 'Active', 1),
(2, 'Liam', 'Williams', 'lwilliams@student.edu', '217-555-2002', '2007-07-22', 'Male', '456 Maple Ave', 'Springfield', 'IL', '62701', '2021-09-01', NULL, 11, 3.42, 'Active', 1),
(3, 'Olivia', 'Brown', 'obrown@student.edu', '217-555-2003', '2006-11-08', 'Female', '789 Pine Road', 'Springfield', 'IL', '62702', '2020-09-01', NULL, 12, 3.95, 'Active', 1),
(4, 'Noah', 'Jones', 'njones@student.edu', '217-555-2004', '2007-01-30', 'Male', '321 Elm Street', 'Springfield', 'IL', '62701', '2021-09-01', NULL, 11, 2.78, 'Active', 1),
(5, 'Ava', 'Garcia', 'agarcia@student.edu', '217-555-2005', '2006-05-17', 'Female', '654 Cedar Lane', 'Springfield', 'IL', '62703', '2020-09-01', NULL, 12, 3.67, 'Active', 1),
(6, 'Ethan', 'Miller', 'emiller@student.edu', '217-555-2006', '2008-09-25', 'Male', '987 Birch Blvd', 'Springfield', 'IL', '62701', '2022-09-01', NULL, 10, 3.21, 'Active', 1),
(7, 'Sophia', 'Davis', 'sdavis@student.edu', '217-555-2007', '2007-12-03', 'Female', '147 Walnut Way', 'Springfield', 'IL', '62702', '2021-09-01', NULL, 11, 3.88, 'Active', 1),
(8, 'Mason', 'Rodriguez', 'mrodriguez@student.edu', '217-555-2008', '2008-04-11', 'Male', '258 Spruce Court', 'Springfield', 'IL', '62701', '2022-09-01', NULL, 10, 2.95, 'Active', 1),
(9, 'Isabella', 'Martinez', 'imartinez@student.edu', '217-555-2009', '2006-08-19', 'Female', '369 Ash Drive', 'Springfield', 'IL', '62703', '2020-09-01', NULL, 12, 3.72, 'Active', 1),
(10, 'William', 'Anderson', 'wanderson@student.edu', '217-555-2010', '2007-02-27', 'Male', '741 Poplar Place', 'Springfield', 'IL', '62701', '2021-09-01', NULL, 11, 3.15, 'Active', 1),
(11, 'Mia', 'Taylor', 'mtaylor@student.edu', '217-555-2011', '2008-06-14', 'Female', '852 Willow Street', 'Springfield', 'IL', '62702', '2022-09-01', NULL, 10, 3.92, 'Active', 1),
(12, 'James', 'Thomas', 'jthomas@student.edu', '217-555-2012', '2006-10-21', 'Male', '963 Hickory Lane', 'Springfield', 'IL', '62701', '2020-09-01', NULL, 12, 2.85, 'Active', 1),
(13, 'Charlotte', 'Hernandez', 'chernandez@student.edu', '217-555-2013', '2007-04-05', 'Female', '159 Magnolia Ave', 'Springfield', 'IL', '62703', '2021-09-01', NULL, 11, 3.78, 'Active', 1),
(14, 'Benjamin', 'Moore', 'bmoore@student.edu', '217-555-2014', '2008-08-16', 'Male', '357 Dogwood Drive', 'Springfield', 'IL', '62701', '2022-09-01', NULL, 10, 3.45, 'Active', 1),
(15, 'Amelia', 'Jackson', 'ajackson@student.edu', '217-555-2015', '2006-12-28', 'Female', '468 Sycamore Road', 'Springfield', 'IL', '62702', '2020-09-01', NULL, 12, 3.98, 'Active', 1),
-- GPA above 4.0 (TRAP)
(16, 'Alexander', 'Martin', 'amartin@student.edu', '217-555-2016', '2007-06-09', 'Male', '579 Chestnut Street', 'Springfield', 'IL', '62701', '2021-09-01', NULL, 11, 4.25, 'Active', 1),
(17, 'Harper', 'Lee', 'hlee@student.edu', '217-555-2017', '2008-02-18', 'Female', '680 Beech Lane', 'Springfield', 'IL', '62703', '2022-09-01', NULL, 10, 3.55, 'Active', 1),
(18, 'Daniel', 'Perez', 'dperez@student.edu', '217-555-2018', '2006-09-24', 'Male', '791 Redwood Court', 'Springfield', 'IL', '62701', '2020-09-01', NULL, 12, 3.12, 'Active', 1),
(19, 'Evelyn', 'Thompson', 'ethompson@student.edu', '217-555-2019', '2007-05-02', 'Female', '802 Sequoia Way', 'Springfield', 'IL', '62702', '2021-09-01', NULL, 11, 3.82, 'Active', 1),
(20, 'Henry', 'White', 'hwhite@student.edu', '217-555-2020', '2008-11-13', 'Male', '913 Palm Drive', 'Springfield', 'IL', '62701', '2022-09-01', NULL, 10, 2.68, 'Active', 1),
-- Graduated student still active (TRAP)
(21, 'Victoria', 'Harris', 'vharris@student.edu', '217-555-2021', '2004-07-07', 'Female', '124 Cypress Lane', 'Springfield', 'IL', '62703', '2018-09-01', '2022-05-31', 12, 3.75, 'Active', 1),
(22, 'Sebastian', 'Sanchez', 'ssanchez@student.edu', '217-555-2022', '2007-03-29', 'Male', '235 Juniper Road', 'Springfield', 'IL', '62701', '2021-09-01', NULL, 11, 3.28, 'Active', 1),
(23, 'Scarlett', 'Clark', 'sclark@student.edu', '217-555-2023', '2008-01-15', 'Female', '346 Fir Street', 'Springfield', 'IL', '62702', '2022-09-01', NULL, 10, 3.91, 'Active', 1),
(24, 'Jack', 'Ramirez', 'jramirez@student.edu', '217-555-2024', '2006-06-20', 'Male', '457 Hemlock Ave', 'Springfield', 'IL', '62701', '2020-09-01', NULL, 12, 2.55, 'Active', 1),
(25, 'Aria', 'Lewis', 'alewis@student.edu', '217-555-2025', '2007-10-08', 'Female', '568 Locust Lane', 'Springfield', 'IL', '62703', '2021-09-01', NULL, 11, 3.65, 'Active', 1),
-- Middle school students
(26, 'Lucas', 'Robinson', 'lrobinson@student.edu', '217-555-2026', '2011-04-12', 'Male', '679 Mulberry Court', 'Springfield', 'IL', '62702', '2022-09-01', NULL, 7, 3.45, 'Active', 2),
(27, 'Grace', 'Walker', 'gwalker@student.edu', '217-555-2027', '2010-08-23', 'Female', '780 Hawthorn Drive', 'Springfield', 'IL', '62701', '2021-09-01', NULL, 8, 3.88, 'Active', 2),
(28, 'Owen', 'Young', 'oyoung@student.edu', '217-555-2028', '2011-12-01', 'Male', '891 Linden Street', 'Springfield', 'IL', '62703', '2022-09-01', NULL, 7, 2.92, 'Active', 2),
(29, 'Chloe', 'Allen', 'callen@student.edu', '217-555-2029', '2010-03-17', 'Female', '902 Alder Way', 'Springfield', 'IL', '62702', '2021-09-01', NULL, 8, 3.72, 'Active', 2),
(30, 'Elijah', 'King', 'eking@student.edu', '217-555-2030', '2012-07-29', 'Male', '113 Cottonwood Lane', 'Springfield', 'IL', '62701', '2023-09-01', NULL, 6, 3.15, 'Active', 2),
(31, 'Lily', 'Wright', 'lwright@student.edu', '217-555-2031', '2010-11-05', 'Female', '224 Aspen Road', 'Springfield', 'IL', '62703', '2021-09-01', NULL, 8, 3.95, 'Active', 2),
(32, 'Aiden', 'Scott', 'ascott@student.edu', '217-555-2032', '2011-05-14', 'Male', '335 Basswood Court', 'Springfield', 'IL', '62702', '2022-09-01', NULL, 7, 3.22, 'Active', 2),
(33, 'Zoey', 'Torres', 'ztorres@student.edu', '217-555-2033', '2012-09-26', 'Female', '446 Catalpa Drive', 'Springfield', 'IL', '62701', '2023-09-01', NULL, 6, 3.68, 'Active', 2),
(34, 'Jackson', 'Nguyen', 'jnguyen@student.edu', '217-555-2034', '2010-02-08', 'Male', '557 Ginkgo Street', 'Springfield', 'IL', '62703', '2021-09-01', NULL, 8, 3.05, 'Active', 2),
(35, 'Penelope', 'Hill', 'phill@student.edu', '217-555-2035', '2011-06-30', 'Female', '668 Hornbeam Lane', 'Springfield', 'IL', '62702', '2022-09-01', NULL, 7, 3.82, 'Active', 2),
-- Elementary students
(36, 'Leo', 'Adams', 'ladams@student.edu', '217-555-2036', '2015-01-19', 'Male', '779 Ironwood Ave', 'Springfield', 'IL', '62701', '2022-09-01', NULL, 3, 3.50, 'Active', 3),
(37, 'Riley', 'Nelson', 'rnelson@student.edu', '217-555-2037', '2014-04-27', 'Female', '880 Katsura Road', 'Springfield', 'IL', '62703', '2021-09-01', NULL, 4, 3.75, 'Active', 3),
(38, 'Jayden', 'Baker', 'jbaker@student.edu', '217-555-2038', '2016-08-11', 'Male', '991 Larch Court', 'Springfield', 'IL', '62702', '2023-09-01', NULL, 2, 3.25, 'Active', 3),
(39, 'Nora', 'Gonzalez', 'ngonzalez@student.edu', '217-555-2039', '2015-12-03', 'Female', '102 Mimosa Drive', 'Springfield', 'IL', '62701', '2022-09-01', NULL, 3, 3.88, 'Active', 3),
(40, 'Lincoln', 'Carter', 'lcarter@student.edu', '217-555-2040', '2014-06-15', 'Male', '213 Olive Street', 'Springfield', 'IL', '62703', '2021-09-01', NULL, 4, 3.12, 'Active', 3),
-- Private school students
(41, 'Hannah', 'Mitchell', 'hmitchell@stmarys.edu', '217-555-2041', '2008-05-22', 'Female', '324 Persimmon Way', 'Springfield', 'IL', '62704', '2022-09-01', NULL, 10, 3.92, 'Active', 4),
(42, 'Carter', 'Roberts', 'croberts@stmarys.edu', '217-555-2042', '2007-09-14', 'Male', '435 Quince Lane', 'Springfield', 'IL', '62704', '2021-09-01', NULL, 11, 3.45, 'Active', 4),
(43, 'Addison', 'Turner', 'aturner@stmarys.edu', '217-555-2043', '2006-11-28', 'Female', '546 Rowan Road', 'Springfield', 'IL', '62704', '2020-09-01', NULL, 12, 3.78, 'Active', 4),
(44, 'Wyatt', 'Phillips', 'wphillips@stmarys.edu', '217-555-2044', '2008-03-07', 'Male', '657 Sassafras Court', 'Springfield', 'IL', '62704', '2022-09-01', NULL, 10, 3.55, 'Active', 4),
(45, 'Eleanor', 'Campbell', 'ecampbell@stmarys.edu', '217-555-2045', '2007-07-19', 'Female', '768 Tulip Drive', 'Springfield', 'IL', '62704', '2021-09-01', NULL, 11, 3.95, 'Active', 4),
-- Withdrawn student
(46, 'Gabriel', 'Parker', 'gparker@student.edu', '217-555-2046', '2008-10-25', 'Male', '879 Viburnum Street', 'Springfield', 'IL', '62701', '2022-09-01', NULL, 10, 2.45, 'Withdrawn', 1),
-- Transferred student
(47, 'Aubrey', 'Evans', 'aevans@student.edu', '217-555-2047', '2007-02-11', 'Female', '980 Wisteria Lane', 'Springfield', 'IL', '62702', '2021-09-01', NULL, 11, 3.35, 'Transferred', 1),
-- Negative GPA (TRAP)
(48, 'Luke', 'Edwards', 'ledwards@student.edu', '217-555-2048', '2008-06-04', 'Male', '191 Yew Ave', 'Springfield', 'IL', '62703', '2022-09-01', NULL, 10, -0.50, 'Active', 1),
-- Suspended student
(49, 'Savannah', 'Collins', 'scollins@student.edu', '217-555-2049', '2007-08-16', 'Female', '302 Zelkova Road', 'Springfield', 'IL', '62701', '2021-09-01', NULL, 11, 2.88, 'Suspended', 1),
-- Student at inactive school (TRAP)
(50, 'Isaac', 'Stewart', 'istewart@student.edu', '217-555-2050', '2007-12-22', 'Male', '413 Acacia Court', 'Springfield', 'IL', '62705', '2021-09-01', NULL, 11, 3.15, 'Active', 5);

-- Guardians
INSERT INTO guardians VALUES
(1, 'Robert', 'Johnson', 'Father', 'rjohnson@email.com', '217-555-3001', '123 Oak Street', 'Springfield', 'IL', '62701', 1),
(2, 'Mary', 'Johnson', 'Mother', 'mjohnson@email.com', '217-555-3002', '123 Oak Street', 'Springfield', 'IL', '62701', 1),
(3, 'Thomas', 'Williams', 'Father', 'twilliams@email.com', '217-555-3003', '456 Maple Ave', 'Springfield', 'IL', '62701', 1),
(4, 'Linda', 'Williams', 'Mother', 'lwilliams@email.com', '217-555-3004', '456 Maple Ave', 'Springfield', 'IL', '62701', 0),
(5, 'Charles', 'Brown', 'Father', 'cbrown@email.com', '217-555-3005', '789 Pine Road', 'Springfield', 'IL', '62702', 1),
(6, 'Barbara', 'Brown', 'Mother', 'bbrown@email.com', '217-555-3006', '789 Pine Road', 'Springfield', 'IL', '62702', 1),
(7, 'Joseph', 'Jones', 'Father', 'jjones@email.com', '217-555-3007', '321 Elm Street', 'Springfield', 'IL', '62701', 1),
(8, 'Patricia', 'Garcia', 'Mother', 'pgarcia@email.com', '217-555-3008', '654 Cedar Lane', 'Springfield', 'IL', '62703', 1),
(9, 'George', 'Miller', 'Father', 'gmiller@email.com', '217-555-3009', '987 Birch Blvd', 'Springfield', 'IL', '62701', 1),
(10, 'Elizabeth', 'Davis', 'Mother', 'edavis@email.com', '217-555-3010', '147 Walnut Way', 'Springfield', 'IL', '62702', 1),
(11, 'Kenneth', 'Rodriguez', 'Father', 'krodriguez@email.com', '217-555-3011', '258 Spruce Court', 'Springfield', 'IL', '62701', 1),
(12, 'Susan', 'Martinez', 'Mother', 'smartinez@email.com', '217-555-3012', '369 Ash Drive', 'Springfield', 'IL', '62703', 1),
(13, 'Edward', 'Anderson', 'Father', 'eanderson@email.com', '217-555-3013', '741 Poplar Place', 'Springfield', 'IL', '62701', 1),
(14, 'Dorothy', 'Taylor', 'Mother', 'dtaylor@email.com', '217-555-3014', '852 Willow Street', 'Springfield', 'IL', '62702', 1),
(15, 'Brian', 'Thomas', 'Father', 'bthomas@email.com', '217-555-3015', '963 Hickory Lane', 'Springfield', 'IL', '
62701', 1),
(16, 'Margaret', 'Hernandez', 'Mother', 'mhernandez@email.com', '217-555-3016', '159 Magnolia Ave', 'Springfield', 'IL', '62703', 1),
(17, 'Ronald', 'Moore', 'Father', 'rmoore@email.com', '217-555-3017', '357 Dogwood Drive', 'Springfield', 'IL', '62701', 1),
(18, 'Helen', 'Jackson', 'Mother', 'hjackson@email.com', '217-555-3018', '468 Sycamore Road', 'Springfield', 'IL', '62702', 1),
(19, 'Anthony', 'Martin', 'Father', 'amartin@email.com', '217-555-3019', '579 Chestnut Street', 'Springfield', 'IL', '62701', 1),
(20, 'Sandra', 'Lee', 'Mother', 'slee@email.com', '217-555-3020', '680 Beech Lane', 'Springfield', 'IL', '62703', 1);

-- Student-Guardian relationships
INSERT INTO student_guardians VALUES
(1, 1, 1), (1, 2, 0),
(2, 3, 1), (2, 4, 0),
(3, 5, 1), (3, 6, 0),
(4, 7, 1),
(5, 8, 1),
(6, 9, 1),
(7, 10, 1),
(8, 11, 1),
(9, 12, 1),
(10, 13, 1),
(11, 14, 1),
(12, 15, 1),
(13, 16, 1),
(14, 17, 1),
(15, 18, 1),
(16, 19, 1),
(17, 20, 1);

-- Courses
INSERT INTO courses VALUES
(1, 'MATH101', 'Algebra I', 1, 3, 30, 'Introduction to algebraic concepts', 1),
(2, 'MATH201', 'Geometry', 1, 3, 30, 'Euclidean geometry fundamentals', 1),
(3, 'MATH301', 'Calculus', 1, 4, 25, 'Differential and integral calculus', 1),
(4, 'SCI101', 'Biology', 2, 4, 28, 'Introduction to life sciences', 1),
(5, 'SCI201', 'Chemistry', 2, 4, 28, 'General chemistry principles', 1),
(6, 'SCI301', 'Physics', 2, 4, 25, 'Classical mechanics and thermodynamics', 1),
(7, 'ENG101', 'English Literature', 3, 3, 30, 'Survey of classic literature', 1),
(8, 'ENG201', 'Creative Writing', 3, 3, 25, 'Fiction and poetry writing', 1),
(9, 'HIST101', 'World History', 4, 3, 30, 'Global historical survey', 1),
(10, 'HIST201', 'American History', 4, 3, 30, 'US history from colonial times', 1),
(11, 'PE101', 'Physical Education', 5, 1, 40, 'General fitness and sports', 1),
(12, 'ART101', 'Introduction to Art', 6, 2, 25, 'Basic art techniques', 1),
(13, 'SPAN101', 'Spanish I', 7, 3, 28, 'Beginning Spanish', 1),
(14, 'FREN101', 'French I', 7, 3, 28, 'Beginning French', 1);

-- Class Sections
INSERT INTO class_sections VALUES
(1, 1, 1, 'Fall', '2023-2024', 'A101', 'MWF', '08:00', '08:50', 30),
(2, 1, 2, 'Fall', '2023-2024', 'A102', 'MWF', '09:00', '09:50', 30),
(3, 2, 1, 'Fall', '2023-2024', 'A101', '10:00', '10:50', '10:50', 30),
(4, 3, 2, 'Fall', '2023-2024', 'A103', 'TTH', '08:00', '09:15', 25),
(5, 4, 3, 'Fall', '2023-2024', 'B201', 'MWF', '10:00', '10:50', 28),
(6, 5, 4, 'Fall', '2023-2024', 'B202', 'MWF', '11:00', '11:50', 28),
(7, 6, 23, 'Fall', '2023-2024', 'B203', 'TTH', '09:30', '10:45', 25),
(8, 7, 5, 'Fall', '2023-2024', 'C101', 'MWF', '08:00', '08:50', 30),
(9, 8, 6, 'Fall', '2023-2024', 'C102', 'TTH', '10:00', '11:15', 25),
(10, 9, 7, 'Fall', '2023-2024', 'D101', 'MWF', '09:00', '09:50', 30),
(11, 10, 8, 'Fall', '2023-2024', 'D102', 'MWF', '10:00', '10:50', 30),
(12, 11, 9, 'Fall', '2023-2024', 'GYM1', 'TTH', '13:00', '13:50', 40),
(13, 12, 11, 'Fall', '2023-2024', 'E101', 'MWF', '14:00', '14:50', 25),
(14, 13, 12, 'Fall', '2023-2024', 'F101', 'MWF', '11:00', '11:50', 28),
(15, 14, 13, 'Fall', '2023-2024', 'F102', 'MWF', '12:00', '12:50', 28);

-- Enrollments
INSERT INTO enrollments (student_id, section_id, enrollment_date, status, final_grade, grade_points) VALUES
(1, 1, '2023-09-01', 'Enrolled', 'A', 4.00),
(1, 5, '2023-09-01', 'Enrolled', 'A-', 3.67),
(1, 8, '2023-09-01', 'Enrolled', 'A', 4.00),
(2, 1, '2023-09-01', 'Enrolled', 'B+', 3.33),
(2, 6, '2023-09-01', 'Enrolled', 'B', 3.00),
(2, 10, '2023-09-01', 'Enrolled', 'B+', 3.33),
(3, 4, '2023-09-01', 'Enrolled', 'A', 4.00),
(3, 7, '2023-09-01', 'Enrolled', 'A', 4.00),
(4, 2, '2023-09-01', 'Enrolled', 'C+', 2.33),
(4, 5, '2023-09-01', 'Enrolled', 'C', 2.00),
(5, 4, '2023-09-01', 'Enrolled', 'A-', 3.67),
(6, 1, '2023-09-01', 'Enrolled', 'B', 3.00),
(7, 3, '2023-09-01', 'Enrolled', 'A', 4.00);

-- Assignments
INSERT INTO assignments VALUES
(1, 1, 'Algebra Quiz 1', 'Basic equations', 'Quiz', '2023-09-15', 100, 10.00),
(2, 1, 'Algebra Midterm', 'Chapters 1-5', 'Exam', '2023-10-20', 200, 25.00),
(3, 1, 'Algebra Final', 'Comprehensive', 'Exam', '2023-12-15', 300, 35.00),
(4, 5, 'Biology Lab 1', 'Cell observation', 'Lab', '2023-09-22', 50, 5.00),
(5, 5, 'Biology Midterm', 'Cellular biology', 'Exam', '2023-10-25', 150, 20.00),
(6, 8, 'Essay 1', 'Literary analysis', 'Essay', '2023-09-29', 100, 15.00),
(7, 8, 'Poetry Project', 'Original poems', 'Project', '2023-11-10', 150, 20.00);

-- Grades
INSERT INTO grades (student_id, assignment_id, points_earned, submitted_date, graded_date, feedback) VALUES
(1, 1, 95.00, '2023-09-14', '2023-09-16', 'Excellent work'),
(1, 2, 185.00, '2023-10-20', '2023-10-25', 'Strong understanding'),
(2, 1, 78.00, '2023-09-15', '2023-09-17', 'Good effort, review factoring'),
(2, 2, 156.00, '2023-10-20', '2023-10-26', 'Improved from quiz'),
(1, 4, 48.00, '2023-09-21', '2023-09-24', 'Good lab technique'),
(1, 5, 142.00, '2023-10-25', '2023-10-30', 'Well prepared');