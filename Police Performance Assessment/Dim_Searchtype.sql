USE Crime;

-- Create the Dim_SearchType table
CREATE TABLE Dim_SearchType (
    SearchTypeID INT PRIMARY KEY IDENTITY(1,1),
    SearchType VARCHAR(50) NOT NULL
);

-- Insert data into Dim_SearchType table from search_cleaned dataset
INSERT INTO Dim_SearchType (SearchType)
SELECT DISTINCT ["Type"]
FROM search_cleaned
WHERE ["Type"] NOT IN (SELECT SearchType FROM Dim_SearchType);
