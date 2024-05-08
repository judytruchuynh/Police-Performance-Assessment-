USE Crime;

CREATE TABLE Dim_CrimeType (
    CrimeTypeID INT PRIMARY KEY,
    CrimeType VARCHAR(100) NOT NULL
);
-- Insert data into CrimeType Dimension table
INSERT INTO Dim_CrimeType (CrimeTypeID, CrimeType)
SELECT (SELECT COUNT(*) FROM Street_cleaned s2 WHERE s2.["Crime_type"] <= Street_cleaned.["Crime_type"]) AS Crime_type_id, Street_cleaned.["Crime_type"]
FROM Street_cleaned
GROUP BY Street_cleaned.["Crime_type"];
