Use Crime;
CREATE TABLE CrimeFact (
    FactID INT IDENTITY(1,1) PRIMARY KEY,
    DateKey INT NOT NULL,
    CrimeTypeID INT NOT NULL,
    RegionID INT NOT NULL,
    PoliceForceID INT NOT NULL,
    NumberReportedCrimes INT NOT NULL,
    CONSTRAINT FK_CrimeFact_Dim_Date FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey),
    CONSTRAINT FK_CrimeFact_Dim_CrimeType FOREIGN KEY (CrimeTypeID) REFERENCES Dim_CrimeType(CrimeTypeID),
    CONSTRAINT FK_CrimeFact_Dim_Region FOREIGN KEY (RegionID) REFERENCES Dim_Region(RegionID),
    CONSTRAINT FK_CrimeFact_Dim_PoliceForce FOREIGN KEY (PoliceForceID) REFERENCES Dim_PoliceForce(PoliceForceID)
);
INSERT INTO dbo.CrimeFact (DateKey, CrimeTypeID, RegionID, PoliceForceID, NumberReportedCrimes)
SELECT DateKey, CrimeTypeID, RegionID, PoliceForceID, COUNT(*)
FROM dbo.Dim_Date 
INNER JOIN dbo.Dim_CrimeType ON DateKey = DateKey
INNER JOIN dbo.Dim_Region ON DateKey = DateKey AND CrimeTypeID = CrimeTypeID
INNER JOIN dbo.Dim_PoliceForce ON DateKey = DateKey AND CrimeTypeID = CrimeTypeID AND RegionID = RegionID
GROUP BY DateKey, CrimeTypeID, RegionID, PoliceForceID, YEAR(DATEFROMPARTS(Year, Month, 1)), MONTH(DATEFROMPARTS(Year, Month, 1));
