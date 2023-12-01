SELECT SUM(MAINTENANCECOST) FROM MAINTENANCE;
SELECT * FROM MAINTENANCE;

--TASK 2
SELECT 
    EXTRACT(YEAR FROM MaintenanceDate) AS year,
    CASE 
        WHEN EXTRACT(MONTH FROM MaintenanceDate) BETWEEN 1 AND 6 THEN 'H1'
        ELSE 'H2'
    END AS half_year,
    TO_NUMBER(TO_CHAR(MaintenanceDate, 'Q')) AS quarter,
    EXTRACT(MONTH FROM MaintenanceDate) AS month,
    SUM(MaintenanceCost) AS profit
FROM 
    Maintenance
GROUP BY ROLLUP (
    EXTRACT(YEAR FROM MaintenanceDate),
    CASE WHEN EXTRACT(MONTH FROM MaintenanceDate) BETWEEN 1 AND 6 THEN 'H1' ELSE 'H2' END,
    TO_NUMBER(TO_CHAR(MaintenanceDate, 'Q')),
    EXTRACT(MONTH FROM MaintenanceDate)
)
ORDER BY year, half_year, quarter, month;


SELECT 
    year,
    month,
    quarter,
    half_year,
    SUM(profit) AS profit
FROM (
    SELECT 
        TO_CHAR(statistics.MaintenanceDate, 'YYYY') AS year,
        CASE 
            WHEN TO_CHAR(statistics.MaintenanceDate, 'MM') IN ('01', '02', '03', '04', '05', '06') THEN 'H1'
            ELSE 'H2'
        END AS half_year,
        TO_CHAR(statistics.MaintenanceDate, 'Q') AS quarter,
        TO_CHAR(statistics.MaintenanceDate, 'MM') AS month,
        NVL(MAINTENANCE, 0) AS profit
    FROM (
        SELECT 
            MaintenanceDate,
            SUM(MaintenanceCost) AS MAINTENANCE
        FROM 
            MAINTENANCE
        WHERE 
            MaintenanceType = 1
        GROUP BY 
            MaintenanceDate
    ) statistics
)
GROUP BY ROLLUP (year, half_year, quarter, month)
ORDER BY year, half_year, quarter, month;

--TASK 3
SELECT 
    maintenance_count AS volume,
    ROUND((maintenance_count / total_count) * 100, 2) AS percent_of_total,
    ROUND((maintenance_count / max_count) * 100, 2) AS percent_of_max
FROM 
    (
        SELECT COUNT(*) as maintenance_count 
        FROM Maintenance
        INNER JOIN
            Cars
            ON Maintenance.Car = Cars.CarID
        INNER JOIN
            MaintenanceTypes
            ON Maintenance.MaintenanceType = MaintenanceTypes.TypeID
        WHERE MaintenanceTypes.TypeID IN 1
        AND MaintenanceDate BETWEEN date '2023-01-01' AND date '2024-01-01'
    ),
    (
        SELECT COUNT(*) as total_count 
        FROM Maintenance 
        WHERE MaintenanceDate BETWEEN date '2020-01-01' AND date '2024-01-01'
    ),
    (
        SELECT MAX(maintenance_count) as max_count FROM
        (
            SELECT COUNT(*) as maintenance_count 
        FROM Maintenance
        INNER JOIN
            Cars
            ON Maintenance.Car = Cars.CarID
        INNER JOIN
            MaintenanceTypes
            ON Maintenance.MaintenanceType = MaintenanceTypes.TypeID
        GROUP BY MaintenanceTypes.TypeID
        )
    );



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
        m.MaintenanceDate BETWEEN DATE '2020-01-01' AND DATE '2024-01-01'
    GROUP BY 
        mt.TypeName
)
SELECT 
    MAINTENANCE_TYPE,
    VOLUME,
    ROUND(VOLUME / TOTAL_COUNT, 2) * 100 || '%' AS PERCENT_OF_TOTAL,
    ROUND(VOLUME / MAX_COUNT, 2) * 100 || '%' AS PERCENT_OF_MAX
FROM 
    MaintenanceStats
ORDER BY 
    RANK_BY_VOLUME;






--TASK 4
SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY MaintenanceDate) AS row_num,
        Maintenance.*
    FROM 
        Maintenance
    WHERE 
        MaintenanceDate BETWEEN date '2023-01-01' AND date '2024-01-01'
) 
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
        MaintenanceDate BETWEEN date '2023-01-01' AND date '2024-01-01'
)
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
    RentalStartDate >= ADD_MONTHS(SYSDATE, -6)
GROUP BY 
    Client
ORDER BY 
    Client;

--SUBTASK 6
SELECT 
    Client,
    TO_CHAR(RentalStartDate, 'YYYY-MM') AS month,
    SUM(TotalCost) AS total_payment
FROM 
    Bookings
INNER JOIN 
    Clients
    ON Bookings.Client = Clients.ClientID
WHERE 
    RentalStartDate >= ADD_MONTHS(SYSDATE, -6)
GROUP BY 
    Client,
    TO_CHAR(RentalStartDate, 'YYYY-MM')
ORDER BY 
    Client, month;


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