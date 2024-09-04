CREATE DATABASE Shared_Workspace_v3 
GO
use shared_Workspace_v3
GO

CREATE TABLE Users (
    UserID INT IDENTITY PRIMARY KEY,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    ContactNumber VARCHAR(10) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Role VARCHAR(10) NOT NULL,
	CONSTRAINT chk_role CHECK (ROLE IN ('Owner', 'Coworker'))
);

CREATE TABLE Property (
    PID INT IDENTITY PRIMARY KEY,
    OID INT NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Neighborhood VARCHAR(50) NOT NULL,
    SquareFeet INT,
    ParkingGarage BIT NOT NULL,
    PublicTransportationAvailable BIT NOT NULL,
    FOREIGN KEY (OID) REFERENCES Users(UserID)
);
 
CREATE TABLE WorkSpace (
    WSID INT IDENTITY PRIMARY KEY,
    PID INT NOT NULL,
    Type VARCHAR(50) NOT NULL,
    Seats INT NOT NULL,
    SmokingAvailability BIT NOT NULL,
    DateAvailibility VARCHAR(10) NOT NULL,
    Price INT NOT NULL,
    FOREIGN KEY (PID) REFERENCES Property(PID)
);
 
 
CREATE TABLE UserPropertyTable(
UPID INT IDENTITY PRIMARY KEY,
UID INT NOT NULL,
PID INT NOT NULL,
FOREIGN KEY (UID) REFERENCES Users(UserID),
FOREIGN KEY (PID) REFERENCES Property(PID)
);

SET IDENTITY_INSERT USERS ON;
INSERT INTO Users (UserID, FirstName, LastName, ContactNumber, Email, Role) VALUES
('1','Arnold', 'Agcaoili', '4030271636', 'AJA@email.com', 'Owner'),
('2','Emiliano', 'Aguilar', '4032851904', 'AMA@email.com', 'Coworker'),
('3','Lance', 'Silva', '4032751749', 'LS@email.com', 'Coworker'),
('4','Tara', 'Sabbagh', '4039662875', 'TS@email.com', 'Coworker'),
('5','Tigist', 'Beshe', '4035671054', 'TB@email.com', 'Owner');
SET IDENTITY_INSERT USERS OFF;
GO

select * from users

CREATE TABLE LeaseTable (
    LID INT IDENTITY PRIMARY KEY,
    WSID INT NOT NULL,
    CID INT NOT NULL,
    Status VARCHAR(8) NOT NULL,
    LeaseTerm VARCHAR(10),
    Start DATE,
    [End] DATE,  -- 'End' is a reserved keyword, so it's wrapped in brackets
    PaymentMethod VARCHAR(20)
    FOREIGN KEY (WSID) REFERENCES WorkSpace(WSID),
    FOREIGN KEY (CID) REFERENCES Users(UserID)
    

);
 
SET IDENTITY_INSERT LeaseTable ON;
INSERT INTO LeaseTable (LID, WSID, CID, Status, LeaseTerm, Start, [End], PaymentMethod) VALUES

(1, 101, 3, 'OCCUPIED', '3weeks', '2024-01-01', '2024-01-21', 'Bank Transfer'),

(2, 102, 3, 'VACANT', '2months', '2024-02-01', '2024-04-01', 'Paypal'),

(8, 108, 2, 'OCCUPIED', '2months', '2024-08-01', '2024-10-01', 'Paypal'),

(10, 110, 3, 'OCCUPIED', '3weeks', '2024-10-01', '2024-10-21', 'Bank Transfer'),

(12, 112, 3, 'OCCUPIED', '1year', '2024-12-01', '2025-12-01', 'Cash');
SET IDENTITY_INSERT LeaseTable OFF;
GO

SET IDENTITY_INSERT Property ON;
INSERT INTO Property (PID, OID, Address, Neighborhood, SquareFeet, ParkingGarage, PublicTransportationAvailable) VALUES 

    (1, 1, '456 Sunvalley Blvd', 'Chapparal', 920, 0, 1),
    (2, 1, '365 Bowvalley Ave', 'Downtown', 1250, 1, 1),
	(3, 5, '789 Elm St', 'Greenwood', 1400, 1, 0),
    (4, 1, '123 Maple Ave', 'Riverbend', 1100, 0, 1),
    (5, 5, '654 Oak Dr', 'Hilltop', 950, 1, 0);


SET IDENTITY_INSERT Property OFF;
GO

SET IDENTITY_INSERT Workspace ON;
INSERT INTO WorkSpace (WSID, PID, Type, Seats, SmokingAvailability, DateAvailibility, Price) VALUES 

    (101, 2, 'Office', 10, 0, '2024-07-01', 530),

    (110, 5, 'Conference Room', 20, 1, '2024-05-27', 1250),

	(112, 3, 'Office', 8, 0, '2024-06-15', 700),

    (102, 4, 'Conference Room', 15, 1, '2024-07-10', 1100),

    (108, 1, 'Meeting Room', 12, 0, '2024-06-20', 900);


SET IDENTITY_INSERT WorkSpace OFF;
GO
SET IDENTITY_INSERT UserPropertyTable ON
INSERT INTO UserPropertyTable (UPID, UID, PID) VALUES 

    (1, 1, 1),

    (2, 1, 1),

	(3, 3, 5),


	(4, 4, 1),

	(5, 5, 5)

 SET IDENTITY_INSERT UserPropertyTable OFF;

 GO
 select * from WorkSpace


 --Queries

 use Shared_Workspace_v3

 --Show Users Last name, address and contact number along with the Properties they own or co-work
 SELECT
    U.LastName, U.ContactNumber, P.Address
FROM Users U
JOIN UserPropertyTable UP ON U.UserID = UP.UID
JOIN Property P ON UP.PID = P.PID;

--Get all property address, neighborhood, sqrft and price that are available for lease (VACANT)
SELECT
    P.Address, P.Neighborhood, P.SquareFeet, WS.Price
FROM Property P
JOIN WorkSpace WS ON P.PID = WS.PID
JOIN LeaseTable L ON WS.WSID = L.WSID
WHERE (L.Status = 'VACANT');

--Get all Lease details for User 3
SELECT
    LID, WSID, CID, Status, LeaseTerm, Start, [End], PaymentMethod
FROM LeaseTable
WHERE (CID = 3);

-- Return a list of OCCUPIED properties with a lease term that's more than 3weeks
SELECT LID, Status, LeaseTerm
FROM LeaseTable
WHERE Status = 'Occupied'
AND DATEDIFF(day, [Start], [End]) > 21;

 
-- Return all properties that offers parking garage
SELECT Address, Neighborhood, ParkingGarage
FROM Property
WHERE ParkingGarage = 1;

