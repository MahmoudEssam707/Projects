# Introduction to Database

## Schema

### Entities

- **Person (SSNpk, PName, PNationality, Pgender, PBdate, Pstreet, Phone, PGov)** (1,2,3) NF achieved
- **Authentication (Usernamepk, Password)** (1,2) NF achieved, 3 No, so will divide it
- **User_SSn (SSNfk, Usernamepk)** (1,2,3) NF achieved
- **Authentication (Usernamepk, Password)** (1,2,3) NF achieved
- **Student (SSNfk, CGPA, AIDfk, TIDfk)** (1,2,3) NF achieved
- **Doctor (SSNfk)** (1,2,3) NF achieved
- **TA (SSNfk)** (1,2,3) NF achieved
- **Department (DIDpk, Dname)** (1,2,3) NF achieved
- **Absence_Report (AIDpk, SSNfk, Lecture, Section, Count)** (1,2,3) NF achieved
- **Course (CrsCodepk, CrsName, Credit)** (1,2,3) NF achieved
- **Exams (Date, Time, CrsCodefk, CrsNamefk)** (1,2,3) NF achieved
- **Training (TIDfk, SSN, PName, TName, TGrade)** (1,2,3) NF achieved

### Relations

- **Works_For (DIDfk, SSNfk)** (1,2,3) NF achieved
- **Enroll (SSNfk, CrsCodefk)** (1,2,3) NF achieved
- **Instruct (SSNfk, CrsCodefk)** (1,2,3) NF achieved

## Creation of tables to Establish the Database, and make queries as much you want

### Teaching Staff

- Inserted data for teaching staff in the Person table, User_SSn table, and Authentication table.
- Created an Instruct table for teaching staff.

### Student Details

- Inserted data for students in the Person table, User_SSn table, Authentication table, Training table, Absence_Report table, and Student table.
