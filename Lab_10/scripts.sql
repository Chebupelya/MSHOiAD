USE PLEASE;

exec sp_configure 'show advanced options', 1;
exec sp_configure 'clr enabled',1;
exec sp_configure 'clr strict security', 0
reconfigure

GO
DECLARE @result FLOAT;
EXEC dbo.CalculateAverageWithoutMinMax
    @values = '1,2,3,4,5,5',
    @result = @result OUTPUT;
SELECT @result AS Result;


GO
DECLARE @result FLOAT;
SELECT @result = dbo.CalculateAverageWithoutx('1,2,3,4,5,10,10');
SELECT @result AS Result;


CREATE TABLE PassportTable
(
    ID INT PRIMARY KEY,
    Passport PassportData
);
DROP TABLE PassportTable;

INSERT INTO PassportTable (ID, Passport) VALUES (2, 'AB 999999');

SELECT * FROM PassportTable;