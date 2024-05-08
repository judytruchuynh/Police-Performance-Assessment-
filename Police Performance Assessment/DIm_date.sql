USE Crime;

-- Create the Dim_Date table
CREATE TABLE Dim_Date (
    DateKey INT PRIMARY KEY, 
    Month INT NOT NULL, 
    Year INT NOT NULL
);

-- Insert data into Dim_Date table
DECLARE @date DATE = '2020-01-01';
DECLARE @dateKey INT = 202001;

WHILE @date <= '2023-12-31'
BEGIN
    INSERT INTO Dim_Date (DateKey, Month, Year)
    SELECT @dateKey, MONTH(@date), YEAR(@date);
    
    SET @date = DATEADD(month, 1, @date);
    SET @dateKey = YEAR(@date) * 100 + MONTH(@date);
END
