Create database Hospital_DB_2;

Use Hospital_DB_2;

CREATE TABLE Patients (
    	Patient_ID INT NOT NULL,
	First_Name varchar(50) NOT NULL,
	Last_Name varchar(50) NOT NULL,
	DOB DATE NOT NULL,
	Phone_Num varchar(50) NOT NULL, 
	Gender varchar(2) NOT NULL,
	Address varchar(50) NOT NULL,
	Zip_Code varchar(50) NOT NULL,
	Database_Name varchar(50) NOT NULL
);
CREATE TABLE Visits (
    Visit_ID INT NOT NULL,
	Patient_ID INT NOT NULL,
	Provider_ID INT NOT NULL,
	Notes varchar(50) NOT NULL,
	Purpose varchar(50) NOT NULL,
	Hospital_CCN_ID INT NOT NULL
);

CREATE TABLE Hospitals (
    Visit_ID INT NOT NULL,
	Patient_ID INT NOT NULL,
	Provider_ID INT NOT NULL,
	Notes varchar(50) NOT NULL,
	Purpose varchar(50) NOT NULL,
	Hospital_CCN_ID INT NOT NULL
);

CREATE TABLE Provider (
	Provider_ID INT NOT NULL,
	Hospital_CCN_ID INT NOT NULL,
	First_Name varchar(50) NOT NULL,
	Last_Name varchar(50) NOT NULL,
	Phone_Num varchar(50) NOT NULL,
	Specialty varchar(50) NOT NULL
);
CREATE TABLE Prescriptions (
	Visit_ID INT NOT NULL,
	Medication_ID INT NOT NULL, 
	Provider_ID INT NOT NULL,
	Qty INT NOT NULL,
	Prescription_Num INT NOT NULL,
	Pharmary_Num INT NOT NULL
);

CREATE TABLE Medications (
	Medication_ID INT NOT NULL,
	Name varchar(50) NOT NULL,
	Dose varchar(50) NOT NULL
);
