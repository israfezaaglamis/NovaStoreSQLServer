/* ============================================================================
   NOVASTORE E-TİCARET VERİ YÖNETİM SİSTEMİ
   ----------------------------------------------------------------------------
   Hazırlayan : İsra feza Ağlamış
   Platform   : Microsoft SQL Server (T-SQL) - SQL Server Management Studio
   Kapsam     : Bölüm 1 (DDL)  - veri tabanı ve tablolar
                Bölüm 2 (DML)  - örnek veri girişi
                Bölüm 3 (DQL)  - 6 rapor sorgusu
                Bölüm 4        - VIEW ve BACKUP
  
   ============================================================================ */

-- TEMİZLİK (yalnızca yeniden çalıştırmak için; normalde yorumda kalır)
-- USE master;
-- GO
-- ALTER DATABASE NovaStoreDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- DROP DATABASE NovaStoreDB;
-- GO

-- ##########################################################################
-- BÖLÜM 1: VERİ TABANI TASARIMI (DDL)
-- ##########################################################################

-- Bölüm 1 / Görev 1 - Veri tabanı oluşturma
USE master;
GO

-- Turkish_CI_AS: varchar kolonlarda ı, ğ, ş, İ gibi harfler bozulmasın diye.
CREATE DATABASE NovaStoreDB COLLATE Turkish_CI_AS;
GO

USE NovaStoreDB;
GO

-- Bölüm 1 / Görev 2-A - Categories tablosu
CREATE TABLE Categories (
    CategoryID   int         IDENTITY(1,1) NOT NULL,
    CategoryName varchar(50) NOT NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (CategoryID)
);
GO

-- Bölüm 1 / Görev 2-C - Customers tablosu
CREATE TABLE Customers (
    CustomerID int          IDENTITY(1,1) NOT NULL,
    FullName   varchar(50),
    City       varchar(20),
    Email      varchar(100),
    CONSTRAINT PK_Customers       PRIMARY KEY (CustomerID),
    CONSTRAINT UQ_Customers_Email UNIQUE (Email)
);
GO

-- Bölüm 1 / Görev 2-B - Products tablosu
CREATE TABLE Products (
    ProductID   int           IDENTITY(1,1) NOT NULL,
    ProductName varchar(100)  NOT NULL,
    Price       decimal(10,2),
    Stock       int           CONSTRAINT DF_Products_Stock DEFAULT 0,
    CategoryID  int,
    CONSTRAINT PK_Products            PRIMARY KEY (ProductID),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID)
        REFERENCES Categories (CategoryID)
);
GO

-- Bölüm 1 / Görev 2-D - Orders tablosu
CREATE TABLE Orders (
    OrderID     int           IDENTITY(1,1) NOT NULL,
    CustomerID  int,
    OrderDate   datetime      CONSTRAINT DF_Orders_OrderDate DEFAULT GETDATE(),
    TotalAmount decimal(10,2),
    CONSTRAINT PK_Orders           PRIMARY KEY (OrderID),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
        REFERENCES Customers (CustomerID)
);
GO

-- Bölüm 1 / Görev 2-E - OrderDetails (ara tablo)
CREATE TABLE OrderDetails (
    DetailID  int IDENTITY(1,1) NOT NULL,
    OrderID   int,
    ProductID int,
    Quantity  int,
    CONSTRAINT PK_OrderDetails          PRIMARY KEY (DetailID),
    CONSTRAINT FK_OrderDetails_Orders   FOREIGN KEY (OrderID)
        REFERENCES Orders (OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID)
        REFERENCES Products (ProductID)
);
GO

-- ##########################################################################
-- BÖLÜM 2: VERİ GİRİŞİ (DML - INSERT)
-- ##########################################################################

-- Bölüm 2 / Görev 1 - 5 kategori
INSERT INTO Categories (CategoryName)
VALUES
    ('Elektronik'),
    ('Giyim'),
    ('Kitap'),
    ('Kozmetik'),
    ('Ev ve Yaşam');
GO

-- Bölüm 2 / Görev 2 - 12 ürün (her kategoriye en az 2)
INSERT INTO Products (ProductName, Price, Stock, CategoryID)
VALUES
    ('Akıllı Telefon', 18999.90, 25, 1),  -- Elektronik
    ('Kablosuz Kulaklık', 1499.50, 12, 1),  -- Elektronik
    ('Dizüstü Bilgisayar', 32999.00, 8, 1),  -- Elektronik
    ('Erkek Mont', 1899.00, 40, 2),  -- Giyim
    ('Kadın Spor Ayakkabı', 1299.90, 18, 2),  -- Giyim
    ('Suç ve Ceza', 120.00, 60, 3),  -- Kitap
    ('SQL Server Rehberi', 275.00, 30, 3),  -- Kitap
    ('Nemlendirici Krem', 189.90, 75, 4),  -- Kozmetik
    ('Parfüm', 899.00, 14, 4),  -- Kozmetik
    ('Çay Seti', 649.00, 22, 5),  -- Ev ve Yaşam
    ('LED Masa Lambası', 349.90, 9, 5),  -- Ev ve Yaşam
    ('Kahve Makinesi', 2499.00, 17, 5);  -- Ev ve Yaşam
GO

-- Bölüm 2 / Görev 3 - 6 müşteri
INSERT INTO Customers (FullName, City, Email)
VALUES
    ('Ahmet Yılmaz', 'İstanbul', 'ahmet.yilmaz@novamail.com'),
    ('Ayşe Demir', 'Ankara', 'ayse.demir@novamail.com'),
    ('Mehmet Kaya', 'İzmir', 'mehmet.kaya@novamail.com'),
    ('Elif Şahin', 'Bursa', 'elif.sahin@novamail.com'),
    ('Can Öztürk', 'Antalya', 'can.ozturk@novamail.com'),
    ('Zeynep Arslan', 'Ankara', 'zeynep.arslan@novamail.com');
GO

-- Bölüm 2 / Görev 4 - 10 sipariş (farklı tarihlerde)
-- Tarihler 'yyyymmdd hh:mm:ss' biçimindedir; bu biçim SQL Server dil ayarından etkilenmez.
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
    (1, '20260112 10:15:00', 1739.50),  -- Sipariş 1: Ahmet Yılmaz
    (2, '20260203 14:40:00', 3198.90),  -- Sipariş 2: Ayşe Demir
    (3, '20260221 09:05:00', 32999.00),  -- Sipariş 3: Mehmet Kaya
    (1, '20260315 18:22:00', 18999.90),  -- Sipariş 4: Ahmet Yılmaz
    (4, '20260409 11:30:00', 1278.80),  -- Sipariş 5: Elif Şahin
    (5, '20260527 16:45:00', 3148.00),  -- Sipariş 6: Can Öztürk
    (2, '20260714 13:10:00', 974.80),  -- Sipariş 7: Ayşe Demir
    (6, '20260902 20:05:00', 2599.80),  -- Sipariş 8: Zeynep Arslan
    (3, '20261008 12:00:00', 1774.50),  -- Sipariş 9: Mehmet Kaya
    (4, '20261103 15:35:00', 1118.90);  -- Sipariş 10: Elif Şahin
GO

-- Bölüm 2 / Görev 4 - Sipariş detayları (18 satır)
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES
    (1, 2, 1),  -- Sipariş 1: Kablosuz Kulaklık x1
    (1, 6, 2),  -- Sipariş 1: Suç ve Ceza x2
    (2, 4, 1),  -- Sipariş 2: Erkek Mont x1
    (2, 5, 1),  -- Sipariş 2: Kadın Spor Ayakkabı x1
    (3, 3, 1),  -- Sipariş 3: Dizüstü Bilgisayar x1
    (4, 1, 1),  -- Sipariş 4: Akıllı Telefon x1
    (5, 8, 2),  -- Sipariş 5: Nemlendirici Krem x2
    (5, 9, 1),  -- Sipariş 5: Parfüm x1
    (6, 12, 1),  -- Sipariş 6: Kahve Makinesi x1
    (6, 10, 1),  -- Sipariş 6: Çay Seti x1
    (7, 7, 1),  -- Sipariş 7: SQL Server Rehberi x1
    (7, 11, 2),  -- Sipariş 7: LED Masa Lambası x2
    (8, 5, 2),  -- Sipariş 8: Kadın Spor Ayakkabı x2
    (9, 2, 1),  -- Sipariş 9: Kablosuz Kulaklık x1
    (9, 7, 1),  -- Sipariş 9: SQL Server Rehberi x1
    (10, 11, 1),  -- Sipariş 10: LED Masa Lambası x1
    (10, 10, 1),  -- Sipariş 10: Çay Seti x1
    (10, 6, 1);  -- Sipariş 10: Suç ve Ceza x1
GO

-- Bölüm 2 - Veri girişi kontrolü (tablo başına kayıt sayısı)
SELECT 'Categories'   AS Tablo, COUNT(*) AS KayitSayisi FROM Categories
UNION ALL SELECT 'Products',     COUNT(*) FROM Products
UNION ALL SELECT 'Customers',    COUNT(*) FROM Customers
UNION ALL SELECT 'Orders',       COUNT(*) FROM Orders
UNION ALL SELECT 'OrderDetails', COUNT(*) FROM OrderDetails;
GO

-- ##########################################################################
-- BÖLÜM 3: SORGULAMA VE ANALİZ (DQL)
-- ##########################################################################

-- Bölüm 3 / Soru 1 - Temel listeleme (SELECT, WHERE, ORDER BY)
SELECT ProductName, Stock
FROM   Products
WHERE  Stock < 20
ORDER BY Stock DESC;

-- Bölüm 3 / Soru 2 - Veri birleştirme (INNER JOIN)
SELECT c.FullName    AS MusteriAdi,
       c.City        AS Sehir,
       o.OrderDate   AS SiparisTarihi,
       o.TotalAmount AS ToplamTutar
FROM   Customers AS c
       INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate;

-- Bölüm 3 / Soru 3 - Çoklu birleştirme (5 tablo zincirleme JOIN)
SELECT c.FullName       AS MusteriAdi,
       p.ProductName    AS UrunAdi,
       p.Price          AS Fiyat,
       cat.CategoryName AS Kategori
FROM   Customers AS c
       INNER JOIN Orders       AS o   ON o.CustomerID    = c.CustomerID
       INNER JOIN OrderDetails AS od  ON od.OrderID      = o.OrderID
       INNER JOIN Products     AS p   ON p.ProductID     = od.ProductID
       INNER JOIN Categories   AS cat ON cat.CategoryID  = p.CategoryID
WHERE  c.FullName = 'Ahmet Yılmaz'
ORDER BY o.OrderDate, p.ProductName;

-- Bölüm 3 / Soru 4 - Gruplama ve aggregate (GROUP BY, COUNT, LEFT JOIN)
SELECT cat.CategoryName    AS Kategori,
       COUNT(p.ProductID)  AS UrunSayisi
FROM   Categories AS cat
       LEFT JOIN Products AS p ON p.CategoryID = cat.CategoryID
GROUP BY cat.CategoryName
ORDER BY UrunSayisi DESC, cat.CategoryName;

-- Bölüm 3 / Soru 5 - Ciro analizi (SUM, GROUP BY, ORDER BY)
SELECT c.FullName          AS MusteriAdi,
       SUM(o.TotalAmount)  AS ToplamCiro
FROM   Customers AS c
       INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FullName
ORDER BY ToplamCiro DESC;

-- Bölüm 3 / Soru 6 - Zaman analizi (DATEDIFF, GETDATE)
SELECT o.OrderID   AS SiparisNo,
       c.FullName  AS MusteriAdi,
       o.OrderDate AS SiparisTarihi,
       DATEDIFF(DAY, o.OrderDate, GETDATE()) AS GecenGun
FROM   Orders AS o
       INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate;

-- ##########################################################################
-- BÖLÜM 4: İLERİ SEVİYE NESNELER
-- ##########################################################################

-- Bölüm 4 / Görev 1 - View oluşturma (vw_SiparisOzet)
CREATE VIEW vw_SiparisOzet AS
SELECT c.FullName    AS MusteriAdi,
       o.OrderDate   AS SiparisTarihi,
       p.ProductName AS UrunAdi,
       od.Quantity   AS Adet
FROM   Customers AS c
       INNER JOIN Orders       AS o  ON o.CustomerID = c.CustomerID
       INNER JOIN OrderDetails AS od ON od.OrderID   = o.OrderID
       INNER JOIN Products     AS p  ON p.ProductID  = od.ProductID;
GO

-- Bölüm 4 / Görev 1 - View'in kullanımı
-- ORDER BY view'in içinde değil, view'i çağıran sorguda yazılır.
SELECT *
FROM   vw_SiparisOzet
ORDER BY SiparisTarihi, MusteriAdi;

-- Bölüm 4 / Görev 2 - Yedekleme (BACKUP DATABASE)
-- C:\Yedek\ klasörü yoksa oluşturur (varsa hata vermez).
EXEC master.sys.xp_create_subdir N'C:\Yedek\';
GO

BACKUP DATABASE NovaStoreDB
TO DISK = N'C:\Yedek\NovaStoreDB.bak'
WITH FORMAT, INIT,
     NAME  = N'NovaStoreDB - Tam Yedek',
     STATS = 10;
GO
