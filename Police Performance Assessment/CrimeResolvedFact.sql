USE Crime;

CREATE TABLE CrimeResolvedFact (
FactID INT IDENTITY(1,1) PRIMARY KEY,
DateKey INT NOT NULL,
CrimeTypeID INT NOT NULL,
OutcomeTypeID INT NOT NULL,
DemographicGroupID INT NOT NULL,
PoliceForceID INT NOT NULL,
NumberReportedCrimes INT NOT NULL,
NumberCrimesResolved INT NULL,

CONSTRAINT FK_CrimeResolvedFact_Dim_Date FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey),
CONSTRAINT FK_CrimeResolvedFact_Dim_CrimeType FOREIGN KEY (CrimeTypeID) REFERENCES Dim_CrimeType(CrimeTypeID),
CONSTRAINT FK_CrimeResolvedFact_Dim_OutcomeType FOREIGN KEY (OutcomeTypeID) REFERENCES Dim_OutcomeType(OutcomeTypeID),
CONSTRAINT FK_CrimeResolvedFact_Dim_DemographicGroup FOREIGN KEY (DemographicGroupID) REFERENCES Dim_DemographicGroup(DemographicGroupID),
CONSTRAINT FK_CrimeResolvedFact_Dim_PoliceForce FOREIGN KEY (PoliceForceID) REFERENCES Dim_PoliceForce(PoliceForceID)
);

INSERT INTO dbo.CrimeResolvedFact (DateKey, CrimeTypeID, OutcomeTypeID, DemographicGroupID, PoliceForceID, NumberReportedCrimes, NumberCrimesResolved)
SELECT
d.DateKey,
ct.CrimeTypeID,
o.OutcomeTypeID,
dg.DemographicGroupID,
p.PoliceForceID,
COUNT(*) AS NumberReportedCrimes,
COUNT(CASE WHEN o.OutcomeTypeID IS NOT NULL THEN 1 END) AS NumberCrimesResolved
FROM dbo.Dim_Date d
JOIN dbo.CrimeFact c ON d.DateKey = c.DateKey
JOIN dbo.Dim_CrimeType ct ON ct.CrimeTypeID = c.CrimeTypeID
JOIN dbo.Dim_OutcomeType o ON o.OutcomeTypeID = c.OutcomeTypeID
JOIN dbo.Dim_DemographicGroup dg ON dg.DemographicGroupID = c.DemographicGroupID
JOIN dbo.Dim_PoliceForce p ON p.PoliceForceID = c.PoliceForceID
GROUP BY d.DateKey, ct.CrimeTypeID, o.OutcomeTypeID, dg.DemographicGroupID, p.PoliceForceID;
