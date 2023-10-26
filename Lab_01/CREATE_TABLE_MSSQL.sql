CREATE DATABASE RENTAL_CARS_SERVICES;

CREATE LOGIN NIKITA 
WITH PASSWORD = '1111';

USE RENTAL_CARS_SERVICES;
CREATE USER NIKITA FOR LOGIN NIKITA;

-- Просмотр доступных табличных пространств
SELECT * FROM sys.tables;

-- Просмотр информации о PDB (Pluggable Database)
SELECT * FROM sys.databases;

-- Создание таблицы Clients
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DateOfBirth DATE,
    Email NVARCHAR(100),
    Password NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    RegistrationDate DATE
);

-- Создание таблицы Cars
CREATE TABLE Cars (
    CarID INT PRIMARY KEY,
    CarMark NVARCHAR(50),
    CarModel NVARCHAR(50),
    IssueYear INT,
    LicensePlate NVARCHAR(10),
    Mileage INT,
    Category NVARCHAR(50),
    Location NVARCHAR(50),
    DailyRentalCost DECIMAL(10, 2)
);

-- Создание таблицы Bookings
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    Client INT REFERENCES Clients (ClientID),
    Car INT REFERENCES Cars (CarID),
    RentalStartDate DATE,
    RentalEndDate DATE,
    TotalCost DECIMAL(10, 2),
    PreviousRentalID INT REFERENCES Bookings (BookingID)
);

-- Создание таблицы Maintenance
CREATE TABLE Maintenance (
    MaintenanceID INT PRIMARY KEY,
    Car INT REFERENCES Cars (CarID),
    MaintenanceDate DATE,
    MaintenanceType NVARCHAR(100),
    MaintenanceCost DECIMAL(10, 2)
);

-- Создание таблицы Expenses
CREATE TABLE Expenses (
    ExpenseID INT PRIMARY KEY,
    Car INT REFERENCES Cars (CarID),
    Maintenance INT REFERENCES Maintenance (MaintenanceID),
    ExpenseDate DATE,
    ExpenseType NVARCHAR(100),
    ExpenseCost DECIMAL(10, 2)
);

-- Создание таблицы Accidents
CREATE TABLE Accidents (
    AccidentID INT PRIMARY KEY,
    Car INT REFERENCES Cars (CarID),
    AccidentDate DATE,
    AccidentDescription NVARCHAR(200),
    RepairCost DECIMAL(10, 2)
);

-- Создание таблицы Insurance
CREATE TABLE Insurance (
    InsuranceID INT PRIMARY KEY,
    Car INT REFERENCES Cars (CarID),
    Accident INT REFERENCES Accidents (AccidentID),
    InsuranceDate DATE,
    InsuranceType NVARCHAR(50),
    InsuranceAmount NVARCHAR(50)
);

-- Создание таблицы Reports
CREATE TABLE Reports (
    ReportID INT PRIMARY KEY,
    ReportName NVARCHAR(100),
    ReportDescription NVARCHAR(200),
    ReportDate DATE,
    ReportData NVARCHAR(MAX)
);

-- Создание таблицы CarCategories
CREATE TABLE CarCategories (
    CategoryID NVARCHAR(50) PRIMARY KEY,
    CategoryName NVARCHAR(50),
    CategoryDescription NVARCHAR(255)
);

-- Создание таблицы Locations
CREATE TABLE Locations (
    LocationID NVARCHAR(20) PRIMARY KEY,
    LocationName NVARCHAR(50),
    City NVARCHAR(50),
    Street NVARCHAR(50),
    BuildingNumber NVARCHAR(50),
    GeographicCoordinates NVARCHAR(100)
);
