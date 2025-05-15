-- Dropping columns
ALTER TABLE `churn`.`customer churn_modelling`
DROP COLUMN RowNumber,
DROP COLUMN CustomerID,
DROP COLUMN Surname;

-- Calculating the percentage(%) of Customers who have churned
SELECT AVG(Exited) as churn_rate,
	COUNT(Exited) totalChurn
FROM `churn`.`customer churn_modelling`
WHERE Exited = 1;

CREATE TABLE ChurnedCustomers (
churn_rate FLOAT,
total_churn int
);

INSERT INTO churnedCustomers (churn_rate, total_churn)
SELECT AVG(Exited) as churn_rate,
	COUNT(Exited) totalChurn
FROM `churn`.`customer churn_modelling`
WHERE Exited = 1;

-- 2. How does Geography(location) affect churn
SELECT Geography as location,
	avg(Exited) as churn_rate
FROM `churn`.`customer churn_modelling`
GROUP BY Geography;

CREATE TABLE churnedLocation (
location VARCHAR(255),
churn_rate FLOAT
);

INSERT INTO churnedLocation (location, churn_rate)
SELECT Geography as location,
	avg(Exited) as churn_rate
FROM `churn`.`customer churn_modelling`
GROUP BY Geography;

SELECT CreditScore as credit_score,
	AVG(Exited) as churn_rate
FROM `churn`.`customer churn_modelling`
GROUP BY CreditScore;

CREATE TABLE churnRateCreditScore (
credit_score VARCHAR(255),
churn_rate float
);

INSERT INTO churnRateCreditScore (credit_score, churn_rate)
SELECT CreditScore as credit_score,
	AVG(Exited) as churn_rate
FROM `churn`.`customer churn_modelling`
GROUP BY CreditScore;

SELECT MAX(CreditScore) as max,
	min(CreditScore) as min,
    AVG(CreditScore) as mean
FROM `churn`.`customer churn_modelling`;

CREATE TABLE creditScoreDist (
max FLOAT,
min FLOAT,
mean fLOAT
);

INSERT INTO creditScoreDist (max, min, mean)
SELECT MAX(CreditScore) as max,
	min(CreditScore) as min,
    AVG(CreditScore) as mean
FROM `churn`.`customer churn_modelling`;

-- 3. Analyzing the distribution of credit scores for customers who have exited(churned) vs. those who haven't
SELECT 
    CreditCategory, 
    AVG(Exited) AS churn_rate
FROM (
    SELECT 
        CreditScore,
        CASE
            WHEN CreditScore BETWEEN 350 AND 450 THEN 'Lowclass'
            WHEN CreditScore BETWEEN 451 AND 600 THEN 'MiddleClass'
            ELSE 'HighClass'
        END AS CreditCategory,
        Exited
    FROM `churn`.`customer churn_modelling`
) AS CreditClassification
GROUP BY CreditCategory;

CREATE TABLE creditCategory (
CreditCategory VARCHAR(255),
churn_rate FLOAT
);

INSERT INTO creditCategory (CreditCategory, churn_rate)
SELECT 
    CreditCategory, 
    AVG(Exited) AS churn_rate
FROM (
    SELECT 
        CreditScore,
        CASE
            WHEN CreditScore BETWEEN 350 AND 450 THEN 'Lowclass'
            WHEN CreditScore BETWEEN 451 AND 600 THEN 'MiddleClass'
            ELSE 'HighClass'
        END AS CreditCategory,
        Exited
    FROM `churn`.`customer churn_modelling`
) AS CreditClassification
GROUP BY CreditCategory;

-- 4. Comparing churn rates for active members (IsActiveMember = 1) 
SELECT AVG(Exited) as churn_rate,
	IsActiveMember as active_members,
    COUNT(IsActiveMember) as total_Active_Members
FROM `churn`.`customer churn_modelling`
WHERE IsActiveMember = 1
GROUP BY IsActiveMember;

CREATE TABLE churnedActiveMembers (
churn_rate FLOAT,
active_members INT,
total_Active_Members INT
);

INSERT INTO churnedActiveMembers (churn_rate, active_members, total_Active_Members)
SELECT AVG(Exited) as churn_rate,
	IsActiveMember as active_members,
    COUNT(IsActiveMember) as total_Active_Members
FROM `churn`.`customer churn_modelling`
WHERE IsActiveMember = 1
GROUP BY IsActiveMember;

-- 5. Compare churn rates across Gender(males and females)
SELECT Gender,
	AVG(Exited) as churn_rates
FROM `churn`.`customer churn_modelling`
GROUP BY Gender;

CREATE TABLE genderDist (
Gender VARCHAR(255),
churn_rate float
);

INSERT INTO genderDist (Gender, churn_rate)
SELECT Gender,
	AVG(Exited) as churn_rates
FROM `churn`.`customer churn_modelling`
GROUP BY Gender;

-- Looking at the distribution of Customer Age
SELECT MIN(Age) as minAge,
	MAX(Age) as maxAge,
    AVG(Age) as avgAge
FROM `churn`.`customer churn_modelling`;

-- 6. Comparing churn rates across Age groups
SELECT Age,
	CASE
		WHEN Age BETWEEN 18 AND 35 THEN 'A'
        WHEN Age BETWEEN 36 AND 65 THEN 'B'
        ELSE 'C'
        END AS AgeGroup
FROM `churn`.`customer churn_modelling`;

CREATE TABLE AgeGroup (
Age INT,
AgeGroup VARCHAR(255)
);

INSERT INTO AgeGroup (Age, AgeGroup)
SELECT Age,
	CASE
		WHEN Age BETWEEN 18 AND 35 THEN 'A'
        WHEN Age BETWEEN 36 AND 65 THEN 'B'
        ELSE 'C'
        END AS AgeGroup
FROM `churn`.`customer churn_modelling`;

-- 7. Analyzing the relationship between Customer Age and churn rate
SELECT AgeGroup,
	AVG(Exited) as churn_rate	
FROM (
	SELECT
		Age,
		CASE
			WHEN Age BETWEEN 18 AND 40 THEN 'Adult'
			WHEN Age BETWEEN 41 AND 65 THEN 'Old'
			ELSE 'Very Old'
			END AS AgeGroup,
            Exited
FROM `churn`.`customer churn_modelling`
) as AgeClassification
GROUP BY AgeGroup;

CREATE TABLE churnedAgeGroup (
AgeGroup VARCHAR(255),
churn_rate FLOAT
);

INSERT INTO churnedAgeGroup (AgeGroup, churn_rate)
SELECT AgeGroup,
	AVG(Exited) as churn_rate	
FROM (
	SELECT
		Age,
		CASE
			WHEN Age BETWEEN 18 AND 40 THEN 'Adult'
			WHEN Age BETWEEN 41 AND 65 THEN 'Old'
			ELSE 'Very Old'
			END AS AgeGroup,
            Exited
FROM `churn`.`customer churn_modelling`
) as AgeClassification
GROUP BY AgeGroup;

-- Having a visual distribution of Customer Balance
SELECT MIN(Balance) as minBal,
	MAX(Balance) as maxBal,
    AVG(Balance) as avgBal
FROM `churn`.`customer churn_modelling`;

-- 8. Analyzing the relationship between balance and churn rate.
SELECT BalanceGroup,
	AVG(Exited) as churn_rate
FROM (
		SELECT
			Balance,
				CASE
					WHEN Balance BETWEEN 0 AND 75000 THEN 'LowBalance'
                    WHEN Balance BETWEEN 75001 AND 150000 THEN 'MiddleBalance'
                    ELSE 'HighBalance'
                    END AS BalanceGroup,
                    Exited
FROM `churn`.`customer churn_modelling`
) as IncomeClassification
GROUP BY BalanceGroup;

CREATE TABLE Balance_churn (
BalanceGroup VARCHAR(255),
churn_rate float
);

INSERT INTO Balance_churn (BalanceGroup, churn_rate)
SELECT BalanceGroup,
	AVG(Exited) as churn_rate
FROM (
		SELECT
			Balance,
				CASE
					WHEN Balance BETWEEN 0 AND 75000 THEN 'LowBalance'
                    WHEN Balance BETWEEN 75001 AND 150000 THEN 'MiddleBalance'
                    ELSE 'HighBalance'
                    END AS BalanceGroup,
                    Exited
FROM `churn`.`customer churn_modelling`
) as IncomeClassification
GROUP BY BalanceGroup;


-- 9. Analyzing the distribution of estimated salaries for customers who have churned and those who have not
SELECT 
    AVG(CASE WHEN Exited = 1 THEN EstimatedSalary END) AS avgEstimatedSalaryChurned,
    AVG(CASE WHEN Exited = 0 THEN EstimatedSalary END) AS avgEstimatedSalaryUnchurned,
    AVG(Exited) AS churn_rate
FROM `churn`.`customer churn_modelling`;

CREATE TABLE EstSalaryChurn (
avgEstimatedSalaryChurned FLOAT,
avgEstimatedSalaryUnchurned FLOAT,
churn_rate float
);

INSERT INTO EstSalaryChurn (avgEstimatedSalaryChurned, avgEstimatedSalaryUnchurned, churn_rate)
SELECT 
    AVG(CASE WHEN Exited = 1 THEN EstimatedSalary END) AS avgEstimatedSalaryChurned,
    AVG(CASE WHEN Exited = 0 THEN EstimatedSalary END) AS avgEstimatedSalaryUnchurned,
    AVG(Exited) AS churn_rate
FROM `churn`.`customer churn_modelling`;

-- KPIs 
-- Total Employees
SELECT COUNT(CreditScore)
FROM `churn`.`customer churn_modelling`;

-- Distribution of Employees by Geography(Country)
SELECT COUNT(Geography) as allEmployees,
	Geography as Country
FROM `churn`.`customer churn_modelling`
GROUP BY Geography;

SELECT AVG(EstimatedSalary) as Salary,
	COUNT(EstimatedSalary) as totalEmployees,
    Geography as Country
FROM `churn`.`customer churn_modelling`
GROUP BY Geography;

SELECT AVG(EstimatedSalary) as AVGSalary
FROM `churn`.`customer churn_modelling`;

SELECT COUNT(Exited) as total_churn
FROM `churn`.`customer churn_modelling`
WHERE Exited = 1;

SELECT COUNT(IsActiveMember) as total_active_members
FROM `churn`.`customer churn_modelling`
WHERE IsActiveMember = 1;

SELECT COUNT(NumOfProducts) as totalRetention
FROM `churn`.`customer churn_modelling`
WHERE NumOfProducts > 1;

SELECT COUNT(HasCrCard) as CustomersWithCRcard
FROM `churn`.`customer churn_modelling`
WHERE HasCrCard = 1;

SELECT COUNT(Tenure) as totalCustomersBeenWithTHEbank
FROM `churn`.`customer churn_modelling`
WHERE Tenure > 1;

select count(tenure) as totalcust,
		tenure
FROM `churn`.`customer churn_modelling`
group by tenure;








