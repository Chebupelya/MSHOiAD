use RENTAL_CARS_SERVICES;

DROP TABLE INSURANCE;
DROP TABLE REPORTS;
DROP TABLE CARCATEGORIES;
DROP TABLE LOCATIONS;
DROP TABLE ACCIDENTS;
DROP TABLE EXPENSES;
DROP TABLE MAINTENANCE;
DROP TABLE BOOKINGS;
DROP TABLE CARS;
DROP TABLE CLIENTS;



-- Создание SEQUENCE для Clients
CREATE SEQUENCE ClientID_Seq AS INT START WITH 0 INCREMENT BY 1;

-- Создание таблицы Clients
CREATE TABLE Clients (
    ClientID INT DEFAULT NEXT VALUE FOR ClientID_Seq PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Password NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    RegistrationDate DATE NOT NULL
);

-- Создание SEQUENCE для Cars
CREATE SEQUENCE CarID_Seq AS INT START WITH 0 INCREMENT BY 1;

-- Создание таблицы Cars
CREATE TABLE Cars (
    CarID INT DEFAULT NEXT VALUE FOR CarID_Seq PRIMARY KEY,
    CarMark NVARCHAR(50) NOT NULL,
    CarModel NVARCHAR(50) NOT NULL,
    IssueYear INT NOT NULL,
    LicensePlate NVARCHAR(10) NOT NULL,
    Mileage INT NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    Location NVARCHAR(50) NOT NULL,
    DailyRentalCost DECIMAL(10, 2) NOT NULL
);

-- Создание SEQUENCE для Bookings
CREATE SEQUENCE BookingID_Seq AS INT START WITH 1 INCREMENT BY 1;

-- Создание таблицы Bookings
CREATE TABLE Bookings (
    BookingID hierarchyid PRIMARY KEY,
	Level AS BookingID.GetLevel() PERSISTED,
    Client INT NOT NULL REFERENCES Clients (ClientID),
    Car INT NOT NULL REFERENCES Cars (CarID),
    RentalStartDate DATE NOT NULL,
    RentalEndDate DATE NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
);

-- Создание SEQUENCE для Maintenance
CREATE SEQUENCE MaintenanceID_Seq AS INT START WITH 1 INCREMENT BY 1;

-- Создание таблицы Maintenance
CREATE TABLE Maintenance (
    MaintenanceID INT DEFAULT NEXT VALUE FOR MaintenanceID_Seq PRIMARY KEY,
    Car INT NOT NULL REFERENCES Cars (CarID),
    MaintenanceDate DATE NOT NULL,
    MaintenanceType NVARCHAR(100) NOT NULL,
    MaintenanceCost DECIMAL(10, 2) NOT NULL
);

-- Создание SEQUENCE для Expenses
CREATE SEQUENCE ExpenseID_Seq AS INT START WITH 1 INCREMENT BY 1;

-- Создание таблицы Expenses
CREATE TABLE Expenses (
    ExpenseID INT DEFAULT NEXT VALUE FOR ExpenseID_Seq PRIMARY KEY,
    Car INT NOT NULL REFERENCES Cars (CarID),
    Maintenance INT NOT NULL REFERENCES Maintenance (MaintenanceID),
    ExpenseDate DATE NOT NULL,
    ExpenseType NVARCHAR(100) NOT NULL,
    ExpenseCost DECIMAL(10, 2) NOT NULL
);

-- Создание SEQUENCE для Accidents
CREATE SEQUENCE AccidentID_Seq AS INT START WITH 1 INCREMENT BY 1;

-- Создание таблицы Accidents
CREATE TABLE Accidents (
    AccidentID INT DEFAULT NEXT VALUE FOR AccidentID_Seq PRIMARY KEY,
    Car INT NOT NULL REFERENCES Cars (CarID),
    AccidentDate DATE NOT NULL,
    AccidentDescription NVARCHAR(200) NOT NULL,
    RepairCost DECIMAL(10, 2) NOT NULL
);

-- Создание SEQUENCE для Insurance
CREATE SEQUENCE InsuranceID_Seq AS INT START WITH 1 INCREMENT BY 1;

-- Создание таблицы Insurance
CREATE TABLE Insurance (
    InsuranceID INT DEFAULT NEXT VALUE FOR InsuranceID_Seq PRIMARY KEY,
    Car INT NOT NULL REFERENCES Cars (CarID),
    Accident INT NOT NULL REFERENCES Accidents (AccidentID),
    InsuranceDate DATE NOT NULL,
    InsuranceType NVARCHAR(50) NOT NULL,
    InsuranceAmount NVARCHAR(50) NOT NULL
);

-- Создание SEQUENCE для Reports
CREATE SEQUENCE ReportID_Seq AS INT START WITH 1 INCREMENT BY 1;

-- Создание таблицы Reports
CREATE TABLE Reports (
    ReportID INT DEFAULT NEXT VALUE FOR ReportID_Seq PRIMARY KEY,
    ReportName NVARCHAR(100) NOT NULL,
    ReportDescription NVARCHAR(200) NOT NULL,
    ReportDate DATE NOT NULL,
    ReportData NVARCHAR(MAX) NOT NULL
);


CREATE TABLE CarCategories (
    CategoryID NVARCHAR(50) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL,
    CategoryDescription NVARCHAR(255) NOT NULL
);


CREATE TABLE LOCATIONS (
    LocationID NVARCHAR(20) PRIMARY KEY,
    LocationName NVARCHAR(50) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    Street NVARCHAR(50) NOT NULL,
    BuildingNumber NVARCHAR(50) NOT NULL,
    GeographicCoordinates NVARCHAR(100) NOT NULL
);