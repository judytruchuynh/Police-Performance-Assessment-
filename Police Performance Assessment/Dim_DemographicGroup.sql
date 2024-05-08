USE Crime;

-- Create the DemographicGroup dimension table
CREATE TABLE Dim_DemographicGroup (
    DemographicGroupID INT PRIMARY KEY IDENTITY(1,1),
    DemographicGroup VARCHAR(50) NOT NULL
);

-- Insert data into Dim_DemographicGroup table
INSERT INTO Dim_DemographicGroup (DemographicGroup)
SELECT DISTINCT ["Sex"]
FROM cleaned_workforce;
