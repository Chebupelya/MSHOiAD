use RENTAL_CARS_SERVICES;
SELECT * FROM MAINTENANCE;
--TASK 2
SELECT 
    YEAR(MaintenanceDate) AS year,
    CASE 
        WHEN MONTH(MaintenanceDate) BETWEEN 1 AND 6 THEN 'H1'
        ELSE 'H2'
    END AS half_year,
    DATEPART(QUARTER, MaintenanceDate) AS quarter,
    MONTH(MaintenanceDate) AS month,
    SUM(MaintenanceCost) AS profit
FROM 
    Maintenance
GROUP BY 
    GROUPING SETS (
        (YEAR(MaintenanceDate), 
        CASE WHEN MONTH(MaintenanceDate) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END, 
        DATEPART(QUARTER, MaintenanceDate), 
        MONTH(MaintenanceDate)),
        (YEAR(MaintenanceDate), 
        CASE WHEN MONTH(MaintenanceDate) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END, 
        DATEPART(QUARTER, MaintenanceDate)),
        (YEAR(MaintenanceDate), 
        CASE WHEN MONTH(MaintenanceDate) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END),
        (YEAR(MaintenanceDate)),
        ()
    )
ORDER BY year, half_year, quarter, month;





SELECT 
    YEAR(MaintenanceDate) AS year,
	MONTH(MaintenanceDate) AS month,
	DATEPART(QUARTER, MaintenanceDate) AS quarter,
    CASE 
        WHEN MONTH(MaintenanceDate) BETWEEN 1 AND 6 THEN 'H1'
        ELSE 'H2'
    END AS half_year,
    SUM(MaintenanceCost) AS profit
FROM 
    Maintenance
GROUP BY 
    GROUPING SETS (
        (YEAR(MaintenanceDate), CASE WHEN MONTH(MaintenanceDate) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END, DATEPART(QUARTER, MaintenanceDate), MONTH(MaintenanceDate)),
        (YEAR(MaintenanceDate), CASE WHEN MONTH(MaintenanceDate) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END, DATEPART(QUARTER, MaintenanceDate)),
        (YEAR(MaintenanceDate), CASE WHEN MONTH(MaintenanceDate) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END),
        (YEAR(MaintenanceDate))
    )
ORDER BY year, half_year, quarter, month


--TASK 3
WITH MaintenanceStats AS (
    SELECT 
        mt.TypeName AS MAINTENANCE_TYPE,
        COUNT(*) AS VOLUME,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS RANK_BY_VOLUME,
        SUM(COUNT(*)) OVER () AS TOTAL_COUNT,
        MAX(COUNT(*)) OVER () AS MAX_COUNT
    FROM 
        Maintenance m
    INNER JOIN 
        MaintenanceTypes mt ON m.MaintenanceType = mt.TypeID
    WHERE 
        m.MaintenanceDate BETWEEN '2023-01-01' AND '2024-01-01'
    GROUP BY 
        mt.TypeName
)
SELECT 
    MAINTENANCE_TYPE,
    VOLUME,
    ROUND(1.0 * VOLUME / TOTAL_COUNT, 2) AS PERCENT_OF_TOTAL,
    ROUND(1.0 * VOLUME / MAX_COUNT, 2) AS PERCENT_OF_MAX
FROM 
    MaintenanceStats
ORDER BY 
    RANK_BY_VOLUME;







SELECT 
    service_count AS volume,
    ROUND(((CONVERT(FLOAT, service_count) / total_count) * 100), 2) AS percent_of_total,
    ROUND(((CONVERT(FLOAT, service_count) / max_count) * 100), 2) AS percent_of_max
FROM 
    (
        SELECT COUNT(*) as service_count 
        FROM Maintenance
        INNER JOIN
            Cars
            ON Maintenance.Car = Cars.CarID
        INNER JOIN
            MaintenanceTypes
            ON Maintenance.MaintenanceType = MaintenanceTypes.TypeID
        WHERE MaintenanceTypes.TypeID = 1
        AND MaintenanceDate BETWEEN '2023-01-01' AND '2024-01-01'
    ) AS service,
    (
        SELECT COUNT(*) as total_count 
        FROM Maintenance 
        WHERE MaintenanceDate BETWEEN '2020-01-01' AND '2024-01-01'
    ) AS total,
    (
        SELECT MAX(service_count) as max_count FROM
        (
            SELECT COUNT(*) as service_count 
            FROM Maintenance
            INNER JOIN
                Cars
                ON Maintenance.Car = Cars.CarID
            INNER JOIN
                MaintenanceTypes
                ON Maintenance.MaintenanceType = MaintenanceTypes.TypeID
            GROUP BY MaintenanceTypes.TypeID
        ) AS service_counts
    ) AS max_service;


--TASK 4
SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY MaintenanceDate) AS row_num,
        Maintenance.*
    FROM 
        Maintenance
    WHERE 
        MaintenanceDate BETWEEN '2020-01-01' AND '2024-01-01'
) AS numbered_payments
WHERE row_num BETWEEN 1 AND 20;


--TASK 5
SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY MaintenanceCost ORDER BY MaintenanceDate) AS row_num,
        Maintenance.*
    FROM 
        Maintenance
    WHERE 
        MaintenanceDate BETWEEN '2020-01-01' AND '2024-01-01'
) AS partitioned_payments
WHERE row_num = 1;





--TASK 6
SELECT 
    Client,
    SUM(TotalCost) AS total_payment
FROM 
    Bookings
INNER JOIN 
    Clients
    ON Bookings.Client = Clients.ClientID
WHERE 
    RentalStartDate >= DATEADD(MONTH, -6, GETDATE())
GROUP BY 
    Client
ORDER BY 
    Client;


--SUBTASK 6
SELECT 
    Client,
    FORMAT(RentalStartDate, 'yyyy-MM') AS month,
    SUM(TotalCost) AS total_payment
FROM 
    Bookings
INNER JOIN 
    Clients
    ON Bookings.Client = Clients.ClientID
WHERE 
    RentalStartDate >= DATEADD(MONTH, -6, GETDATE())
GROUP BY 
    Client,
    FORMAT(RentalStartDate, 'yyyy-MM')
ORDER BY 
    Client, month;

SELECT * FROM BOOKINGS;
SELECT * FROM CLIENTS;


--TASK 7
WITH RankedMaintenance AS (
    SELECT
        Maintenance.Car AS CarID,
        MaintenanceTypes.TypeName,
        COUNT(*) AS ServiceCount,
        RANK() OVER (PARTITION BY Maintenance.Car ORDER BY COUNT(*) DESC) AS rnk
    FROM
        Maintenance
    JOIN
        MaintenanceTypes ON Maintenance.MaintenanceType = MaintenanceTypes.TypeID
    GROUP BY
        Maintenance.Car, MaintenanceTypes.TypeName
)
SELECT
    Cars.CarID,
    RankedMaintenance.TypeName AS Service,
    RankedMaintenance.ServiceCount
FROM
    Cars
JOIN
    RankedMaintenance ON Cars.CarID = RankedMaintenance.CarID
WHERE
    RankedMaintenance.rnk = 1;