use RENTAL_CARS_SERVICES;

CREATE TABLE MaintenanceTypes (TypeID INT PRIMARY KEY, TypeName NVARCHAR(100));
INSERT INTO MaintenanceTypes VALUES (1, 'Тех.обслуживание');
INSERT INTO MaintenanceTypes VALUES (2, 'ДТП');
INSERT INTO MaintenanceTypes VALUES (3, 'Ремонт');

ALTER TABLE MAINTENANCE
ADD CONSTRAINT FK_Maintenance_MaintenanceTypes FOREIGN KEY (MaintenanceType) REFERENCES MaintenanceTypes(TypeID);


SELECT * FROM MAINTENANCE;
SELECT * FROM BOOKINGS;
SELECT * FROM CARS;

DELETE FROM MAINTENANCE;

INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (1, 1, '2023-10-10', 1, 2000);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (2, 2, '2023-01-15', 1, 2000);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (3, 3, '2023-02-01', 1, 2000);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (4, 4, '2023-03-12', 1, 3000);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (5, 5, '2023-04-25', 1, 4000);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (16, 1, '2020-11-10', 1, 2135);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (27, 1, '2023-08-10', 1, 3000);


INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (6, 1, '2023-05-19', 2, 500);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (7, 2, '2023-06-23', 2, 700);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (8, 3, '2023-07-12', 2, 860);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (9, 4, '2023-08-08', 2, 930);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (28, 5, '2023-10-23', 2, 2120);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (29, 5, '2023-08-23', 2, 2500);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (10, 5, '2023-09-23', 2, 2100);


INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (11, 1, '2023-10-12', 3, 2300);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (12, 2, '2023-11-12', 3, 720);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (13, 3, '2023-12-24', 3, 660);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (14, 4, '2023-07-20', 3, 350);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (15, 5, '2023-08-27', 3, 200);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (17, 4, '2023-08-27', 3, 300);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (18, 2, '2023-08-27', 3, 400);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (19, 3, '2023-08-27', 3, 500);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (20, 5, '2023-08-27', 3, 600);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (21, 1, '2023-08-27', 3, 700);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (22, 3, '2023-08-27', 3, 800);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (23, 5, '2023-08-27', 3, 900);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (24, 2, '2023-08-27', 3, 260);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (25, 3, '2023-08-27', 3, 370);
INSERT INTO MAINTENANCE (MaintenanceID, Car, MaintenanceDate, MaintenanceType, MaintenanceCost) VALUES (26, 4, '2023-08-27', 3, 690);



INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost) VALUES(1, 2, '2023-07-01', '2023-08-01', 1500);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost) VALUES(2, 3, '2023-08-08', '2023-09-09', 1500);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost) VALUES(3, 4, '2023-08-09', '2023-08-11', 1500);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost) VALUES(2, 5, '2023-11-12', '2023-12-11', 1500);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost) VALUES(5, 3, '2023-10-15', '2023-10-19', 1500);
INSERT INTO BOOKINGS(Client, Car, RentalStartDate, RentalEndDate, TotalCost) VALUES(4, 1, '2023-09-01', '2023-09-23', 1500);