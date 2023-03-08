-- DASHBOARD

-- ---------------------------------------------------------------------------------------
-- Employee Report

-- This set of queries analyzes employee data to answer a few questions:
-- *    How much has this employee cost the business (this month)?
-- *    How many hours have they worked (this month)?
-- *    What does each employee cost per hour, on average?

-- This analysis has a major flaw, but it is still useful.
-- Specifically, each employee had a set hourly rate, and owner-employees shared a portion of the company profit on top of their hourly rates.
-- The hourly rates have been lost to time, but this analysis will give us an estimate.

-- This doesn't account for the overhead hours spent finding customers, building websites, etc., but getting figures for cost of labour will help with further profitability analysis.

WITH newtable AS (
	SELECT
		supplier_transactions.`Employee ID` AS e_id,
		supplier_transactions.`Method` AS t_type,
		supplier_transactions.Amount AS Amt
	FROM
		supplier_transactions
	UNION ALL
	SELECT
		employee_transactions.`Employee ID` AS e_id,
		employee_transactions.`Type` AS t_type,
		employee_transactions.Amount AS Amt
	FROM
		employee_transactions
)
SELECT
	newtable.e_id,
	SUM(
		CASE WHEN t_type = 'Payout - Paycheck' THEN
			Amt
		WHEN t_type = 'Charge - Received Payment' THEN
			Amt
		WHEN t_type = 'Payout - Reimbursement' THEN
			Amt
		END) - SUM(
		CASE WHEN t_type = 'Payback - Deposit' THEN
			Amt
		WHEN t_type = 'Employee Expense' THEN
			Amt
		END) AS cost_of_labour
FROM newtable
WHERE newtable.e_id <> ''
GROUP BY e_id
ORDER BY e_id

-- this is a WORK IN PROGRESS, still issues to be fixed.