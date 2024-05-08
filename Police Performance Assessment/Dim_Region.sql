USE Crime;

-- Create the Dim_Region table
CREATE TABLE Dim_Region (
    RegionID INT PRIMARY KEY IDENTITY(1,1),
    Region VARCHAR(50) NOT NULL,
    Location VARCHAR(50) NOT NULL
);

-- Insert data into Dim_Region table from street_cleaned dataset
INSERT INTO Dim_Region (Region, Location)
SELECT DISTINCT ISNULL('', 'NA'), ["Location_file"]
FROM street_cleaned
WHERE ["Location_file"] NOT IN (SELECT Location FROM Dim_Region);

-- Insert data into Dim_Region table from cleaned_forces dataset
INSERT INTO Dim_Region (Region, Location)
SELECT DISTINCT ["Region"], ["Force_name"]
FROM cleaned_workforce
WHERE ["Region"] NOT IN (SELECT Region FROM Dim_Region WHERE Region IS NOT NULL);
