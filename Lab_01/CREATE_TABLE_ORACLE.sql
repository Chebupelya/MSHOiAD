SELECT * FROM DBA_TABLESPACES;

SELECT * FROM V$PDBS;

CREATE TABLE Clients (
    ClientID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(50),
    LastName VARCHAR2(50),
    DateOfBirth DATE,
    Email VARCHAR2(100),
    Password VARCHAR2(100),
    PhoneNumber VARCHAR2(20),
    RegistrationDate DATE
);


CREATE TABLE Cars (
    CarID NUMBER PRIMARY KEY,
    CarMark VARCHAR2(50),
    CarModel VARCHAR2(50),
    IssueYear NUMBER,
    LicensePlate VARCHAR2(10),
    Mileage NUMBER,
    Category VARCHAR2(50),
    Location VARCHAR2(50),
    DailyRentalCost NUMBER
);


CREATE TABLE Bookings (
    BookingID NUMBER PRIMARY KEY,
    Client NUMBER REFERENCES Clients (ClientID),
    Car NUMBER REFERENCES Cars (CarID),
    RentalStartDate DATE,
    RentalEndDate DATE,
    TotalCost NUMBER,
    PreviousRentalID NUMBER REFERENCES BOOKINGS (BookingID)
);


CREATE TABLE Maintenance (
    MaintenanceID NUMBER PRIMARY KEY,
    Car NUMBER REFERENCES Cars (CarID),
    MaintenanceDate DATE,
    MaintenanceType VARCHAR2(100),
    MaintenanceCost NUMBER
);


CREATE TABLE Expenses (
    ExpenseID NUMBER PRIMARY KEY,
    Car NUMBER REFERENCES Cars (CarID),
    Maintenance NUMBER REFERENCES Maintenance (MaintenanceID),
    ExpenseDate DATE,
    ExpenseType VARCHAR2(100),
    ExpenseCost NUMBER
);


CREATE TABLE Accidents (
    AccidentID NUMBER PRIMARY KEY,
    Car NUMBER REFERENCES Cars (CarID),
    AccidentDate DATE,
    AccidentDescription VARCHAR2(200),
    RepairCost NUMBER
);


CREATE TABLE Insurance (
    InsuranceID NUMBER PRIMARY KEY,
    Car NUMBER REFERENCES Cars (CarID),
    Accident NUMBER REFERENCES Accidents (AccidentID),
    InsuranceDate DATE,
    InsuranceType VARCHAR2(50),
    InsuranceAmount VARCHAR2(50)
);


CREATE TABLE Reports (
    ReportID NUMBER PRIMARY KEY,
    ReportName VARCHAR2(100),
    ReportDescription VARCHAR2(200),
    ReportDate DATE,
    ReportData CLOB
);


CREATE TABLE CarCategories (
    CategoryID VARCHAR2(50) PRIMARY KEY,
    CategoryName VARCHAR2(50),
    CategoryDescription VARCHAR2(255)
);


CREATE TABLE LOCATIONS (
    LocationID VARCHAR2(20) PRIMARY KEY,
    LocationName VARCHAR2(50),
    City VARCHAR2(50),
    Street VARCHAR2(50),
    BuildingNumber VARCHAR2(50),
    GeographicCoordinates VARCHAR2(100)
);