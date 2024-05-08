USE Crime;

CREATE TABLE Dim_SearchOutcome (
    SearchOutcomeID INT IDENTITY(1,1) PRIMARY KEY,
    Outcome VARCHAR(255) NOT NULL
);

INSERT INTO Dim_SearchOutcome (Outcome)
SELECT DISTINCT ["Outcome"]
FROM Search_Cleaned;
