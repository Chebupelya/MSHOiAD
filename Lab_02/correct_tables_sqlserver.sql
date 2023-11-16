DROP TABLE CLIENTS;
DROP TABLE CARS;
DROP TABLE BOOKINGS;
DROP TABLE MAINTENANCE;
DROP TABLE EXPENSES;
DROP TABLE ACCIDENTS;
DROP TABLE INSURANCE;
DROP TABLE REPORTS;
DROP TABLE CARCATEGORIES;
DROP TABLE LOCATIONS;


-- Создание SEQUENCE для Clients
CREATE SEQUENCE ClientID_Seq AS INT START WITH 1 INCREMENT BY 1;

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
CREATE SEQUENCE CarID_Seq AS INT START WITH 1 INCREMENT BY 1;

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
    BookingID INT DEFAULT NEXT VALUE FOR BookingID_Seq PRIMARY KEY,
    Client INT NOT NULL REFERENCES Clients (ClientID),
    Car INT NOT NULL REFERENCES Cars (CarID),
    RentalStartDate DATE NOT NULL,
    RentalEndDate DATE NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
    PreviousRentalID INT REFERENCES Bookings (BookingID)
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


CREATE INDEX idx_clients_email ON Clients (PhoneNumber);

CREATE INDEX idx_cars_mark_model ON Cars (CarMark, CarModel, LicensePlate);

CREATE INDEX idx_bookings_client_car ON Bookings (Client, Car);
CREATE INDEX idx_bookings_start_date ON Bookings (RentalStartDate);
CREATE INDEX idx_bookings_end_date ON Bookings (RentalEndDate);




GO
-- Создание процедуры AddNewClient
CREATE PROCEDURE AddNewClient (
    @p_FirstName NVARCHAR(50),
    @p_LastName NVARCHAR(50),
    @p_DateOfBirth DATE,
    @p_Email NVARCHAR(100),
    @p_Password NVARCHAR(100),
    @p_PhoneNumber NVARCHAR(20),
    @p_RegistrationDate DATE
) AS
BEGIN
    INSERT INTO Clients (FirstName, LastName, DateOfBirth, Email, Password, PhoneNumber, RegistrationDate)
    VALUES (@p_FirstName, @p_LastName, @p_DateOfBirth, @p_Email, @p_Password, @p_PhoneNumber, @p_RegistrationDate);
    COMMIT;
END;

GO
-- Создание процедуры AddNewBooking
CREATE PROCEDURE AddNewBooking (
    @p_ClientID INT,
    @p_CarID INT,
    @p_RentalStartDate DATE,
    @p_RentalEndDate DATE
) AS
BEGIN
    INSERT INTO Bookings (Client, Car, RentalStartDate, RentalEndDate, TotalCost)
    VALUES (@p_ClientID, @p_CarID, @p_RentalStartDate, @p_RentalEndDate, NULL);
    COMMIT;
END;

GO
-- Создание процедуры CalculateRentalCost
CREATE PROCEDURE CalculateRentalCost (
    @p_BookingID INT
) AS
BEGIN
    DECLARE @v_StartDate DATE;
    DECLARE @v_EndDate DATE;
    DECLARE @v_DailyRentalCost DECIMAL(10, 2);
    DECLARE @v_TotalCost DECIMAL(10, 2);
    
    SELECT @v_StartDate = RentalStartDate, @v_EndDate = RentalEndDate
    FROM Bookings
    WHERE BookingID = @p_BookingID;

    SELECT @v_DailyRentalCost = DailyRentalCost
    FROM Cars
    WHERE CarID = (SELECT Car FROM Bookings WHERE BookingID = @p_BookingID);

    SET @v_TotalCost = @v_DailyRentalCost * (DATEDIFF(DAY, @v_StartDate, @v_EndDate) + 1);
    
    UPDATE Bookings
    SET TotalCost = @v_TotalCost
    WHERE BookingID = @p_BookingID;
    
    COMMIT;
END;


GO
-- Создание функции GetCurrentlyRentedCars
CREATE FUNCTION GetCurrentlyRentedCars (
    @p_CurrentDate DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT c.CarID, c.CarMark, c.CarModel
    FROM Cars c
    INNER JOIN Bookings b ON c.CarID = b.Car
    WHERE @p_CurrentDate BETWEEN b.RentalStartDate AND b.RentalEndDate
);

GO
-- Создание функции GetRentalHistory
CREATE FUNCTION GetRentalHistory (
    @p_ClientID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT b.BookingID, b.RentalStartDate, b.RentalEndDate, c.CarMark, c.CarModel, b.TotalCost
    FROM Bookings b
    INNER JOIN Cars c ON b.Car = c.CarID
    WHERE b.Client = @p_ClientID
);

GO 
-- Создание функции GetAccidentHistoryForCar
CREATE FUNCTION GetAccidentHistoryForCar (
    @p_CarID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT a.AccidentID, a.AccidentDate, a.AccidentDescription, a.RepairCost, i.InsuranceType, i.InsuranceAmount
    FROM Accidents a
    LEFT JOIN Insurance i ON a.AccidentID = i.Accident
    WHERE a.Car = @p_CarID
);



GO
-- Создание триггера GreetingClient
CREATE TRIGGER GreetingClient
ON Clients
AFTER INSERT
AS
BEGIN
    DECLARE @v_ClientName NVARCHAR(100);
    DECLARE @v_Email NVARCHAR(100);
    DECLARE @v_Message NVARCHAR(200);
    
    SELECT @v_ClientName = FirstName + ' ' + LastName, @v_Email = Email
    FROM inserted;
    
    SET @v_Message = 'Добро пожаловать, ' + @v_ClientName + '! Спасибо за регистрацию в нашем сервисе аренды автомобилей.';
END;

GO
-- Создание триггера CheckMaintenanceCost
CREATE TRIGGER CheckMaintenanceCost
ON Maintenance
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE MaintenanceCost < 0)
    BEGIN
        PRINT 'Сумма технического обслуживания должна быть неотрицательной.';
    END;
END;

GO
-- Создание триггера CheckCoordinatesFormat
CREATE TRIGGER CheckCoordinatesFormat
ON Locations
AFTER UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted WHERE ISNUMERIC(PARSENAME(GeographicCoordinates, 1)) = 0 OR ISNUMERIC(PARSENAME(GeographicCoordinates, 2)) = 0) > 0
    BEGIN
        PRINT 'Неверный формат координат. Используйте формат "широта, долгота".';
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


GO
-- Создание триггера CheckPhoneNumber
CREATE TRIGGER CheckPhoneNumber
ON Clients
AFTER INSERT, UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted WHERE LEN(PhoneNumber) <> 10 OR PhoneNumber NOT LIKE '+375[0-9]{7}') > 0
    BEGIN
        PRINT 'Неверный формат номера телефона. Используйте формат: "+375XXXXXXX".';
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


GO
---- Создание триггера CheckPhoneNumber
--CREATE TRIGGER CheckPhoneNumber
--ON Clients
--AFTER INSERT, UPDATE
--AS
--BEGIN
--    IF (SELECT COUNT(*) FROM inserted WHERE LEN(PhoneNumber) <> 10 OR PhoneNumber NOT LIKE '+375[0-9]{7}') > 0
--    BEGIN
--        RAISEERROR ('Неверный формат номера телефона. Используйте формат: "+375XXXXXXX".', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END;
--END;
