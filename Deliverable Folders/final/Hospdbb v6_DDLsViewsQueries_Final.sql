/*Drop all tables*/
DROP TABLE Patients;

/*Drop Link*/
DROP DATABASE LINK Linker_3_4;

/*Create all tables*/
CREATE TABLE Patients (
    Patient_ID NUMBER NOT NULL,
	First_Name VARCHAR(50) NOT NULL,
	Last_Name VARCHAR(50) NOT NULL,
	DOB DATE NOT NULL,
	Phone_Num VARCHAR(50) NOT NULL, 
	Gender VARCHAR(2) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	Zip_Code Varchar(15) NOT NULL,
	Database_Name VARCHAR(50) NOT NULL,
    CONSTRAINT    pk_patients PRIMARY KEY (Patient_ID)
);

CREATE DATABASE LINK Linker_3_4 CONNECT TO system IDENTIFIED BY "0racl3Adm1n" USING 'dbst663a';

/*This trigger will enforce patient_id foreign key constraint across the distributed patients table*/
CREATE OR REPLACE TRIGGER Visit_Patient_Delete_Constraint BEFORE DELETE OR UPDATE ON Patients
FOR EACH ROW
    DECLARE
        X NUMBER;
   BEGIN
    SELECT COUNT(*) INTO X
        FROM Visits@Linker_3_4
            WHERE Patient_ID = :OLD.Patient_ID;
        if X > 0
        THEN
            raise_application_error (-20100, 'Delete or update children rows from Visits table first');
        END IF;
    END;
    /

/*These update and delete commands test the delete trigger above*/
/*DELETE FROM Patients WHERE Patient_ID = 5;
DELETE FROM Patients WHERE Patient_ID = 8;
UPDATE Patients SET Patient_ID = 9 WHERE Patient_ID = 5;*/


commit;