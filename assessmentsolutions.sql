Step 1:
Creating the Database Model
Understanding the Requirements:
Three tables:
oTable 1: Contains columns from the orange bubble (First Name, Middle Name, Last Name, Email, Gender, Personal Pronoun, Capacity, Start Date).
oTable 2: Contains columns from the orange bubble (Camp Title, Price).
oTable 3: Contains columns to track the number of times a teenager visited the camp (Teenager ID, Camp ID, Visit Date).
Table 3: Needs to track the number of visits for a specific teenager (Lakshmi) over the last 3 years.
Database Model:
SQL
CREATE TABLE Teenagers (
    TeenagerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Gender CHAR(1),
    PersonalPronoun VARCHAR(10),
    Capacity INT,
    StartDate DATE
);

CREATE TABLE Camps (
    CampID INT PRIMARY KEY IDENTITY(1,1),
    CampTitle VARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE TeenagerCampVisits (
    TeenagerID INT FOREIGN KEY REFERENCES Teenagers(TeenagerID),
    CampID INT FOREIGN KEY REFERENCES Camps(CampID),
    VisitDate DATE
);
Step2:
Populating the Teenagers Table with Random Data
SQL
DECLARE @TotalPeople INT = 5000;
DECLARE @GirlsPercentage DECIMAL(5,2) = 0.65;
DECLARE @BoysPercentage DECIMAL(5,2) = 0.35;
DECLARE @AgeGroup1Percentage DECIMAL(5,2) = 0.18;
DECLARE @AgeGroup2Percentage DECIMAL(5,2) = 0.27;
DECLARE @AgeGroup3Percentage DECIMAL(5,2) = 0.20;

-- Create a temporary table to store random names
CREATE TABLE #RandomNames (
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);

-- Populate the temporary table with random names
INSERT INTO #RandomNames (FirstName, LastName)
SELECT FirstName, LastName
FROM (VALUES ('Alice', 'Smith'), ('Bob', 'Johnson'), ('Charlie', 'Brown'), ('David', 'Lee'), ('Emily', 'Jones')) AS Names
ORDER BY NEWID();

-- Insert random teenagers into the Teenagers table
INSERT INTO Teenagers (FirstName, MiddleName, LastName, Email, Gender, PersonalPronoun, Capacity, StartDate)
SELECT
    rn.FirstName,
    CASE WHEN RAND() < 0.5 THEN rn.FirstName ELSE NULL END AS MiddleName,
    rn.LastName,
    CONCAT(LOWER(rn.FirstName), '.', LOWER(rn.LastName), '@example.com'),
    CASE WHEN RAND() < @GirlsPercentage THEN 'F' ELSE 'M' END,
    CASE WHEN RAND() < 0.5 THEN 'he/him' ELSE 'she/her' END,
    RAND() * 100 + 1,
    DATEADD(YEAR, -RAND() * 18, GETDATE())
FROM #RandomNames rn
CROSS JOIN (VALUES (1), (2), ..., (@TotalPeople)) AS Numbers
WHERE RAND() < CASE
    WHEN RAND() < @AgeGroup1Percentage THEN 1
    WHEN RAND() < @AgeGroup1Percentage + @AgeGroup2Percentage THEN 1
    WHEN RAND() < @AgeGroup1Percentage + @AgeGroup2Percentage + @AgeGroup3Percentage THEN 1
    ELSE 1 END;

DROP TABLE #RandomNames;

