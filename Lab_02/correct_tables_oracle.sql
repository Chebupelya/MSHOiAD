DROP TABLE CLIENTS PURGE;
DROP TABLE CARS PURGE;
DROP TABLE BOOKINGS PURGE;
DROP TABLE MAINTENANCE PURGE;
DROP TABLE EXPENSES PURGE;
DROP TABLE ACCIDENTS PURGE;
DROP TABLE INSURANCE PURGE;
DROP TABLE REPORTS PURGE;
DROP TABLE CARCATEGORIES PURGE;
DROP TABLE LOCATIONS PURGE;


-- Создание последовательности для ClientID
CREATE SEQUENCE ClientID_Seq START WITH 1 INCREMENT BY 1;

-- Создание таблицы Clients
CREATE TABLE Clients (
    ClientID NUMBER DEFAULT ClientID_Seq.NEXTVAL PRIMARY KEY,
    FirstName VARCHAR2(50) NOT NULL,
    LastName VARCHAR2(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email VARCHAR2(100) NOT NULL,
    Password VARCHAR2(100) NOT NULL,
    PhoneNumber VARCHAR2(20) NOT NULL,
    RegistrationDate DATE NOT NULL
);

-- Создание SEQUENCE для Cars
CREATE SEQUENCE CarID_Seq START WITH 1 INCREMENT BY 1;

-- Создание таблицы Cars
CREATE TABLE Cars (
    CarID NUMBER DEFAULT ClientID_Seq.NEXTVAL PRIMARY KEY,
    CarMark VARCHAR2(50) NOT NULL,
    CarModel VARCHAR2(50) NOT NULL,
    IssueYear NUMBER NOT NULL,
    LicensePlate VARCHAR2(10) NOT NULL,
    Mileage NUMBER NOT NULL,
    Category VARCHAR2(50) NOT NULL,
    Location VARCHAR2(50) NOT NULL,
    DailyRentalCost DECIMAL(10, 2) NOT NULL
);

-- Создание SEQUENCE для Bookings
CREATE SEQUENCE BookingID_Seq START WITH 1 INCREMENT BY 1;

-- Создание таблицы Bookings
CREATE TABLE Bookings (
    BookingID NUMBER DEFAULT ClientID_Seq.NEXTVAL PRIMARY KEY,
    Client NUMBER NOT NULL REFERENCES Clients (ClientID),
    Car NUMBER NOT NULL REFERENCES Cars (CarID),
    RentalStartDate DATE NOT NULL,
    RentalEndDate DATE NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
    PreviousRentalID NUMBER REFERENCES Bookings (BookingID)
);

-- Создание SEQUENCE для Maintenance
CREATE SEQUENCE MaintenanceID_Seq START WITH 1 INCREMENT BY 1;

-- Создание таблицы Maintenance
CREATE TABLE Maintenance (
    MaintenanceID NUMBER DEFAULT ClientID_Seq.NEXTVAL PRIMARY KEY,
    Car NUMBER NOT NULL REFERENCES Cars (CarID),
    MaintenanceDate DATE NOT NULL,
    MaintenanceType VARCHAR2(100) NOT NULL,
    MaintenanceCost DECIMAL(10, 2) NOT NULL
);

-- Создание SEQUENCE для Expenses
CREATE SEQUENCE ExpenseID_Seq START WITH 1 INCREMENT BY 1;

-- Создание таблицы Expenses
CREATE TABLE Expenses (
    ExpenseID NUMBER DEFAULT ClientID_Seq.NEXTVAL PRIMARY KEY,
    Car NUMBER NOT NULL REFERENCES Cars (CarID),
    Maintenance NUMBER NOT NULL REFERENCES Maintenance (MaintenanceID),
    ExpenseDate DATE NOT NULL,
    ExpenseType VARCHAR2(100) NOT NULL,
    ExpenseCost DECIMAL(10, 2) NOT NULL
);

-- Создание SEQUENCE для Accidents
CREATE SEQUENCE AccidentID_Seq START WITH 1 INCREMENT BY 1;

-- Создание таблицы Accidents
CREATE TABLE Accidents (
    AccidentID NUMBER DEFAULT ClientID_Seq.NEXTVAL PRIMARY KEY,
    Car INT NOT NULL REFERENCES Cars (CarID),
    AccidentDate DATE NOT NULL,
    AccidentDescription VARCHAR2(200) NOT NULL,
    RepairCost DECIMAL(10, 2) NOT NULL
);

-- Создание SEQUENCE для Insurance
CREATE SEQUENCE InsuranceID_Seq START WITH 1 INCREMENT BY 1;

-- Создание таблицы Insurance
CREATE TABLE Insurance (
    InsuranceID NUMBER DEFAULT ClientID_Seq.NEXTVAL PRIMARY KEY,
    Car NUMBER NOT NULL REFERENCES Cars (CarID),
    Accident NUMBER NOT NULL REFERENCES Accidents (AccidentID),
    InsuranceDate DATE NOT NULL,
    InsuranceType VARCHAR2(50) NOT NULL,
    InsuranceAmount VARCHAR2(50) NOT NULL
);

-- Создание SEQUENCE для Reports
CREATE SEQUENCE ReportID_Seq START WITH 1 INCREMENT BY 1;

-- Создание таблицы Reports
CREATE TABLE Reports (
    ReportID NUMBER DEFAULT ClientID_Seq.NEXTVAL PRIMARY KEY,
    ReportName VARCHAR2(100) NOT NULL,
    ReportDescription VARCHAR2(200) NOT NULL,
    ReportDate DATE NOT NULL,
    ReportData CLOB NOT NULL
);


CREATE TABLE CarCategories (
    CategoryID VARCHAR2(50) PRIMARY KEY,
    CategoryName VARCHAR2(50) NOT NULL,
    CategoryDescription VARCHAR2(255) NOT NULL
);


CREATE TABLE LOCATIONS (
    LocationID VARCHAR2(20) PRIMARY KEY,
    LocationName VARCHAR2(50) NOT NULL,
    City VARCHAR2(50) NOT NULL,
    Street VARCHAR2(50) NOT NULL,
    BuildingNumber VARCHAR2(50) NOT NULL,
    GeographicCoordinates VARCHAR2(100) NOT NULL
);


CREATE INDEX idx_clients_email ON Clients (PhoneNumber);

CREATE INDEX idx_cars_mark_model ON Cars (CarMark, CarModel, LicensePlate);

CREATE INDEX idx_bookings_client_car ON Bookings (Client, Car);
CREATE INDEX idx_bookings_start_date ON Bookings (RentalStartDate);
CREATE INDEX idx_bookings_end_date ON Bookings (RentalEndDate);




-- Создание процедуры AddNewClient
CREATE OR REPLACE PROCEDURE AddNewClient (
    p_FirstName IN VARCHAR2,
    p_LastName IN VARCHAR2,
    p_DateOfBirth IN DATE,
    p_Email IN VARCHAR2,
    p_Password IN VARCHAR2,
    p_PhoneNumber IN VARCHAR2,
    p_RegistrationDate IN DATE
) AS
BEGIN
    INSERT INTO Clients (ClientID, FirstName, LastName, DateOfBirth, Email, Password, PhoneNumber, RegistrationDate)
    VALUES (ClientID_Seq.NEXTVAL, p_FirstName, p_LastName, p_DateOfBirth, p_Email, p_Password, p_PhoneNumber, p_RegistrationDate);
    COMMIT;
END AddNewClient;
/

-- Создание процедуры AddNewBooking
CREATE OR REPLACE PROCEDURE AddNewBooking (
    p_ClientID IN NUMBER,
    p_CarID IN NUMBER,
    p_RentalStartDate IN DATE,
    p_RentalEndDate IN DATE
) AS
BEGIN
    INSERT INTO Bookings (BookingID, Client, Car, RentalStartDate, RentalEndDate, TotalCost)
    VALUES (BookingID_Seq.NEXTVAL, p_ClientID, p_CarID, p_RentalStartDate, p_RentalEndDate, NULL);
    COMMIT;
END AddNewBooking;
/

-- Создание процедуры CalculateRentalCost
CREATE OR REPLACE PROCEDURE CalculateRentalCost (
    p_BookingID IN NUMBER
) AS
DECLARE
    v_StartDate DATE;
    v_EndDate DATE;
    v_DailyRentalCost NUMBER;
    v_TotalCost NUMBER;
BEGIN
    SELECT RentalStartDate, RentalEndDate INTO v_StartDate, v_EndDate
    FROM Bookings
    WHERE BookingID = p_BookingID;

    SELECT DailyRentalCost INTO v_DailyRentalCost
    FROM Cars
    WHERE CarID = (SELECT Car FROM Bookings WHERE BookingID = p_BookingID);

    v_TotalCost := v_DailyRentalCost * (v_EndDate - v_StartDate + 1);
    
    UPDATE Bookings
    SET TotalCost = v_TotalCost
    WHERE BookingID = p_BookingID;
    
    COMMIT;
END CalculateRentalCost;
/




-- Создание функции GetCurrentlyRentedCars
CREATE OR REPLACE FUNCTION GetCurrentlyRentedCars (
    p_CurrentDate IN DATE
) RETURN SYS_REFCURSOR AS
    v_RentedCars SYS_REFCURSOR;
BEGIN
    OPEN v_RentedCars FOR
        SELECT c.CarID, c.CarMark, c.CarModel
        FROM Cars c
        INNER JOIN Bookings b ON c.CarID = b.Car
        WHERE p_CurrentDate BETWEEN b.RentalStartDate AND b.RentalEndDate;

    RETURN v_RentedCars;
END GetCurrentlyRentedCars;
/

-- Создание функции GetRentalHistory
CREATE OR REPLACE FUNCTION GetRentalHistory (
    p_ClientID IN NUMBER
) RETURN SYS_REFCURSOR AS
    v_RentalHistory SYS_REFCURSOR;
BEGIN
    OPEN v_RentalHistory FOR
        SELECT b.BookingID, b.RentalStartDate, b.RentalEndDate, c.CarMark, c.CarModel, b.TotalCost
        FROM Bookings b
        INNER JOIN Cars c ON b.Car = c.CarID
        WHERE b.Client = p_ClientID;

    RETURN v_RentalHistory;
END GetRentalHistory;
/

-- Создание функции GetAccidentHistoryForCar
CREATE OR REPLACE FUNCTION GetAccidentHistoryForCar (
    p_CarID IN NUMBER
) RETURN SYS_REFCURSOR AS
    v_AccidentHistory SYS_REFCURSOR;
BEGIN
    OPEN v_AccidentHistory FOR
        SELECT a.AccidentID, a.AccidentDate, a.AccidentDescription, a.RepairCost, i.InsuranceType, i.InsuranceAmount
        FROM Accidents a
        LEFT JOIN Insurance i ON a.AccidentID = i.Accident
        WHERE a.Car = p_CarID;

    RETURN v_AccidentHistory;
END GetAccidentHistoryForCar;
/






-- Создание триггера GreetingClient
CREATE OR REPLACE TRIGGER GreetingClient
AFTER INSERT ON Clients
FOR EACH ROW
DECLARE
    v_ClientName VARCHAR2(100);
    v_Email VARCHAR2(100);
    v_Message VARCHAR2(200);
BEGIN
    -- Получаем имя клиента и его email
    v_ClientName := :NEW.FirstName || ' ' || :NEW.LastName;
    v_Email := :NEW.Email;

    v_Message := 'Добро пожаловать, ' || v_ClientName || '! Спасибо за регистрацию в нашем сервисе аренды автомобилей.';

END AfterInsertClient;
/


-- Создание триггера CheckMaintenanceCost
CREATE OR REPLACE TRIGGER CheckMaintenanceCost
BEFORE UPDATE ON Cars
FOR EACH ROW
BEGIN
    IF :NEW.MaintenanceCost < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Сумма технического обслуживания должна быть неотрицательной.');
    END IF;
END CheckMaintenanceCost;
/


-- Создание триггера CheckCoordinatesFormat
CREATE OR REPLACE TRIGGER CheckCoordinatesFormat
BEFORE UPDATE ON Locations
FOR EACH ROW
BEGIN
    IF REGEXP_LIKE(:NEW.GeographicCoordinates, '^[+-]?([0-9]*[.])?[0-9]+,[+-]?([0-9]*[.])?[0-9]+$') = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Неверный формат координат. Используйте формат "широта, долгота".');
    END IF;
END CheckCoordinatesFormat;
/


-- Создание триггера CheckPhoneNumber
CREATE OR REPLACE TRIGGER CheckPhoneNumber
BEFORE INSERT OR UPDATE ON Clients
FOR EACH ROW
BEGIN
    IF LENGTH(:NEW.PhoneNumber) <> 10 OR
       :NEW.PhoneNumber NOT LIKE '+375[0-9]{7}' THEN
        RAISE_APPLICATION_ERROR(-20003, 'Неверный формат номера телефона. Используйте формат: "+375XXXXXXXXX".');
    END IF;
END CheckPhoneNumber;
/

