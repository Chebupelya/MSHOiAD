SELECT * FROM BOOKINGS;
SELECT * FROM CLIENTS;
SELECT * FROM CARS;

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

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';



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



SELECT * FROM Bookings;




INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID) VALUES(1, 1, '2022-01-01', '2022-02-01', 1500, NULL);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID) VALUES(2, 2, '2023-01-01', '2023-02-01', 1500, NULL);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID) VALUES(3, 3, '2022-02-02', '2022-03-03', 1000, NULL);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID) VALUES(4, 4, '2022-03-03', '2022-04-04', 1000, NULL);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID) VALUES(5, 5, '2022-04-04', '2022-05-05', 3000, NULL);

INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID) VALUES(1, 1, '2022-10-10', '2022-11-10', 3000, 1);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID) VALUES(5, 5, '2022-04-04', '2022-05-05', 3000, 22);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID) VALUES(5, 5, '2022-04-04', '2022-05-05', 3000, NULL);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID) VALUES(5, 5, '2022-04-04', '2022-05-05', 3000, NULL);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID) VALUES(5, 5, '2022-04-04', '2022-05-05', 3000, NULL);




DROP FUNCTION ShowChildNodesWithLevel;
DROP PROCEDURE ShowChildNodesWithLevel;




SET SERVEROUTPUT ON;


CREATE TYPE booking_type AS OBJECT (
    BookingID NUMBER,
    Client NUMBER,
    Car NUMBER,
    RentalStartDate DATE,
    RentalEndDate DATE,
    TotalCost DECIMAL(10, 2),
    PreviousRentalID NUMBER,
    node_level NUMBER
);

CREATE TYPE booking_table_type AS TABLE OF booking_type;

DROP PROCEDURE ShowChildNodesWithLevel;
/
--PROCEDURE 1
CREATE OR REPLACE FUNCTION ShowChildNodesWithLevel (p_id IN NUMBER)
RETURN booking_table_type PIPELINED IS
BEGIN
    FOR rec IN (
        SELECT 
            BookingID,
            Client,
            Car,
            RentalStartDate,
            RentalEndDate,
            TotalCost,
            PreviousRentalID,
            LEVEL as node_level
        FROM 
            BOOKINGS
        START WITH BookingID = p_id
        CONNECT BY PRIOR BookingID = PreviousRentalID
    ) LOOP
        PIPE ROW(booking_type(rec.BookingID, rec.Client, rec.Car, rec.RentalStartDate, rec.RentalEndDate, rec.TotalCost, rec.PreviousRentalID, rec.node_level));
    END LOOP;
    RETURN;
END;
/
--EXEC PROCEDURE 1
SELECT * FROM TABLE(ShowChildNodesWithLevel(1));




--PROCEDURE 2
/
CREATE OR REPLACE PROCEDURE AddNode (
    p_booking_id IN NUMBER,
    p_client IN NUMBER, 
    p_car IN NUMBER, 
    p_rental_start_date IN DATE, 
    p_rental_end_date IN DATE, 
    p_total_cost IN DECIMAL, 
    p_previous_rental_id IN NUMBER
) IS
BEGIN
    INSERT INTO Bookings (BookingID, Client, Car, RentalStartDate, RentalEndDate, TotalCost, PreviousRentalID)
    VALUES (p_booking_id, p_client, p_car, p_rental_start_date, p_rental_end_date, p_total_cost, p_previous_rental_id);
END;
/

--EXEC PROCEDURE 2
EXEC AddNode(30, 1, 1, '2023-06-15', '2023-06-16', 2000, 23);
/
SELECT * FROM TABLE(ShowChildNodesWithLevel(1));


--PROCEDURE 3
/
CREATE OR REPLACE PROCEDURE MoveBranch (
    p_old_parent IN NUMBER,
    p_new_parent IN NUMBER
) IS
BEGIN
    UPDATE Bookings
    SET PreviousRentalID = p_new_parent
    WHERE PreviousRentalID = p_old_parent;
END;
/

--EXEC PROCEDURE 3
EXEC MoveBranch(1, 2);
/
SELECT * FROM TABLE(ShowChildNodesWithLevel(2));