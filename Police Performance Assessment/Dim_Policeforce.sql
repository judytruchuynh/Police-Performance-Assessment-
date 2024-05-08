USE Crime;

-- Create the Dim_PoliceForce table
CREATE TABLE Dim_PoliceForce (
    PoliceForceID INT PRIMARY KEY IDENTITY(1,1),
    Forcename VARCHAR(50) NOT NULL
);

-- Insert data into Dim_PoliceForce table from cleaned_force
INSERT INTO Dim_PoliceForce (Forcename)
SELECT REPLACE(["Falls_within"], ' Constabulary', '')
FROM street_cleaned
GROUP BY REPLACE(["Falls_within"], ' Constabulary', '');

-- Insert data into Dim_PoliceForce table from street_cleaned
INSERT INTO Dim_PoliceForce (Forcename)
SELECT ["Force_name"]
FROM cleaned_workforce
GROUP BY ["Force_name"];
