USE Crime;

-- Create the Dim_EthnicGroup table
CREATE TABLE Dim_EthnicGroup (
    EthnicGroupID INT PRIMARY KEY IDENTITY(1,1),
    EthnicGroup VARCHAR(50) NOT NULL
);

-- Insert data into Dim_EthnicGroup table from cleaned_workforce dataset
INSERT INTO Dim_EthnicGroup (EthnicGroup)
SELECT DISTINCT ["Self_defined_ethnicity"]
FROM search_cleaned
WHERE ["Self_defined_ethnicity"] IS NOT NULL AND ["Self_defined_ethnicity"] NOT IN (SELECT EthnicGroup FROM Dim_EthnicGroup);
