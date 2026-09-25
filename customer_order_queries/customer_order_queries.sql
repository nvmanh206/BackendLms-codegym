
USE QuanLySinhVien;

-- 1. TAO BANG

CREATE TABLE IF NOT EXISTS Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25),
    cAge TINYINT
);

CREATE TABLE IF NOT EXISTS `Order` (
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

CREATE TABLE IF NOT EXISTS Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25),
    pPrice INT
);

CREATE TABLE IF NOT EXISTS OrderDetail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);

-- 2. THEM DU LIEU (CHI CHAY MOT LAN)

INSERT INTO Customer VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

INSERT INTO `Order` VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

INSERT INTO Product VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

INSERT INTO OrderDetail VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);
SELECT
    oID,
    oDate,
    oTotalPrice AS oPrice
FROM `Order`;
SELECT DISTINCT
    c.cID,
    c.Name
FROM Customer c
INNER JOIN `Order` o
    ON c.cID = o.cID;
SELECT
    c.cID,
    c.Name,
    c.cAge
FROM Customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM `Order` o
    INNER JOIN OrderDetail od
        ON o.oID = od.oID
    WHERE o.cID = c.cID
);
SELECT
    o.oID,
    o.oDate,
    COALESCE(SUM(od.odQTY * p.pPrice), 0) AS oPrice
FROM `Order` o
LEFT JOIN OrderDetail od
    ON o.oID = od.oID
LEFT JOIN Product p
    ON od.pID = p.pID
GROUP BY o.oID, o.oDate
ORDER BY o.oID;