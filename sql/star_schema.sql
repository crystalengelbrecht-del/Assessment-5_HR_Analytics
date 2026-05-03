-- ============================================================
-- star_schema.sql
-- HR Analytics Star Schema — DDL and relationship definitions
-- ============================================================
-- This SQL describes the data model used in the Power BI report.
-- It is provided for documentation and portability purposes.
-- The actual tables are loaded into Power BI from the CSV files
-- in data/star_schema/.
-- ============================================================

-- ── Dimension Tables ─────────────────────────────────────────

CREATE TABLE Dim_Department (
    DepartmentID   INTEGER PRIMARY KEY,
    Department     TEXT NOT NULL
);
-- Values: 1=Human Resources, 2=Research & Development, 3=Sales

CREATE TABLE Dim_Education (
    EducationFieldID  INTEGER PRIMARY KEY,
    EducationField    TEXT NOT NULL
);
-- Values: Life Sciences, Medical, Marketing, Technical Degree,
--         Human Resources, Other

CREATE TABLE Dim_JobRole (
    JobRoleID  INTEGER PRIMARY KEY,
    JobRole    TEXT NOT NULL
);
-- Values: Sales Executive, Research Scientist, Laboratory Technician,
--         Manufacturing Director, Healthcare Representative,
--         Manager, Sales Representative, Research Director,
--         Human Resources

CREATE TABLE Dim_AgeGroup (
    AgeGroupID  INTEGER PRIMARY KEY,
    AgeGroup    TEXT NOT NULL
);
-- Values: 18-25, 26-35, 36-45, 46-55, 55+

CREATE TABLE Dim_SalarySlab (
    SalarySlabID  INTEGER PRIMARY KEY,
    SalarySlab    TEXT NOT NULL
);
-- Values: Upto 5k, 5k-10k, 10k-15k, 15k+

-- ── Central Fact Table ────────────────────────────────────────

CREATE TABLE Fact_Employee (
    EmpID                INTEGER PRIMARY KEY,
    Age                  INTEGER,
    Attrition            TEXT,         -- 'Yes' or 'No'
    Education            INTEGER,      -- 1 (Below College) to 5 (Doctor)
    Gender               TEXT,         -- 'Male' or 'Female'
    JobSatisfaction      INTEGER,      -- 1 (Low) to 4 (Very High)
    MonthlyIncome        INTEGER,
    NumCompaniesWorked   INTEGER,
    OverTime             TEXT,         -- 'Yes' or 'No'
    TotalWorkingYears    INTEGER,
    YearsAtCompany       INTEGER,
    YearsInCurrentRole   INTEGER,
    DistanceFromHome     INTEGER,
    -- Foreign keys to dimension tables
    DepartmentID         INTEGER REFERENCES Dim_Department(DepartmentID),
    EducationFieldID     INTEGER REFERENCES Dim_Education(EducationFieldID),
    JobRoleID            INTEGER REFERENCES Dim_JobRole(JobRoleID),
    AgeGroupID           INTEGER REFERENCES Dim_AgeGroup(AgeGroupID),
    SalarySlabID         INTEGER REFERENCES Dim_SalarySlab(SalarySlabID)
);

-- ── Relationships summary ─────────────────────────────────────
-- All relationships are one-to-many from dimension to fact.
-- In Power BI Model View, create these relationships:
--
--   Dim_Department.DepartmentID    --> Fact_Employee.DepartmentID    (1:many)
--   Dim_Education.EducationFieldID --> Fact_Employee.EducationFieldID (1:many)
--   Dim_JobRole.JobRoleID          --> Fact_Employee.JobRoleID        (1:many)
--   Dim_AgeGroup.AgeGroupID        --> Fact_Employee.AgeGroupID       (1:many)
--   Dim_SalarySlab.SalarySlabID    --> Fact_Employee.SalarySlabID     (1:many)
--
-- Filter direction: Single (from dimension to fact)
-- Cross-filter direction: Single
