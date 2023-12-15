SET SERVEROUTPUT ON;

--TASK 1
CREATE OR REPLACE FUNCTION GetClientFullName(p_client_id NUMBER) RETURN VARCHAR2
IS
    FullName VARCHAR2(100);
BEGIN
    -- Получение полного имени клиента
    SELECT FirstName || ' ' || LastName
    INTO FullName
    FROM Clients
    WHERE ClientID = p_client_id;

    RETURN FullName;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('FullName: ' ||  GetClientFullName(2));
END;
/

CREATE OR REPLACE PROCEDURE CalculateTotalExpenses(p_client_id NUMBER) AS
    TotalExpenses NUMBER;
BEGIN
    -- Рассчет общей стоимости расходов для клиента
    SELECT SUM(Bookings.TotalCost)
    INTO TotalExpenses
    FROM Bookings
    WHERE Bookings.Client = p_client_id;

    -- Вывод результата (можно заменить на вашу логику)
    DBMS_OUTPUT.PUT_LINE('Total expenses for client ' || GetClientFullName(p_client_id) || ': ' || TotalExpenses);
END;
/

EXEC CalculateTotalExpenses(1);
/