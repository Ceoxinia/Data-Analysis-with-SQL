CREATE TABLE EmployeeDetails (
    emp_no INT PRIMARY KEY,
    gender NVARCHAR(10),
    marital_status NVARCHAR(10),
    age_band NVARCHAR(20),
    age INT,
    department NVARCHAR(50),
    education NVARCHAR(50),
    education_field NVARCHAR(50),
    job_role NVARCHAR(50),
    business_travel NVARCHAR(20),
    employee_count INT,
    attrition NVARCHAR(5),
    attrition_label NVARCHAR(20),
    job_satisfaction INT,
    active_employee BIT
);

BULK INSERT EmployeeDetails
FROM 'C:\music store data\employee_trends.csv'
WITH (
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    KEEPNULLS,
    CODEPAGE = '65001'
);

Select * From EmployeeDetails;




-- 8. Find the age band with the highest attrition rate among employees with a specific education level
WITH EducationAttrition AS (
    SELECT education, age_band, 
           CAST(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS attrition_rate
    FROM EmployeeDetails
    GROUP BY education, age_band
)
SELECT TOP 1 education, age_band, attrition_rate
FROM EducationAttrition
ORDER BY attrition_rate DESC;




-- 9. Find the education level with the highest average job satisfaction among employees who travel frequently
SELECT TOP 3 education, AVG(job_satisfaction) AS average_satisfaction
FROM EmployeeDetails
WHERE business_travel = 'Travel_Frequently'
GROUP BY education
ORDER BY average_satisfaction DESC;

-- 10. Identify the age band with the highest average job satisfaction among married employees
SELECT TOP age_band, AVG(job_satisfaction) AS average_satisfaction
FROM EmployeeDetails
WHERE marital_status = 'Married'
GROUP BY age_band
ORDER BY average_satisfaction DESC;


