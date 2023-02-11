-- Harrison Chambers
-- Importing business data into MySQL

-- deleting existing tables
SHOW DATABASES;
DROP TABLES employee_info, employee_info_1, work_records; -- getting rid of tables created during testing

-- importing tables from .csv files was done in TablePlus using the import function.
-- the following is the resulting upload query/command for one of the tables:
INSERT INTO `employee_info` (`Employee ID`, `Full Name`) VALUES
('E002', 'Irene Travis'),
('E003', 'Deon Walls'),
('E004', 'Evangeline Reed'),
('E005', 'Josie Gamble'),
('E006', 'Phoebe Harrington'),
('E007', 'Lillian Newton'),
('E008', 'Franco Dougherty'),
('E009', 'Calvin Howard'),
('E010', 'Cadence Hutchinson'),
('E011', 'Nevaeh Barrett'),
('E012', 'Jeremiah Little'); 

-- Note: The names used for employees and customers have been replaced with names from a random name generator. 

-- After repeating the import process for every table, I check to see that I've got all the tables:
SHOW TABLES;
-- Results:
-- customer_info
-- customer_transactions
-- employee_info
-- employee_transactions
-- job_records
-- supplier_info
-- supplier_transactions
-- work_records

-- These are all the tables I've created for this project, and they all appear to have succesfully uploaded.