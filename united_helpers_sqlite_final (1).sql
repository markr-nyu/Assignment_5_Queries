
-- Load with:
--   sqlite3 united_helpers.db
--   .read united_helpers_sqlite_final.sql

PRAGMA foreign_keys = OFF;

-------------------------------------------------------------------
-- Table: assignment
-------------------------------------------------------------------
DROP TABLE IF EXISTS assignment;

CREATE TABLE assignment (
  volunteerId INTEGER NOT NULL,
  taskCode INTEGER NOT NULL,
  startDateTime TEXT,
  endDateTime TEXT,
  PRIMARY KEY (volunteerId, taskCode),
  FOREIGN KEY (taskCode) REFERENCES task(taskCode), -- task reference
  FOREIGN KEY (volunteerId) REFERENCES volunteer(volunteerId) -- volunteer reference
);

INSERT INTO assignment VALUES
(1,101,'2021-07-01 09:00:00',NULL),
(2,105,'2021-08-02 09:00:00',NULL),
(3,103,'2021-05-01 09:00:00','2021-05-03 18:00:00'),
(3,106,'2021-07-25 12:00:00',NULL),
(4,103,'2021-05-01 09:00:00','2021-05-03 18:00:00'),
(4,108,'2021-08-02 09:00:00','2021-08-03 09:00:00'),
(5,107,NULL,NULL),
(7,101,'2020-11-01 09:00:00','2021-03-31 17:00:00'),
(7,102,'2021-08-01 12:00:00',NULL),
(8,102,'2021-08-01 12:00:00',NULL),
(9,109,'2021-08-04 07:00:00','2021-08-05 07:00:00');

-------------------------------------------------------------------
-- Table: item
-------------------------------------------------------------------
DROP TABLE IF EXISTS item;

CREATE TABLE item (
  itemId INTEGER PRIMARY KEY AUTOINCREMENT,
  itemDescription TEXT NOT NULL,
  itemValue REAL NOT NULL,
  quantityOnHand INTEGER NOT NULL
);

INSERT INTO item VALUES
(1,'can of spam',10,100),
(2,'dried fruit',5,50),
(3,'1 gallon water bottle',2,1000),
(4,'flashlight',20,500),
(5,'tent',100,1),
(6,'bottle of aspirin',150,375),
(7,'pack of bandages',20,1300),
(8,'bottle of antibiotics',125,100),
(9,'Baby formula',10,632),
(10,'mens coat',125,513),
(11,'womens coat',134,476),
(12,'sleeping bag',75,950);

-------------------------------------------------------------------
-- Table: package
-------------------------------------------------------------------
DROP TABLE IF EXISTS package;

CREATE TABLE package (
  packageId INTEGER PRIMARY KEY AUTOINCREMENT,
  taskCode INTEGER NOT NULL,
  packageTypeId INTEGER NOT NULL,
  packageCreateDate TEXT NOT NULL,
  packageWeight REAL NOT NULL,
  FOREIGN KEY (taskCode) REFERENCES task(taskCode), -- task reference
  FOREIGN KEY (packageTypeId) REFERENCES package_type(packageTypeId) -- type reference
);

INSERT INTO package VALUES
(1,102,3,'2019-08-02 00:00:00',32),
(2,102,3,'2019-08-02 00:00:00',34),
(3,102,2,'2019-08-03 00:00:00',54),
(4,102,4,'2019-08-03 00:00:00',132),
(5,105,5,'2019-08-05 00:00:00',68),
(6,103,2,'2019-05-05 00:00:00',55),
(7,106,3,'2019-07-27 00:00:00',103),
(8,106,3,'2019-07-29 00:00:00',102),
(9,106,3,'2019-07-31 00:00:00',103),
(10,109,5,'2019-08-04 00:00:00',79);

-------------------------------------------------------------------
-- Table: package_contents
-------------------------------------------------------------------
DROP TABLE IF EXISTS package_contents;

CREATE TABLE package_contents (
  itemId INTEGER NOT NULL,
  packageId INTEGER NOT NULL,
  itemQuantity INTEGER NOT NULL,
  PRIMARY KEY (itemId, packageId),
  FOREIGN KEY (itemId) REFERENCES item(itemId),
  FOREIGN KEY (packageId) REFERENCES package(packageId)
);

INSERT INTO package_contents VALUES
(1,1,2),(1,2,3),(2,2,23),(3,1,4),(3,2,3),(3,7,5),(3,8,6),
(3,9,6),(5,4,2),(9,3,10),(9,6,15),(10,5,6),(10,10,6),(11,5,5),(12,4,2);

-------------------------------------------------------------------
-- Table: package_type
-------------------------------------------------------------------
DROP TABLE IF EXISTS package_type;

CREATE TABLE package_type (
  packageTypeId INTEGER PRIMARY KEY AUTOINCREMENT,
  packageTypeName TEXT NOT NULL
);

INSERT INTO package_type VALUES
(1,'basic medical'),
(2,'child-care'),
(3,'food and water'),
(4,'shelter'),
(5,'clothing');

-------------------------------------------------------------------
-- Table: packing_list
-------------------------------------------------------------------
DROP TABLE IF EXISTS packing_list;

CREATE TABLE packing_list (
  packingListId INTEGER PRIMARY KEY AUTOINCREMENT,
  packingListName TEXT NOT NULL,
  packingListDescription TEXT NOT NULL
);

INSERT INTO packing_list VALUES
(1,'Major distribution','include all of the basic needs to help at least 1000 people'),
(2,'Additional food','Provide additional food to 100 people'),
(3,'Basic Medical','Contains basic medical supplies for 150 people after major catastrophe'),
(4,'Large water','Large shipment of water containers'),
(5,'Basic clothes','Basic clothes to support 20 families'),
(6,'Winter clothes','Coats and sweaters for 50 people'),
(7,'Burn kits','Special medical supplies for burn victims'),
(8,'Shelter kits','Tents, sleeping bags and blankets for 50 families'),
(9,'Basic Child care','Formula, clothes, toys for 50 children'),
(10,'Medium Water','Medium shipment of water containers');

-------------------------------------------------------------------
-- Table: task
-------------------------------------------------------------------
DROP TABLE IF EXISTS task;

CREATE TABLE task (
  taskCode INTEGER PRIMARY KEY AUTOINCREMENT,
  packingListId INTEGER,
  taskTypeId INTEGER NOT NULL,
  taskStatusId INTEGER NOT NULL,
  taskDescription TEXT NOT NULL,
  FOREIGN KEY (packingListId) REFERENCES packing_list(packingListId),
  FOREIGN KEY (taskStatusId) REFERENCES task_status(taskStatusId),
  FOREIGN KEY (taskTypeId) REFERENCES task_type(taskTypeId)
);

INSERT INTO task VALUES
(101,NULL,1,1,'Answer the telephone'),
(102,1,2,2,'Prepare 5000 packages'),
(103,9,2,3,'Prepare 20 childrens packages'),
(104,2,2,4,'Prepare 100 food packages'),
(105,5,2,2,'Prepare 50 clothing packages'),
(106,4,2,2,'Prepare 100 water packages'),
(107,NULL,3,4,'Transport packages to airport'),
(108,9,2,3,'Prepare 20 childrens packages'),
(109,5,2,3,'Prepare 80 clothing packages'),
(110,NULL,3,4,'Take packages to the warehouse');

-------------------------------------------------------------------
-- Table: task_status
-------------------------------------------------------------------
DROP TABLE IF EXISTS task_status;

CREATE TABLE task_status (
  taskStatusId INTEGER PRIMARY KEY AUTOINCREMENT,
  taskStatusName TEXT NOT NULL
);

INSERT INTO task_status VALUES
(1,'ongoing'),(2,'open'),(3,'closed'),(4,'pending');

-------------------------------------------------------------------
-- Table: task_type
-------------------------------------------------------------------
DROP TABLE IF EXISTS task_type;

CREATE TABLE task_type (
  taskTypeId INTEGER PRIMARY KEY AUTOINCREMENT,
  taskTypeName TEXT NOT NULL
);

INSERT INTO task_type VALUES
(1,'recurring'),(2,'packing'),(3,'transporting');

-------------------------------------------------------------------
-- Table: volunteer
-------------------------------------------------------------------
DROP TABLE IF EXISTS volunteer;

CREATE TABLE volunteer (
  volunteerId INTEGER PRIMARY KEY AUTOINCREMENT,
  volunteerName TEXT NOT NULL,
  volunteerAddress TEXT NOT NULL,
  volunteerTelephone TEXT
);

INSERT INTO volunteer VALUES
(1,'Harry Smith','123 Main St, New York, NY',NULL),
(2,'John Brown','876 Broadway, New York NY','212 555 1212'),
(3,'Joan Simmons','932 E 11st St, New Brunswick, NJ',NULL),
(4,'Chris Jordan','495 Blvd E, Edgewater, NJ','201 443 5734'),
(5,'George Brewer','1402 Main St, Westport, CT','203 323 5534'),
(6,'David Jones','20 Westbury Ave, Westbury NY','917 330 2201'),
(7,'Julie White','14 W 72nd St, New York, NY','212 756 4399'),
(8,'Gerry Banks','29 Highway 46, Wayne NJ','201 333 2232'),
(9,'Gene Lewin','45 Harlem Drive, Bronx, NY','917 452 8888'),
(10,'Sue Spencer','783 Fairfield Dr, Mahwah NJ','201 783 8837');

PRAGMA foreign_keys = ON;


