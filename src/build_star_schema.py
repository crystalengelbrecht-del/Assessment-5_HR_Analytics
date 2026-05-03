"""
build_star_schema.py
--------------------
Splits the flat HR_Analytics table into a star schema with:
  Fact_Employee     - central fact table (one row per employee)
  Dim_Department    - department dimension
  Dim_Education     - education field dimension
  Dim_JobRole       - job role dimension
  Dim_AgeGroup      - age group dimension
  Dim_SalarySlab    - salary slab dimension

Run from the project root folder:
    python src/build_star_schema.py

Output goes to: data/star_schema/
"""

import pandas as pd
import os

INPUT  = os.path.join("data", "raw", "HR_Analytics.csv")
OUTPUT = os.path.join("data", "star_schema")
os.makedirs(OUTPUT, exist_ok=True)

print(f"Loading {INPUT} ...")
df = pd.read_csv(INPUT)
print(f"  {len(df):,} rows loaded, {len(df.columns)} columns")

def make_dim(df, col, id_col):
    dim = df[[col]].drop_duplicates().reset_index(drop=True)
    dim.insert(0, id_col, range(1, len(dim)+1))
    return dim

dim_dept = make_dim(df, "Department",    "DepartmentID")
dim_edu  = make_dim(df, "EducationField","EducationFieldID")
dim_role = make_dim(df, "JobRole",       "JobRoleID")
dim_age  = make_dim(df, "AgeGroup",      "AgeGroupID")
dim_sal  = make_dim(df, "SalarySlab",    "SalarySlabID")

fact = df.copy()
fact = fact.merge(dim_dept, on="Department").drop(columns=["Department"])
fact = fact.merge(dim_edu,  on="EducationField").drop(columns=["EducationField"])
fact = fact.merge(dim_role, on="JobRole").drop(columns=["JobRole"])
fact = fact.merge(dim_age,  on="AgeGroup").drop(columns=["AgeGroup"])
fact = fact.merge(dim_sal,  on="SalarySlab").drop(columns=["SalarySlab"])

dim_dept.to_csv(os.path.join(OUTPUT, "Dim_Department.csv"),  index=False)
dim_edu.to_csv( os.path.join(OUTPUT, "Dim_Education.csv"),   index=False)
dim_role.to_csv(os.path.join(OUTPUT, "Dim_JobRole.csv"),     index=False)
dim_age.to_csv( os.path.join(OUTPUT, "Dim_AgeGroup.csv"),    index=False)
dim_sal.to_csv( os.path.join(OUTPUT, "Dim_SalarySlab.csv"),  index=False)
fact.to_csv(    os.path.join(OUTPUT, "Fact_Employee.csv"),   index=False)

print("\nStar schema tables saved to data/star_schema/:")
for t in ["Dim_Department","Dim_Education","Dim_JobRole","Dim_AgeGroup","Dim_SalarySlab","Fact_Employee"]:
    path = os.path.join(OUTPUT, t+".csv")
    rows = len(pd.read_csv(path))
    print(f"  {t}.csv  ({rows} rows)")
print("\nDone. Now import all 6 CSVs into Power BI Desktop.")
