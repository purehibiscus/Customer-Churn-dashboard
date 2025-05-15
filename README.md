# Customer-Churn Analysis using MySQL and visualization in Power BI
The purpose of this project is to analyze churn and provide recommendations to reduce customers exiting on sales or products without completing transaction 

Analyzing Customer Churn Rate

Dashboard file download link: https://drive.google.com/file/d/1P-9T0kBLClYw3nkCCy1-l2hMupHIwESO/view?usp=sharing

Title: Understanding Customer Churn: A data-driven approach

Introduction:
As an E-commerce company, understanding Customer churn rate is of essence for understanding Customer behavior, tracking the specific event that lead to Customers churning off sales, withdrawing from sale finalization, abandonment of carts or leaving company site or app without completing a purchase. The analysis is intended to help drive sales, boost customer satisfaction rate and cut off churn to lower rate. In this story, we'll analyze Customer churn data to identify trends, patterns, and insights that can inform business decisions.

Data Preparation:

Data Source: Kaggle Public datasets

About Dataset
The dataset consist of 10,000 customer churn records including variables such as:

- Customer Demographics (age, gender, location, Surname)
- Purchase details (product number, Credit Score, Satisfaction Score, Balance, Tenure, Has Credit Card, Complain)
- Customer churn rate (exited)

Data Update Frequency: Annually.
The dataset consist of 1 csv file containing 18 columns and 10K records. 

Column Descriptions:

Row Number —corresponds to the record (row) number and has no effect on the output.
Customer Id —contains random values and has no effect on customer leaving the company.
Surname —the surname of a customer has no impact on their decision to leave the company.
Credit Score —can have an effect on customer churn, since a customer with a higher credit score is less likely to leave the company.
Geography —a customer’s location can affect their decision to leave the company.
Gender —it’s interesting to explore whether gender plays a role in a customer leaving the company.
Age —this is certainly relevant, since older customers are less likely to leave their company than younger ones.
Tenure —refers to the number of years that the customer has been a client of the bank. Normally, older clients are more loyal and less likely to leave a company.
Balance —also a very good indicator of customer churn, as people with a higher balance in their accounts are less likely to leave the bank compared to those with lower balances.
Num Of Products —refers to the number of products that a customer has purchased through the company.
Has Credit Card —denotes whether or not a customer has a credit card. This column is also relevant, since people with a credit card are less likely to leave the company.
Is Active Member —active customers are less likely to leave the company.
Estimated Salary —as with balance, people with lower salaries are more likely to leave the company compared to those with higher salaries.
Exited —whether or not the customer left the company.
Complain —customer has complaint or not.
Satisfaction Score —Score provided by the customer for their complaint resolution.
Card Type —type of card hold by the customer.

Data Profiling, Governance and Validation:

I. Data Profiling:
 
i. Numerical columns: Data distribution and Column Statistics, checks for Minimum, Maximum, Average, Count, and Standard deviation of each numerical columns, values for all numerical columns, Checks for Unique values, Error or Empty cells, Distinct values and Value distribution were done with Microsoft Power BI Power Query's Data Preview tool from the View tab. Column quality is 100% complete and no duplicate in key fields.

ii. Categorical Columns: Unique and Distinct are checked to ensure there is no whitespaces, misspelt words, trailing spaces. Column statistics was viewed to ensure proper data distribution, this helped in ensuring there is no anomalies, outliers or any record out of context.

Data Import to MySQL workbench Import wizard as a csv file.
RowID, CustomerID, Surname fields are dropped for PII.

-- Dropping columns
ALTER TABLE `churn`.`customer churn_modelling`
DROP COLUMN RowNumber,
DROP COLUMN CustomerID,
DROP COLUMN Surname;

Data Cleaning using MySQL workbench. All research questions are analyzed with MySQL dialect and a table is created to store the result which is saved as table.

--1. Calculating the percentage(%) of Customers who have churned

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






KPIs and metrics: 


--1. Total Employees

SELECT COUNT(CreditScore)
FROM `churn`.`customer churn_modelling`;


--2. Distribution of Employees by Geography(Country)

SELECT COUNT(Geography) as allEmployees,
	Geography as Country
FROM `churn`.`customer churn_modelling`
GROUP BY Geography;


--3. 

SELECT AVG(EstimatedSalary) as Salary,
	COUNT(EstimatedSalary) as totalEmployees,
    Geography as Country
FROM `churn`.`customer churn_modelling`
GROUP BY Geography;

--4.

SELECT AVG(EstimatedSalary) as AVGSalary
FROM `churn`.`customer churn_modelling`;

--5.

SELECT COUNT(Exited) as total_churn
FROM `churn`.`customer churn_modelling`
WHERE Exited = 1;

--6.

SELECT COUNT(IsActiveMember) as total_active_members
FROM `churn`.`customer churn_modelling`
WHERE IsActiveMember = 1;

--7.

SELECT COUNT(NumOfProducts) as totalRetention
FROM `churn`.`customer churn_modelling`
WHERE NumOfProducts > 1;

--8.

SELECT COUNT(HasCrCard) as CustomersWithCRcard
FROM `churn`.`customer churn_modelling`
WHERE HasCrCard = 1;

9.

SELECT COUNT(Tenure) as totalCustomersBeenWithTHEbank
FROM `churn`.`customer churn_modelling`
WHERE Tenure > 1;

10. Total

SELECT COUNT(tenure) as totalTenure,
		tenure
FROM `churn`.`customer churn_modelling`
group by tenure;



Data Modeling, Visualization and Reports:

Data Modeling:

I import all the tables through the SQL ODBC connection to MySQL database via the Power BI data import tool
After importing the tables from the MySQL database via the MS Power BI data import wizard, I navigated to the "Model view" and created all connections needed to integrate the tables for seamless and optimized visualization. Most of the connections is through the "churn rate" field as most of the tables have the field in it.



Charts and Visualizations:
 
1. Stacked Bar chart: Churn rate by Location
2. Pie chart: Distributions of credit scores of customers by Churn and Retention rates.
3. Stacked Column chart: Credit Score comparison by Churn status
4. Stacked Bar chart: Churn rate by Product Number
5. Pie chart: Distribution of churn by gender
6. Donut chart: Distribution of churn by Member status
7. Stacked Column chart: Estimated Salary Total and Average Churn by Status
8. Heatmap: Distribution of churn by Age group
9. Stacked Column chart: Total Account Balance  and Average Churn by Balance Group


KPIs:
1. Total customers(K)
2. Average Churn Rate(%)
3. Average Tenure(%)
4. Total Active Members(K)
5. Average Credit Score(%)
6. Overall Average Estimated Salary($)
7. Overall Average Balance($)
8. Count of Customers with Credit Card(K)

Insights:
1. Customers with 3 and above number of Products have higher churn rates which is in comparison with their Credit score.
2. There is a positive correlation between Average Churn Rate and Customers that are >= 36 years of Age. This means Customers that are older are most likely to churn sales or products.
3. Customers with 18 to 35 years of Age having membership status (Yes) are more likely to repeat purchases with 79% Retention Rate. 
 

Recommendations:
1. Focusing Sales on Customers with < 2 products and less Credit score would most likely turn out to be successful
2. Target Customers aged 18-35 with Personalized marketing campaigns. 
3. Implement loyalty programs to incentive repeat purchases

Conclusions:
By analyzing Customer churn, we've discovered key trends and patterns that can help in addressing high churn rates that can help inform Business decisions. By focusing on Customers with less and products and credit score, having low balance, implementing loyalty programs, and targeting specific Customer segments, we can drive sales, improve customer satisfaction and reduce churn from customers
