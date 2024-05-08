USE Crime;

CREATE TABLE Dim_ObjectType (
    ObjectTypeID INT IDENTITY(1,1) PRIMARY KEY,
    ObjectOfSearch VARCHAR(255) NOT NULL
);

INSERT INTO Dim_ObjectType (ObjectOfSearch)
SELECT DISTINCT ["Object_of_search"]
FROM Search_Cleaned;
