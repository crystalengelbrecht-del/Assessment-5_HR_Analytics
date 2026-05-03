# Assessment 5 - Telling the Story in Power BI
## HR Analytics Report

---

## Project Overview

This project builds an executive-ready Power BI report using the IBM HR Analytics dataset.
The data has been split from a flat table into a star schema with one central fact table
and five dimension tables.

**Key findings:**
- 1,470 employees · 237 attritions · 16.1% attrition rate
- Employees earning under R5,000/month account for 54% of all attritions (129 of 237)
- Laboratory Technicians (59), Sales Executives (54) and Research Scientists (44) are the highest-risk roles
- Attrition peaks sharply in the first 2 years of employment

---

## Folder Structure

```
Assessment5_HR_Analytics/
├── data/
│   ├── raw/
│   │   └── HR_Analytics.csv          ← original flat file (1,470 rows)
│   └── star_schema/
│       ├── Fact_Employee.csv         ← central fact table (1,470 rows)
│       ├── Dim_Department.csv        ← 3 departments
│       ├── Dim_Education.csv         ← 6 education fields
│       ├── Dim_JobRole.csv           ← 9 job roles
│       ├── Dim_AgeGroup.csv          ← 5 age bands
│       └── Dim_SalarySlab.csv        ← 4 salary bands (with SalaryOrder column)
├── docs/
│   ├── Storyboard.pdf
│   ├── Narrative.pdf
│   ├── Accessibility_Checklist.pdf
│   └── Prompt_Reflection_Log.pdf
├── sql/
│   └── star_schema.sql               ← DDL and relationship documentation
├── src/
│   ├── build_star_schema.py          ← Python script that creates the star schema
│   └── HR_Analytics_Report.pbix     ← Power BI report file
├── screenshots/                      ← screenshots of all 3 pages and Model View
└── README.md
```

---

## How to Run From Scratch

### Step 1 - Recreate the star schema CSV files

Requires Python 3 with pandas installed.

```bash
pip install pandas
python src/build_star_schema.py
```

This reads `data/raw/HR_Analytics.csv` and writes 6 CSV files to `data/star_schema/`.

---

### Step 2 - Open the Power BI report

Open `src/HR_Analytics_Report.pbix` in Power BI Desktop (no sign-in required for local use).

---

### Step 3 - Star schema relationships in Power BI

The following 5 relationships are configured in Power BI Model View:

| From (dimension)               | To (fact table)                   | Cardinality  |
|-------------------------------|-----------------------------------|--------------|
| Dim_Department[DepartmentID]  | Fact_Employee[DepartmentID]       | One → many   |
| Dim_Education[EducationFieldID]| Fact_Employee[EducationFieldID]  | One → many   |
| Dim_JobRole[JobRoleID]        | Fact_Employee[JobRoleID]          | One → many   |
| Dim_AgeGroup[AgeGroupID]      | Fact_Employee[AgeGroupID]         | One → many   |
| Dim_SalarySlab[SalarySlabID]  | Fact_Employee[SalarySlabID]       | One → many   |

All cross-filter directions are set to Single.

---

### Step 4 - DAX Measures (all stored in Fact_Employee)

```dax
Total Employees = COUNTROWS(Fact_Employee)
Attrition Count = COUNTROWS(FILTER(Fact_Employee, Fact_Employee[Attrition] = "Yes"))
Attrition Rate = DIVIDE([Attrition Count], [Total Employees])
Avg Age = AVERAGE(Fact_Employee[Age])
Avg Monthly Income = AVERAGE(Fact_Employee[MonthlyIncome])
Avg Years at Company = AVERAGE(Fact_Employee[YearsAtCompany])
```

---

### Step 5 - Report Pages

**Page 1 - Executive Summary**
5 KPI cards · Donut chart (education field) · Column chart (age group) · Bar chart (salary band) · Department slicer

**Page 2 - Department Drill-Down**
Bar chart (job role) · Matrix (role × satisfaction) · Treemap (gender) · Area chart (tenure) · Slicers

**Page 3 - Tenure & Salary Analysis**
Scatter chart (income vs tenure) · Bar chart (avg salary by dept) · KPI cards

---

## SQL Reference

See `sql/star_schema.sql` for full DDL and relationship documentation.
