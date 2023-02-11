-- Harrison Chambers
-- Analyzing shift logs from old LPL data

-- ---------------------------------------------------------------------------------------
-- Tools and concepts used:

-- SELECT, WHERE, FROM
-- GROUP BY, ORDER BY, LIMIT
-- Aggregate functions like SUM(), COUNT(), MIN(), AVG(), MAX()
-- Date functions like YEAR(), MONTH(), DAYOFWEEK(), DATEDIFF()
-- Operators like <, >
-- JOIN clause
-- Common Table Expressions (using WITH)

-- ---------------------------------------------------------------------------------------
-- SHIFT COUNTING ANALYSIS

-- How many shifts were taken in total?
SELECT COUNT('Work Record ID') AS 'Total Shifts'
FROM work_records

-- > 1362

-- How many shifts were taken in each year?
SELECT
	COUNT('Work Record ID') AS 'Number Shifts', 
	YEAR(Date) AS 'Year'
FROM
	work_records
GROUP BY
	YEAR(Date)
	
-- 'Work Record ID' might be wrong. Looks as if it's not referencing the actual variable since I had to remove the ticks for it to parse the Date field properly.
-- --> come back to this either at the end or when it presents a real, functional issue.

-- Results from query:

-- Number Shifts	Year
-- 227	2015
-- 270	2016
-- 482	2017
-- 383	2018

-- How many shifts were taken each month of each year?
SELECT
	COUNT('Work Record ID') AS 'Number Shifts',
	YEAR(Date) AS 'Year',
	MONTH(Date) AS 'Month'
FROM
	work_records
GROUP BY
	YEAR(Date),
	MONTH(Date)
	
-- How many shifts were taken each month in total?
SELECT
	COUNT('Work Record ID') AS 'Number Shifts',
	MONTH(Date) AS 'Month'
FROM
	work_records
GROUP BY
	MONTH(Date)
ORDER BY -- added this in because it listed April last (presumably because our first April shift came in our second year, so after our other later month's shifts)
	MONTH(Date)
	
-- How many shifts were taken on each day of the week?
SELECT
	COUNT('Work Record ID') AS 'Number Shifts',
	DAYOFWEEK(Date) AS 'Day of Week'
FROM
	work_records
GROUP BY
	DAYOFWEEK(Date)
ORDER BY
	DAYOFWEEK(Date)
	
-- How many shifts were taken on each day of the week, each year?
SELECT
	COUNT('Work Record ID') AS 'Number Shifts',
	DAYOFWEEK(Date) AS 'Day of Week',
	YEAR(Date) AS 'Year'
FROM
	work_records
GROUP BY
	YEAR(Date),
	DAYOFWEEK(Date)
ORDER BY
	YEAR(Date),
	DAYOFWEEK(Date)
	
-- What was the highest number of shifts on a single day, and which day was that?
SELECT
	COUNT(`Work Record ID`) AS 'No. Shifts', -- using the backtick when identifying the variable seems to have done the trick; I tested this with the No. Hrs column as well.
	DATE
FROM
	work_records
GROUP BY
	Date
ORDER BY
	COUNT(`Work Record ID`)
	DESC
LIMIT 1
-- Result: 2018-07-03, 17 shifts

-- How many shifts in an average year?
SELECT
	COUNT(`Work Record ID`) AS 'No. Shifts', -- using the backtick when identifying the variable seems to have done the trick; I tested this with the No. Hrs column as well.
	YEAR(Date)
FROM
	work_records
GROUP BY
	YEAR(Date)
ORDER BY
	YEAR(Date),
	DESC
	
-- What was the first day of each operating season?
-- What was the last day of each operating season?
-- How long did each operating season run?

SELECT
	Min(Date) AS 'First Operating Day',
	MAX(Date) AS 'Last Operating Day',
	DATEDIFF(MAX(Date), MIN(Date)) AS 'Season Length, Days',
	YEAR(Date) AS 'Year'
FROM
	work_records
GROUP BY
	YEAR(Date)

-- How many shifts in an average month?
SELECT
	COUNT(`Work Record ID`) AS 'shifts',
	MONTH(Date) AS 'Month',
	YEAR(Date) AS 'Year'
FROM
	work_records
GROUP BY
	YEAR(Date),
	MONTH(Date)
-- --> By showing all months, we see that April and september shouldn't be included to calculate the average:
SELECT
	COUNT(`Work Record ID`) / 16 AS 'avg shifts'
FROM
	work_records
WHERE
	MONTH(Date) > 4
	AND MONTH(Date) < 9
-- --> Result: 84.3125 shifts per month
	
-- How many shifts in an average week?
-- using the same analysis period as last time (May-August), there are 123 days each year, making for 70.2857 weeks over the four years in the analysis period:
SELECT
	COUNT(`Work Record ID`) / 70.2857 AS 'avg shifts'
FROM
	work_records
WHERE
	MONTH(Date) > 4
	AND MONTH(Date) < 9
-- --> Result: 19.1931 shifts per week

-- How many shifts in an average day?
-- With this one it's a bit easier to be a little more accurate:
SELECT
	COUNT(DISTINCT (Date)) AS 'numberWorkingDays',
	COUNT(`Work Record ID`) / COUNT(DISTINCT (Date)) AS 'AvgShiftsPerDay'
FROM
	work_records

-- Which week had the most shifts?
SELECT
	YEARWEEK(Date) AS 'Year Week',
	COUNT(`Work Record ID`) AS 'Number of Shifts'
FROM
	work_records
GROUP BY
	YEARWEEK(Date)
ORDER BY
	COUNT(`Work Record ID`)
	DESC
LIMIT 1

-- ---------------------------------------------------------------------------------------
-- SHIFT HOURS ANALYSIS

-- How many hours were worked in total?
SELECT
	SUM(`No. Hrs`) AS "Total Hrs"
FROM
	work_records

-- What was the average shift length?
SELECT
	SUM(`No. Hrs`)/COUNT(`Work Record ID`) AS "Average Shift Length"
FROM
	work_records

-- How many hours were worked each year?
SELECT
	SUM(`No. Hrs`) AS "Total Hours", YEAR(Date) AS "Year"
FROM
	work_records
GROUP BY
	YEAR(Date)

-- Each month?
SELECT
	SUM(`No. Hrs`) AS "Total Hours",
	MONTH(Date) AS "Month"
FROM
	work_records
GROUP BY
	MONTH(Date)
ORDER BY
	MONTH(Date)

-- Each month of each year?
SELECT
	SUM(`No. Hrs`) AS "Total Hours",
	YEAR(Date) AS "Year",
	MONTH(Date) AS "Month"
FROM
	work_records
GROUP BY
	YEAR(Date),
	MONTH(Date)
ORDER BY
	YEAR(Date),
	MONTH(Date)
	
-- Each Day of the Week?
SELECT
	SUM(`No. Hrs`) AS "Total Hours",
	COUNT(`Work Record ID`) AS "Number of Shifts",
	SUM(`No. Hrs`) / COUNT(`Work Record ID`) AS "Avg Shift Length",
	DAYOFWEEK(Date) AS "Day of Week"
FROM
	work_records
GROUP BY
	DAYOFWEEK(Date)
ORDER BY
	DAYOFWEEK(Date)

-- Each DotW each year?
-- What was the average shift length for each DotW each year?
SELECT
	ROUND(SUM(`No. Hrs`), 2) AS "Total Hours",
	COUNT(`Work Record ID`) AS "Number of Shifts",
	ROUND(SUM(`No. Hrs`) / COUNT(`Work Record ID`), 2) AS "Avg Shift Length",
	DAYOFWEEK(Date) AS "Day of Week",
	YEAR(Date) AS "Year"
FROM
	work_records
GROUP BY
	YEAR(Date),
	DAYOFWEEK(Date)
ORDER BY
	YEAR(Date),
	DAYOFWEEK(Date)
-- --> I'm starting to combine these queries in order to reduce the number of queries I'd have to write. 
-- --> From here, there's a lot of interesting data to inspect (ie. how did Sunday work change over the years? Which day had the most hours? etc.)

-- What was the average shift length for each year?
SELECT
	ROUND(SUM(`No. Hrs`), 2) AS "Total Hours",
	COUNT(`Work Record ID`) AS "Number Shifts",
	ROUND(SUM(`No. Hrs`) / COUNT(`Work Record ID`), 2) AS "Average Shift Length (hrs)",
	YEAR(Date) AS "Year"
FROM
	work_records
GROUP BY
	YEAR(Date)

-- What was the average shift length for each month?
SELECT
	ROUND(SUM(`No. Hrs`), 2) AS "Total Hours",
	COUNT(`Work Record ID`) AS "Number Shifts",
	ROUND(SUM(`No. Hrs`) / COUNT(`Work Record ID`), 2) AS "Average Shift Length (hrs)",
	MONTH(Date) AS "Month"
FROM
	work_records
GROUP BY
	MONTH(Date)
ORDER BY
	MONTH(Date)
	
-- What was the average shift length for each month of each year?
SELECT
	ROUND(SUM(`No. Hrs`), 2) AS "Total Hours",
	COUNT(`Work Record ID`) AS "Number Shifts",
	ROUND(SUM(`No. Hrs`) / COUNT(`Work Record ID`), 2) AS "Average Shift Length (hrs)",
	YEAR(Date) AS "Year",
	MONTH(Date) AS "Month"
FROM
	work_records
GROUP BY
	YEAR(Date),
	MONTH(Date)
ORDER BY
	YEAR(Date),
	MONTH(Date)

-- What was the average shift length for each day of the week?
SELECT
	ROUND(SUM(`No. Hrs`), 2) AS "Total Hours",
	COUNT(`Work Record ID`) AS "Number Shifts",
	ROUND(SUM(`No. Hrs`) / COUNT(`Work Record ID`), 2) AS "Average Shift Length (hrs)",
	DAYOFWEEK(Date) AS "Day of Week"
FROM
	work_records
GROUP BY
	DAYOFWEEK(Date)
ORDER BY
	DAYOFWEEK(Date)


-- ---------------------------------------------------------------------------------------
-- EMPLOYEE SHIFTS + HOURS ANALYSIS

-- Which employees had the most hours, most shifts, and longest average shifts?
SELECT
	ROUND(SUM(work_records. `No. Hrs`),2) AS "Total Hrs",
	COUNT(work_records.`Work Record ID`) AS "Number Shifts",
	ROUND(SUM(work_records.`No. Hrs`)/COUNT(work_records.`Work Record ID`),2) AS "Average Shift Length",
	work_records. `Employee ID` AS "employee ID",
	employee_info. `Full Name` AS "Name"
FROM
	work_records
	INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
GROUP BY
	work_records.`Employee ID`,
	employee_info.`Full Name`
ORDER BY
	work_records.`Employee ID`

-- Split total hours, total shifts, and average shift length by year for each employee.
SELECT
	ROUND(SUM(work_records. `No. Hrs`),2) AS "Total Hrs",
	COUNT(work_records.`Work Record ID`) AS "Number Shifts",
	ROUND(SUM(work_records.`No. Hrs`)/COUNT(work_records.`Work Record ID`),2) AS "Average Shift Length",
	YEAR(work_records.`Date`) AS "Year",
	employee_info. `Full Name` AS "Name"
FROM
	work_records
	INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
/*
WHERE
	employee_info.`Full Name` = "Irene Travis"
*/
GROUP BY
	YEAR(work_records.`Date`),
	employee_info.`Full Name`
ORDER BY
	YEAR(work_records.`Date`),
	employee_info.`Full Name`	
-- --> In order to look at one employee individually, use the commented out where clause.

-- Split total hours, total shifts, and average shift length by month for each employee.
SELECT
	ROUND(SUM(work_records. `No. Hrs`),2) AS "Total Hrs",
	COUNT(work_records.`Work Record ID`) AS "Number Shifts",
	ROUND(SUM(work_records.`No. Hrs`)/COUNT(work_records.`Work Record ID`),2) AS "Average Shift Length",
--	YEAR(work_records.`Date`) AS "Year",
	MONTH(work_records.`Date`) AS "Month",
	employee_info. `Full Name` AS "Name"
FROM
	work_records
	INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
/*
WHERE
	employee_info.`Full Name` = "Irene Travis"
*/
GROUP BY
	MONTH(work_records.`Date`),
	employee_info.`Full Name`
ORDER BY
	MONTH(work_records.`Date`),
	employee_info.`Full Name`

-- Split total hours, total shifts, and average shift length by each month of each year for each employee.
SELECT
	ROUND(SUM(work_records. `No. Hrs`),2) AS "Total Hrs",
	COUNT(work_records.`Work Record ID`) AS "Number Shifts",
	ROUND(SUM(work_records.`No. Hrs`)/COUNT(work_records.`Work Record ID`),2) AS "Average Shift Length",
	YEAR(work_records.`Date`) AS "Year",
--	MONTH(work_records.`Date`) AS "Month #",
	MONTHNAME(work_records.`Date`) AS "Month",
	employee_info. `Full Name` AS "Name"
FROM
	work_records
	INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
/*
WHERE
	employee_info.`Full Name` = "Irene Travis"
*/
GROUP BY
	YEAR(work_records.`Date`),
	MONTHNAME(work_records.`Date`),
	employee_info.`Full Name`
ORDER BY
	YEAR(work_records.`Date`),
	MONTHNAME(work_records.`Date`),
	employee_info.`Full Name`	
-- --> started using MONTHNAME function to improve legibility of results

-- Split total hours, total shifts, and average shift length by day of week for each employee.
SELECT
	ROUND(SUM(work_records. `No. Hrs`), 2) AS "Total Hrs",
	COUNT(work_records. `Work Record ID`) AS "Number Shifts",
	ROUND(SUM(work_records. `No. Hrs`) / COUNT(work_records. `Work Record ID`), 2) AS "Average Shift Length",
	DAYNAME(work_records. `Date`) AS "Day",
--	YEAR(work_records.`Date`) AS "Year",
--	MONTH(work_records.`Date`) AS "Month #",
--	MONTHNAME(work_records. `Date`) AS "Month",
	employee_info. `Full Name` AS "Name"
FROM
	work_records
	INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
	/*
WHERE
	 employee_info.`Full Name` = "Irene Travis"
	 */
GROUP BY
	DAYNAME(work_records. `Date`),
	employee_info. `Full Name`
ORDER BY
	DAYNAME(work_records. `Date`),
	employee_info. `Full Name`
-- --> Similarly, started using DAYNAME fxn to improve legibility here.

-- Split total hours, total shifts, and average shift length by DotW by year for each employee.
SELECT
	ROUND(SUM(work_records. `No. Hrs`), 2) AS "Total Hrs",
	COUNT(work_records. `Work Record ID`) AS "Number Shifts",
	ROUND(SUM(work_records. `No. Hrs`) / COUNT(work_records. `Work Record ID`), 2) AS "Average Shift Length",
	DAYNAME(work_records. `Date`) AS "Day",
	YEAR(work_records.`Date`) AS "Year",
--	MONTH(work_records.`Date`) AS "Month #",
--	MONTHNAME(work_records. `Date`) AS "Month",
	employee_info. `Full Name` AS "Name"
FROM
	work_records
	INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
	/*
WHERE
	 employee_info.`Full Name` = "Irene Travis"
	 */
GROUP BY
	YEAR(work_records.`Date`),
	DAYNAME(work_records. `Date`),
	employee_info. `Full Name`
ORDER BY
	YEAR(work_records.`Date`),
	DAYNAME(work_records. `Date`),
	employee_info. `Full Name`
	
-- --> At this point, the query has >100 resulting rows, making it less useful to read as raw data.
-- This might be better in a graphical format, or alternatively, use a where clause to look at more isolated data (ie. one employee, one year, etc.)

-- For any of the following queries, you simply replicate the above queries, but order by the desired characteristic (descending) and limit to 1 result.
-- I will do the one about years for an example.

-- Which year had the most shifts, most hours, and highest average shift length for any one employee?
-- Which month of which year had the most shifts, most hours, and highest average shift length for any one employee?
-- Which month had the most shifts, most hours, and highest average shift length for any one employee?
-- Which day of the week had the most shifts, most hours, and highest average shift length for any one employee?
-- Which DotW by year had the most shifts, most hours, and highest average shift length for any one employee?

-- The following query finds the highest number of shifts by any employee in any one year:
SELECT
--	ROUND(SUM(work_records. `No. Hrs`), 2) AS "Total Hrs",
	COUNT(work_records. `Work Record ID`) AS "Number Shifts",
--	ROUND(SUM(work_records. `No. Hrs`) / COUNT(work_records. `Work Record ID`), 2) AS "Average Shift Length",
--	DAYNAME(work_records. `Date`) AS "Day",
	YEAR(work_records.`Date`) AS "Year",
--	MONTH(work_records.`Date`) AS "Month #",
--	MONTHNAME(work_records. `Date`) AS "Month",
	employee_info. `Full Name` AS "Name"
FROM
	work_records
	INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
	/*
WHERE
	 employee_info.`Full Name` = "Irene Travis"
	 */
GROUP BY
	YEAR(work_records.`Date`),
	employee_info. `Full Name`
ORDER BY
	COUNT(work_records. `Work Record ID`) DESC
LIMIT 1

-- --> The result was that in 2018, Deon Walls did 203 shifts.

-- Which employees had the most days in total which were less than 4 hours?
WITH dailyTotals AS (
	SELECT
		work_records. `Date` AS Date,
		SUM(work_records. `No. Hrs`) AS hours,
		COUNT(work_records. `Work Record ID`) AS shifts,
		work_records. `Employee ID` AS employeeID,
		employee_info. `Full Name` AS Name
	FROM
		work_records
		INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
	GROUP BY
		work_records. `Date`,
		work_records. `Employee ID`,
		employee_info. `Full Name`
)
SELECT
	employeeID,
	Name,
	COUNT(Date) AS "Garbage Days"
FROM
	dailyTotals
WHERE
	hours < 4
GROUP BY
	employeeID,
	Name
ORDER BY
	Count(Date) DESC

-- Which employees had the most days (as a %) which were less than 4 hours?
WITH dailyTotals AS (
	SELECT
		work_records. `Date` AS Date,
		SUM(work_records. `No. Hrs`) AS hours,
		COUNT(work_records. `Work Record ID`) AS shifts,
		work_records. `Employee ID` AS employeeID,
		employee_info. `Full Name` AS Name
	FROM
		work_records
		INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
	GROUP BY
		work_records. `Date`,
		work_records. `Employee ID`,
		employee_info. `Full Name`
)
SELECT
	employeeID,
	Name,
	COUNT(*) AS total_days,
	COUNT(CASE when hours < 4 THEN 'garbage' END) AS garbage_days,
	100*(COUNT(CASE when hours < 4 THEN 'garbage' END)/COUNT(*)) AS pct_garbage
FROM
	dailyTotals
GROUP BY
	employeeID,
	Name


-- Which employees had the most days in total which were more than 7 hours?
WITH dailyTotals AS (
	SELECT
		work_records. `Date` AS Date,
		SUM(work_records. `No. Hrs`) AS hours,
		COUNT(work_records. `Work Record ID`) AS shifts,
		work_records. `Employee ID` AS employeeID,
		employee_info. `Full Name` AS Name
	FROM
		work_records
		INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
	GROUP BY
		work_records. `Date`,
		work_records. `Employee ID`,
		employee_info. `Full Name`
)
SELECT
	employeeID,
	Name,
	COUNT(Date) AS "Good Days"
FROM
	dailyTotals
WHERE
	hours > 7
GROUP BY
	employeeID,
	Name

-- Which employees had the most days (as a %) which were more than 7 hours?
WITH dailyTotals AS (
	SELECT
		work_records. `Date` AS Date,
		SUM(work_records. `No. Hrs`) AS hours,
		COUNT(work_records. `Work Record ID`) AS shifts,
		work_records. `Employee ID` AS employeeID,
		employee_info. `Full Name` AS Name
	FROM
		work_records
		INNER JOIN employee_info ON work_records. `Employee ID` = employee_info. `Employee ID`
	GROUP BY
		work_records. `Date`,
		work_records. `Employee ID`,
		employee_info. `Full Name`
)
SELECT
	employeeID,
	Name,
	COUNT(*) AS total_days,
	COUNT(CASE when hours > 7 THEN 'good' END) AS good_days,
	100*(COUNT(CASE when hours > 7 THEN 'good' END)/COUNT(*)) AS pct_good
FROM
	dailyTotals
GROUP BY
	employeeID,
	Name

-- ---------------------------------------------------------------------------------------
-- CUSTOMER ANALYSIS

-- Which customers gave us work consistently?
-- --> list customers with total hrs > 0 for x/y years, months, weeks, etc.
-- --> (1) Who were our top ten customers by hours?
SELECT
	work_records. `Customer ID` AS customerID,
	customer_info. `Name` AS Name,
	SUM(work_records. `No. Hrs`) AS numHrs
FROM
	work_records
	INNER JOIN customer_info ON work_records. `Customer ID` = customer_info. `Customer ID`
GROUP BY
	work_records. `Customer ID`,
	customer_info. `Name`
ORDER BY
	SUM(work_records. `No. Hrs`)
	DESC
LIMIT 10

--> (2) Which customers gave us work month over month, year over year?
WITH annuals AS (
	SELECT
		MONTHNAME(work_records. `Date`) AS month,
		YEAR(work_records. `Date`) AS year,
		work_records. `Customer ID` AS customerID,
		customer_info. `Name` AS name,
		sum(work_records. `No. Hrs`) AS totHrs
	FROM
		work_records
		INNER JOIN customer_info ON work_records. `Customer ID` = customer_info. `Customer ID`
	GROUP BY
		year,
		month,
		name,
		customerID
)
SELECT
	customerID,
	name,
	count(*) AS numMonths
FROM
	annuals
GROUP BY
	customerID,
	name
ORDER BY
	count(*)
	DESC

-- Which customers worked with the most employees?
SELECT
	work_records. `Customer ID`,
	customer_info. `Name`,
	COUNT(DISTINCT (work_records. `Employee ID`)) AS "EmployeeCount"
FROM
	work_records
	INNER JOIN customer_info ON work_records. `Customer ID` = customer_info. `Customer ID`
GROUP BY
	work_records. `Customer ID`,
	customer_info. `Name`
ORDER BY
	COUNT(DISTINCT (work_records. `Employee ID`))
	DESC
	
-- What's the strongest customer-employee relationship by number of hours?
SELECT
	work_records. `Customer ID` AS customerID,
	customer_info.`Name` AS customerName,
	work_records. `Employee ID` AS employeeID,
	employee_info.`Full Name` AS employeeName,
	sum(work_records. `No. Hrs`) AS totHrs
FROM
	work_records
	INNER JOIN customer_info
		ON work_records.`Customer ID`=customer_info.`Customer ID`
	INNER JOIN employee_info
		ON work_records.`Employee ID`=employee_info.`Employee ID`
GROUP BY
	customerID,
	customerName,
	employeeID,
	employeeName
ORDER BY
	sum(work_records. `No. Hrs`)
	DESC