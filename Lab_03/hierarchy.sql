use RENTAL_CARS_SERVICES;

GO
SELECT * FROM BOOKINGS;
SELECT * FROM CLIENTS;
SELECT * FROM CARS;

DELETE FROM CARS;
INSERT INTO Cars (CarMark, CarModel, IssueYear, LicensePlate, Mileage, Category, Location, DailyRentalCost)
VALUES ('ROOT', 'ROOT', 0, 'ROOT', 0, 'ROOT', 'ROOT', 0);

INSERT INTO Cars (CarMark, CarModel, IssueYear, LicensePlate, Mileage, Category, Location, DailyRentalCost)
VALUES ('Audi', 'Q8', 2022, 'AB666CD', 10000, 'Crossover', 'Location B', 100.00);

INSERT INTO Cars (CarMark, CarModel, IssueYear, LicensePlate, Mileage, Category, Location, DailyRentalCost)
VALUES ('Audi', 'Passat B5', 2022, 'AF2345AF', 20000, 'Sedan', 'Location A', 50.00);

INSERT INTO Cars (CarMark, CarModel, IssueYear, LicensePlate, Mileage, Category, Location, DailyRentalCost)
VALUES ('Volkswagen', 'T4', 1990, 'FV2352VD', 200000, 'Bus', 'Location C', 70.00);

INSERT INTO Cars (CarMark, CarModel, IssueYear, LicensePlate, Mileage, Category, Location, DailyRentalCost)
VALUES ('Opel', 'Zafira', 1989, 'KF3534KF', 356346, 'Hatchback', 'Location D', 87.00);

INSERT INTO Cars (CarMark, CarModel, IssueYear, LicensePlate, Mileage, Category, Location, DailyRentalCost)
VALUES ('Citroen', 'C4 Picasso', 2003, 'HD3523FD', 234345, 'Hatchback', 'Location E', 88.00);




INSERT INTO Clients (FirstName, LastName, DateOfBirth, Email, Password, PhoneNumber, RegistrationDate)
VALUES ('ROOT', 'ROOT', '0001-01-01', 'ROOT', 'ROOT', 'ROOT', '0001-01-01');

INSERT INTO Clients (FirstName, LastName, DateOfBirth, Email, Password, PhoneNumber, RegistrationDate)
VALUES ('Nikita', 'Ilyin', '2004-01-05', 'nikitailyin186@gmail.com', 'password123', '+375291234567', '2023-10-15');

INSERT INTO Clients (FirstName, LastName, DateOfBirth, Email, Password, PhoneNumber, RegistrationDate)
VALUES ('Alesha', 'Popovich', '2002-01-05', 'aleshapop@example.com', 'password321', '+375222222222', '2023-10-15');

INSERT INTO Clients (FirstName, LastName, DateOfBirth, Email, Password, PhoneNumber, RegistrationDate)
VALUES ('Liza', 'Volynets', '2004-04-14', 'lizavolynets@example.com', 'password999', '+375292345623', '2023-10-16');

INSERT INTO Clients (FirstName, LastName, DateOfBirth, Email, Password, PhoneNumber, RegistrationDate)
VALUES ('Vin', 'Diesel', '1970-11-12', 'dieseltop@example.com', 'family', '+375447777777', '2023-09-22');

INSERT INTO Clients (FirstName, LastName, DateOfBirth, Email, Password, PhoneNumber, RegistrationDate)
VALUES ('Akakiy', 'Panteleykin', '1999-02-12', 'akakiypanteleykin@example.com', 'chebupelya', '+375292345987', '2023-02-07');

INSERT INTO Bookings VALUES (hierarchyid::GetRoot(), 4, 4, '2023-11-01', '2023-12-01', 1500);

SELECT BookingID.ToString() AS NodeAsString,
	   BookingID AS NodeAsBinary,
	   Level,
	   Client,
	   Car
FROM Bookings;


SELECT * FROM Bookings;
INSERT INTO Bookings VALUES (hierarchyid::GetRoot(), 0, 0, '0001-01-01', '0001-01-01', 0);


GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(NULL, NULL), 1, 1, '2023-01-01', '2023-02-01', 1500)
GO

GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
SELECT @Level = BookingID FROM Bookings where BookingID.ToString() like '/1/';
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(@Level, NULL), 2, 2, '2022-01-01', '2022-02-01', 1500)
GO

GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
SELECT @Level = BookingID FROM Bookings where BookingID.ToString() like '/2/';
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(@Level, NULL), 3, 3, '2022-02-02', '2022-03-03', 1000)
GO

GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
SELECT @Level = BookingID FROM Bookings where BookingID.ToString() like '/3/';
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(@Level, NULL), 4, 4, '2022-03-03', '2022-04-04', 1000)
GO

GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
SELECT @Level = BookingID FROM Bookings where BookingID.ToString() like '/4/';
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(@Level, NULL), 5, 5, '2022-04-04', '2022-05-05', 3000)
GO

GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
SELECT @Level = BookingID FROM Bookings where BookingID.ToString() like '/5/';
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(@Level, NULL), 1, 2, '2023-07-01', '2023-08-01', 1500)
GO


GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
SELECT @Level = BookingID FROM Bookings where BookingID.ToString() like '/6/';
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(@Level, NULL), 2, 3, '2023-08-08', '2023-09-09', 1500)
GO

GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
SELECT @Level = BookingID FROM Bookings where BookingID.ToString() like '/7/';
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(@Level, NULL), 3, 4, '2023-08-09', '2023-08-11', 1500)
GO

GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
SELECT @Level = BookingID FROM Bookings where BookingID.ToString() like '/8/';
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(@Level, NULL), 2, 5, '2023-11-12', '2023-12-11', 1500)
GO

GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
SELECT @Level = BookingID FROM Bookings where BookingID.ToString() like '/9/';
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(@Level, NULL), 5, 3, '2023-10-15', '2023-10-19', 1500)
GO

GO
DECLARE @ManagerNode hierarchyid;
DECLARE @Level hierarchyid;
SELECT @ManagerNode=BookingID FROM Bookings where client = 0;
SELECT @Level = BookingID FROM Bookings where BookingID.ToString() like '/10/';
INSERT INTO Bookings VALUES (@ManagerNode.GetDescendant(@Level, NULL), 4, 1, '2023-09-01', '2023-09-23', 1500)
GO





GO
--PROCEDURE 1
CREATE PROCEDURE ShowChildNodesWithLevel(@Node hierarchyid)
AS
BEGIN
	WITH RecursiveCTE AS (
		SELECT B.BookingID, B.BookingID.GetLevel() AS NodeLevel
		FROM Bookings B
		WHERE B.BookingID = @Node

		UNION ALL

		SELECT B.BookingID, B.BookingID.GetLevel() AS NodeLevel
		FROM Bookings B
		JOIN RecursiveCTE R ON B.BookingID.GetAncestor(1) = R.BookingID
	)
	SELECT BookingID.ToString(), * FROM RecursiveCTE
	ORDER BY BookingID;
END;
GO



GO
--EXEC PROCEDURE 1
DECLARE @Node hierarchyid;
SET @Node = 0x;

EXEC ShowChildNodesWithLevel @Node;
GO

GO
--PROCEDURE 2
CREATE OR ALTER PROCEDURE AddNode
    @ParentNodeValue hierarchyid,
    @Client INT,
    @Car INT,
    @RentalStartDate DATE,
    @RentalEndDate DATE,
    @TotalCost DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Bookings (BookingID, Client, Car, RentalStartDate, RentalEndDate, TotalCost)
    VALUES (@ParentNodeValue.GetDescendant(NULL, NULL), @Client, @Car, @RentalStartDate, @RentalEndDate, @TotalCost);
END;
GO




GO
--EXEC PROCEDURE 2
DECLARE @ParentNode hierarchyid;

SET @ParentNode = CAST('/5/' AS hierarchyid);

DECLARE @SubNode hierarchyid;
EXEC AddNode @ParentNode, 5, 5, '2024-01-01', '2024-01-07', 500.00;
GO

GO
DECLARE @Node hierarchyid;
SET @Node = 0x;

EXEC ShowChildNodesWithLevel @Node;
GO




GO
--PROCEDURE 3
DROP PROCEDURE MoveBranch;
GO
CREATE PROCEDURE MoveBranch
    @old_parent hierarchyid,
    @new_parent hierarchyid
AS
BEGIN
    DECLARE @old_parent_string nvarchar(max) = @old_parent.ToString();
    DECLARE @new_parent_string nvarchar(max) = @new_parent.ToString();

    UPDATE Bookings
    SET BookingID = hierarchyid::Parse(
        replace(BookingID.ToString(), @old_parent_string, @new_parent_string)
    )
    WHERE BookingID.IsDescendantOf(@old_parent) = 1
    AND BookingID <> @old_parent;
END;
GO

EXEC MoveBranch @old_parent = '/2/', @new_parent = '/5/1/';

DECLARE @Node hierarchyid;
SET @Node = 0x;

EXEC ShowChildNodesWithLevel @Node;
GO