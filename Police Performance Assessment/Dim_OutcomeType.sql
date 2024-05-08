USE Crime;

CREATE TABLE Dim_OutcomeType (
    OutcomeTypeID INT IDENTITY(1,1) PRIMARY KEY,
    OutcomeType VARCHAR(255) NOT NULL
);

INSERT INTO Dim_OutcomeType (OutcomeType)
SELECT DISTINCT ["Outcome_type"]
FROM Outcomes_cleaned;
