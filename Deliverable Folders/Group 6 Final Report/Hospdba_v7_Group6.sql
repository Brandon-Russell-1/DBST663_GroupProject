/*Set timing to on to see query times*/
SET TIMING ON

/*Drop all tables*/
DROP TABLE Prescriptions;
DROP TABLE Visits;
DROP TABLE Provider;
DROP TABLE Patients;
DROP TABLE Hospitals;
DROP TABLE Medications;

/*Drop Link*/
DROP DATABASE LINK Linker_1_2;

/*Drop Sequence*/

DROP SEQUENCE Hospitals_Seq;
DROP SEQUENCE Visits_Seq;
DROP SEQUENCE Provider_Seq;
DROP SEQUENCE Medications_Seq;

/*Create all tables*/
CREATE TABLE Patients (
    Patient_ID NUMBER NOT NULL,
	First_Name VARCHAR(50) NOT NULL,
	Last_Name VARCHAR(50) NOT NULL,
	DOB DATE NOT NULL,
	Phone_Num VARCHAR(50) NOT NULL, 
	Gender VARCHAR(2) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	Zip_Code VARCHAR(15) NOT NULL,
	Database_Name VARCHAR(50) NOT NULL,
    CONSTRAINT    pk_patients PRIMARY KEY (Patient_ID)
);

CREATE TABLE Hospitals (
    Hospital_CCN_ID NUMBER NOT NULL,
    Phone_Num VARCHAR(50) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	Zip_Code VARCHAR(15) NOT NULL,
	CMS_Region VARCHAR(50) NOT NULL,
    CONSTRAINT pk_hospitals PRIMARY KEY (Hospital_CCN_ID)
);


CREATE TABLE Provider (
	Provider_ID NUMBER NOT NULL,
	Hospital_CCN_ID NUMBER NOT NULL,
	First_Name VARCHAR(50) NOT NULL,
	Last_Name VARCHAR(50) NOT NULL,
	Phone_Num VARCHAR(50) NOT NULL,
	Specialty VARCHAR(50) NOT NULL,
    CONSTRAINT pk_provider PRIMARY KEY (Provider_ID),
    CONSTRAINT fk_hospital_2 FOREIGN KEY (Hospital_CCN_ID)
        REFERENCES Hospitals
);

/*Patient_ID foreign key enforced with trigger below*/
CREATE TABLE Visits (
    Visit_ID NUMBER NOT NULL,
	Patient_ID NUMBER NOT NULL,
	Provider_ID NUMBER NOT NULL,
	Notes VARCHAR(50) NOT NULL,
	Purpose VARCHAR(50) NOT NULL,
	Hospital_CCN_ID NUMBER NOT NULL,
    Visit_Date DATE NOT NULL,
    CONSTRAINT pk_visits PRIMARY KEY (Visit_ID),
    CONSTRAINT fk_provider FOREIGN KEY (Provider_ID)
        REFERENCES Provider,
    CONSTRAINT fk_hospital FOREIGN KEY (Hospital_CCN_ID)
        REFERENCES Hospitals
);

CREATE TABLE Medications (
	Medication_ID NUMBER NOT NULL,
	Name varchar(50) NOT NULL,
	Dose varchar(50) NOT NULL,
    CONSTRAINT pk_medications PRIMARY KEY (Medication_ID)
);

CREATE TABLE Prescriptions (
	Visit_ID NUMBER NOT NULL,
	Medication_ID NUMBER NOT NULL, 
	Provider_ID NUMBER NOT NULL,
	Qty INT NOT NULL,
	Prescription_Num INT NOT NULL,
	Pharmacy_Num INT NOT NULL,
    CONSTRAINT fk_medication FOREIGN KEY (Medication_ID)
        REFERENCES Medications,
    CONSTRAINT fk_visit FOREIGN KEY (Visit_ID)
        REFERENCES Visits,
    CONSTRAINT fk_provider_2 FOREIGN KEY (Provider_ID)
        REFERENCES Provider,
    CONSTRAINT pk_prescriptions PRIMARY KEY (Visit_ID, Medication_ID, Provider_ID)
);


/*Create Database Link*/

CREATE DATABASE LINK Linker_1_2 CONNECT TO system IDENTIFIED BY "0racl3Adm1n" USING 'dbst663b';

/*Test Database link*/
SELECT * FROM DUAL@Linker_1_2;
/* Create indexes on foreign keys*/


CREATE INDEX fk_provider on Visits(Provider_ID);
CREATE INDEX fk_hospital on Visits(Hospital_CCN_ID);
CREATE INDEX fk_hospital_2 on Provider(Hospital_CCN_ID);
CREATE INDEX fk_medication on Prescriptions(Medication_ID);
CREATE INDEX fk_visit ON Prescriptions (Visit_ID);
CREATE INDEX fk_provider_2 ON Prescriptions (Provider_ID);


/* Create sequence*/
/*There is no sequence for the Patients table, you cannot use a local object for
a remote database.*/
 
CREATE SEQUENCE Hospitals_Seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE Visits_Seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE Provider_Seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE Medications_Seq
  START WITH 1
  INCREMENT BY 1;

/*Insert Test Data*/

/*Patients Table*/
INSERT INTO Patients (Patient_ID,First_Name,Last_Name,DOB,Phone_Num,Gender,Address,Zip_Code,Database_Name) 
VALUES ( 1,'John','Fedric','12-FEB-1980','111-143-1242','M','23 block','14500','hospdba');

INSERT INTO Patients (Patient_ID,First_Name,Last_Name,DOB,Phone_Num,Gender,Address,Zip_Code,Database_Name) 
VALUES ( 2,	'Aaron',	'Hank',	'04-APR-1994',	'111-144-0423',	'M',	'99 city',	'78000', 'hospdba');

INSERT INTO Patients (Patient_ID,First_Name,Last_Name,DOB,Phone_Num,Gender,Address,Zip_Code,Database_Name) 
VALUES ( 3,	'Abbey',	'Edward',	'27-MAR-1998',	'111-924-0598',	'F',	'Main 2A',	'34200', 'hospdba');

INSERT INTO Patients (Patient_ID,First_Name,Last_Name,DOB,Phone_Num,Gender,Address,Zip_Code,Database_Name) 
VALUES ( 4,	'Abelson',	'Hall',	'28-JUL-1955',	'111-178-6290',	'F',	'13-B sid'	,'36600', 'hospdba');

/*Insert Data into linked database*/
INSERT INTO Patients@Linker_1_2 (Patient_ID,First_Name,Last_Name,DOB,Phone_Num,Gender,Address,Zip_Code,Database_Name) 
VALUES ( 5,	'Bob',	'Lee',	'12-JUN-2001',	'111-169-8399',	'M',	'Street 14',	'42000','hospdbb');

INSERT INTO Patients@Linker_1_2 (Patient_ID,First_Name,Last_Name,DOB,Phone_Num,Gender,Address,Zip_Code,Database_Name) 
VALUES ( 6,	'Dawane',	'Bravo',	'19-SEP-1990',	'111-359-0086',	'M',	'19 A city',	'65000','hospdbb');

INSERT INTO Patients@Linker_1_2 (Patient_ID,First_Name,Last_Name,DOB,Phone_Num,Gender,Address,Zip_Code,Database_Name) 
VALUES ( 7,	'Andrew',	'Stall',	'05-DEC-1998',	'342-508-2222',	'M',	'52 belon',	'77600','hospdbb');

INSERT INTO Patients@Linker_1_2 (Patient_ID,First_Name,Last_Name,DOB,Phone_Num,Gender,Address,Zip_Code,Database_Name) 
VALUES ( 8,	'Stella',	'Queen',	'14-JUL-1992',	'566-376-1111',	'F',	'Wagha 4',	'64500','hospdbb');


/*Hospitals Table*/
INSERT INTO Hospitals (Hospital_CCN_ID,Phone_Num,Address,Zip_Code,CMS_Region)
VALUES (Hospitals_Seq.NEXTVAL, '222-333-4444', '123 abc st.', '12345', '1'); 

INSERT INTO Hospitals (Hospital_CCN_ID,Phone_Num,Address,Zip_Code,CMS_Region)
VALUES (Hospitals_Seq.NEXTVAL, '111-555-7777', '254 green st.', '29456', '2'); 

INSERT INTO Hospitals (Hospital_CCN_ID,Phone_Num,Address,Zip_Code,CMS_Region)
VALUES (Hospitals_Seq.NEXTVAL, '345-678-1212', '789 blue st.', '31088', '3');

INSERT INTO Hospitals (Hospital_CCN_ID,Phone_Num,Address,Zip_Code,CMS_Region)
VALUES (Hospitals_Seq.NEXTVAL, '909-808-3459', '1002 red st.', '31771', '4'); 

/*Provider Table*/
INSERT INTO Provider (Provider_ID, Hospital_CCN_ID, First_Name, Last_Name, Phone_Num, Specialty)
VALUES (Provider_Seq.NEXTVAL, 1, 'Brandon', 'Russell', '678-435-1858', 'Lungs');

INSERT INTO Provider (Provider_ID, Hospital_CCN_ID, First_Name, Last_Name, Phone_Num, Specialty)
VALUES (Provider_Seq.NEXTVAL, 2, 'Daniela', 'Montero', '404-123-7890', 'Heart');

INSERT INTO Provider (Provider_ID, Hospital_CCN_ID, First_Name, Last_Name, Phone_Num, Specialty)
VALUES (Provider_Seq.NEXTVAL, 3, 'Patricia', 'Bargueno', '999-888-1698', 'Radiology');

INSERT INTO Provider (Provider_ID, Hospital_CCN_ID, First_Name, Last_Name, Phone_Num, Specialty)
VALUES (Provider_Seq.NEXTVAL, 4, 'Mickey', 'Mouse', '000-345-7654', 'Family Medicine');

/*Visits Table*/
INSERT INTO Visits (Visit_ID, Patient_ID, Provider_ID, Notes, Purpose, Hospital_CCN_ID, Visit_Date)
VALUES (Visits_Seq.NEXTVAL, 1,1,'Patient needs new air filter','cough',1, '28-JUL-2016');

INSERT INTO Visits (Visit_ID, Patient_ID, Provider_ID, Notes, Purpose, Hospital_CCN_ID, Visit_Date)
VALUES (Visits_Seq.NEXTVAL, 1,1,'air filter did not work...give advil','cough',1, '28-JUL-2017');

INSERT INTO Visits (Visit_ID, Patient_ID, Provider_ID, Notes, Purpose, Hospital_CCN_ID, Visit_Date)
VALUES (Visits_Seq.NEXTVAL, 2,2,'Need to order xrays','chest pain',2, '12-OCT-2016');

INSERT INTO Visits (Visit_ID, Patient_ID, Provider_ID, Notes, Purpose, Hospital_CCN_ID, Visit_Date)
VALUES (Visits_Seq.NEXTVAL, 3,3,'MRI results are negative','left radius broke ',3, '27-OCT-2017');

INSERT INTO Visits (Visit_ID, Patient_ID, Provider_ID, Notes, Purpose, Hospital_CCN_ID, Visit_Date)
VALUES (Visits_Seq.NEXTVAL, 5,2,'Serious heart problems!!!','Heart Attack',3, '02-Aug-2017');

/*Commented out insert statements used to test trigger constraints*/
/*
INSERT INTO Visits (Visit_ID, Patient_ID, Provider_ID, Notes, Purpose, Hospital_CCN_ID, Visit_Date)
VALUES (Visits_Seq.NEXTVAL, 125,2,'Serious heart problems!!!','Heart Attack',3, '02-Aug-2017');
*/

/*Medications Table*/
INSERT INTO Medications(Medication_ID, Name, Dose)
VALUES (Medications_Seq.NEXTVAL, 'Penicillin', '1mg');

INSERT INTO Medications(Medication_ID, Name, Dose)
VALUES (Medications_Seq.NEXTVAL, 'Advil', '2mg');

INSERT INTO Medications(Medication_ID, Name, Dose)
VALUES (Medications_Seq.NEXTVAL, 'Aleve', '3mg');

INSERT INTO Medications(Medication_ID, Name, Dose)
VALUES (Medications_Seq.NEXTVAL, 'Benadryl', '6ml');

/*Prescriptions Table*/
INSERT INTO Prescriptions (Visit_ID, Medication_ID, Provider_ID, Qty, Prescription_Num, Pharmacy_Num)
VALUES (1,1,1,1,342, 125);

INSERT INTO Prescriptions (Visit_ID, Medication_ID, Provider_ID, Qty, Prescription_Num, Pharmacy_Num)
VALUES (2,2,1,1,789, 273);

INSERT INTO Prescriptions (Visit_ID, Medication_ID, Provider_ID, Qty, Prescription_Num, Pharmacy_Num)
VALUES (3,3,2,1,1001, 344);

INSERT INTO Prescriptions (Visit_ID, Medication_ID, Provider_ID, Qty, Prescription_Num, Pharmacy_Num)
VALUES (4,1,3,1,052, 888);

INSERT INTO Prescriptions (Visit_ID, Medication_ID, Provider_ID, Qty, Prescription_Num, Pharmacy_Num)
VALUES (4,2,3,1,053, 888);

INSERT INTO Prescriptions (Visit_ID, Medication_ID, Provider_ID, Qty, Prescription_Num, Pharmacy_Num)
VALUES (5,2,2,1,1002, 767);

/* Create trigger */
/*This trigger will enforce patient_id foreign key constraint across the distributed patients table*/
CREATE OR REPLACE TRIGGER Visit_Patient_Insert_Constraint BEFORE INSERT OR UPDATE ON Visits
FOR EACH ROW
    DECLARE
        X NUMBER;
   BEGIN
    SELECT COUNT(*) INTO X
        FROM all_patients_view
            WHERE Patient_ID = :New.Patient_ID;
            
        if X = 0
        THEN
            raise_application_error (-20100, 'Patient_ID invalid');
        END IF;
    END;
    /

/*This trigger will enforce patient_id foreign key constraint across the distributed patients table*/
CREATE OR REPLACE TRIGGER Visit_Patient_Delete_Constraint BEFORE DELETE OR UPDATE ON Patients
FOR EACH ROW
    DECLARE
        X NUMBER;
   BEGIN
    SELECT COUNT(*) INTO X
        FROM Visits
            WHERE Patient_ID = :OLD.Patient_ID;
        if X > 0
        THEN
            raise_application_error (-20100, 'Delete or update children rows from Visits table first');
        END IF;
    END;
    /

/*These update and delete commands test the delete trigger above*/
/*DELETE FROM Patients WHERE Patient_ID = 1;
DELETE FROM Patients WHERE Patient_ID = 4;
UPDATE Patients SET Patient_ID = 9 WHERE Patient_ID = 2;
DELETE FROM Patients@Linker_1_2 WHERE Patient_ID = 5;
UPDATE Patients@Linker_1_2 SET Patient_ID = 9 WHERE Patient_ID = 5;*/


/*Run Select all for all tables, to ensure insert statements worked.*/
SELECT * FROM all_patients_view;
SELECT * FROM Hospitals;
SELECT * FROM Visits;
SELECT * FROM Provider;
SELECT * FROM Prescriptions;
SELECT * FROM Medications;

/*Views*/

/*View joins together the horizontally fragmented Patients tables on Hospdba and Hospdbb*/
CREATE OR REPLACE VIEW all_patients_view AS
SELECT * FROM Patients
UNION
SELECT * FROM Patients@Linker_1_2;

/*Test the view*/
SELECT * FROM all_patients_view;

/*4 Queries*/


/*This query joins the "Patients", "Visits", and "Provider" tables where the specialty
of the provider is "Radiology*/

SELECT TO_CHAR(pa.first_name) || ' ' || TO_CHAR(pa.last_name) AS Patient, vi.purpose AS Purpose,
TO_CHAR(pr.first_name) || ' ' || TO_CHAR(pr.last_name) AS Provider FROM all_patients_view Pa
    INNER JOIN Visits Vi USING (Patient_ID)
    INNER JOIN Provider Pr USING (Provider_ID)
        WHERE Pr.specialty = 'Radiology' ;

/*This query will show the "Patients" table joined with the "Provider" , "Visits", 
"Prescriptions", and "Medication" tables and where the medication is penicillin and the 
visit occured on or after 1/1/2017*/

SELECT TO_CHAR(pa.first_name) || ' ' || TO_CHAR(pa.last_name) AS Patient, vi.purpose AS Purpose,
TO_CHAR(pr.first_name) || ' ' || TO_CHAR(pr.last_name) AS Provider, Vi.Visit_Date AS Visit_Date,
Med.Name AS Medication, Med.Dose AS Dose, Pres.qty as Quantity FROM all_patients_view Pa
    INNER JOIN Visits Vi USING (Patient_ID)
    INNER JOIN Provider Pr USING (Provider_ID)
    INNER JOIN Prescriptions Pres USING (Visit_ID)
    INNER JOIN Medications Med USING (Medication_ID)
        WHERE Med.Name = 'Penicillin' AND Vi.Visit_Date > = '01-Jan-2017';


/*This query will show the number of visits a CMS region has had along with the
most recent visit date and last patient seen, sorted by the number of visits.*/
      
SELECT  Hosp.CMS_Region as CMS_Region, COUNT(Vi.Visit_ID) AS Visit_Count,
    MAX(Vi.Visit_Date) AS Most_Recent_Visit,
    TO_CHAR(pa.first_name) || ' ' || TO_CHAR(pa.last_name) AS Last_Patient_Seen
        FROM Hospitals Hosp
            LEFT JOIN Visits Vi On Vi.Hospital_CCN_ID = Hosp.Hospital_CCN_ID
            LEFT JOIN all_patients_view Pa ON Vi.Patient_ID = Pa.Patient_ID
                GROUP BY Hosp.CMS_Region, TO_CHAR(pa.first_name) || ' ' || TO_CHAR(pa.last_name)
                    ORDER BY Visit_Count;
    
    
/*This query will join together the patient and visits table, and then using a subquery
determine how many visits a patient has had, in order by visit count*/
SELECT DISTINCT Pa.Patient_ID, TO_CHAR(pa.first_name) || ' ' || TO_CHAR(pa.last_name) AS Patient,
(SELECT COUNT(Patient_ID) FROM Visits iVi WHERE iVi.Patient_ID = Vi.Patient_ID) as Visit_Count
FROM all_patients_view Pa
    LEFT JOIN Visits Vi ON Vi.Patient_ID = Pa.Patient_ID
        ORDER BY Visit_Count DESC;

/*commit changes to database*/
commit;





/*Repeat the 5 views and queries above, this time using EXPLAIN PLAN to show the execution plan*/

/*The view*/
EXPLAIN PLAN FOR
SELECT * FROM all_patients_view;

SELECT * FROM table(DBMS_XPLAN.DISPLAY);

/*The 4 Queries*/


/*This query joins the "Patients", "Visits", and "Provider" tables where the specialty
of the provider is "Radiology*/
EXPLAIN PLAN FOR
SELECT TO_CHAR(pa.first_name) || ' ' || TO_CHAR(pa.last_name) AS Patient, vi.purpose AS Purpose,
TO_CHAR(pr.first_name) || ' ' || TO_CHAR(pr.last_name) AS Provider FROM all_patients_view Pa
    INNER JOIN Visits Vi USING (Patient_ID)
    INNER JOIN Provider Pr USING (Provider_ID)
        WHERE Pr.specialty = 'Radiology' ;

SELECT * FROM table(DBMS_XPLAN.DISPLAY);

/*This query will show the "Patients" table joined with the "Provider" , "Visits", 
"Prescriptions", and "Medication" tables and where the medication is penicillin and the 
visit occured on or after 1/1/2017*/
EXPLAIN PLAN FOR
SELECT TO_CHAR(pa.first_name) || ' ' || TO_CHAR(pa.last_name) AS Patient, vi.purpose AS Purpose,
TO_CHAR(pr.first_name) || ' ' || TO_CHAR(pr.last_name) AS Provider, Vi.Visit_Date AS Visit_Date,
Med.Name AS Medication, Med.Dose AS Dose, Pres.qty as Quantity FROM all_patients_view Pa
    INNER JOIN Visits Vi USING (Patient_ID)
    INNER JOIN Provider Pr USING (Provider_ID)
    INNER JOIN Prescriptions Pres USING (Visit_ID)
    INNER JOIN Medications Med USING (Medication_ID)
        WHERE Med.Name = 'Penicillin' AND Vi.Visit_Date > = '01-Jan-2017';

SELECT * FROM table(DBMS_XPLAN.DISPLAY);

/*This query will show the number of visits a CMS region has had along with the
most recent visit date and last patient seen, sorted by the number of visits.*/
EXPLAIN PLAN FOR  
SELECT  Hosp.CMS_Region as CMS_Region, COUNT(Vi.Visit_ID) AS Visit_Count,
    MAX(Vi.Visit_Date) AS Most_Recent_Visit,
    TO_CHAR(pa.first_name) || ' ' || TO_CHAR(pa.last_name) AS Last_Patient_Seen
        FROM Hospitals Hosp
            LEFT JOIN Visits Vi On Vi.Hospital_CCN_ID = Hosp.Hospital_CCN_ID
            LEFT JOIN all_patients_view Pa ON Vi.Patient_ID = Pa.Patient_ID
                GROUP BY Hosp.CMS_Region, TO_CHAR(pa.first_name) || ' ' || TO_CHAR(pa.last_name)
                    ORDER BY Visit_Count;
    
SELECT * FROM table(DBMS_XPLAN.DISPLAY);

/*This query will join together the patient and visits table, and then using a subquery
determine how many visits a patient has had, in order by visit count*/
EXPLAIN PLAN FOR
SELECT DISTINCT Pa.Patient_ID, TO_CHAR(pa.first_name) || ' ' || TO_CHAR(pa.last_name) AS Patient,
(SELECT COUNT(Patient_ID) FROM Visits iVi WHERE iVi.Patient_ID = Vi.Patient_ID) as Visit_Count
FROM all_patients_view Pa
    LEFT JOIN Visits Vi ON Vi.Patient_ID = Pa.Patient_ID
        ORDER BY Visit_Count DESC;

SELECT * FROM table(DBMS_XPLAN.DISPLAY);
