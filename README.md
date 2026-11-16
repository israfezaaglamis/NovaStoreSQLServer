
# NovaStore – E-Commerce Database Management System

NovaStore is a sample e-commerce database management project developed using **Microsoft SQL Server**. The project focuses on relational database design, data management, SQL queries, data analysis, and database backup operations.

## Project Overview

The database manages the core operations of an e-commerce platform, including customers, products, categories, orders, and order details.

The project demonstrates how relational tables are connected through primary and foreign keys and how SQL queries can be used to retrieve and analyze business data.

## Technologies Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL

## Database Structure

The project consists of five main tables:

| Table | Description |
|---|---|
| `Categories` | Stores product categories. |
| `Customers` | Stores customer information. |
| `Products` | Stores product details, prices, and stock quantities. |
| `Orders` | Stores customer order information. |
| `OrderDetails` | Stores products and quantities associated with each order. |

### Table Relationships

- `Products.CategoryID` → `Categories.CategoryID`
- `Orders.CustomerID` → `Customers.CustomerID`
- `OrderDetails.OrderID` → `Orders.OrderID`
- `OrderDetails.ProductID` → `Products.ProductID`

## Project Features

### 1. Database Design
- Relational database structure
- Primary key and foreign key relationships
- Data integrity through relational constraints

### 2. Data Management
- Creating database tables
- Inserting sample data
- Managing customer, product, category, and order records

### 3. SQL Queries and Analysis

The project includes SQL queries demonstrating:

- SELECT, WHERE, and ORDER BY
- INNER JOIN and LEFT JOIN
- Multi-table JOIN operations
- GROUP BY and aggregate functions
- COUNT and SUM
- DATEDIFF for date-based analysis
- Customer-based revenue analysis
- Product category analysis

### 4. Database View

A database view named `vw_SiparisOzet` was created to combine customer, order, product, and quantity information.

### 5. Database Backup

The project includes a full database backup operation using SQL Server's `BACKUP DATABASE` command.

## Sample Database Records

| Table | Number of Records |
|---|---:|
| Categories | 5 |
| Customers | 6 |
| Products | 12 |
| Orders | 10 |
| OrderDetails | 18 |

## Installation and Setup

1. Install Microsoft SQL Server.
2. Install SQL Server Management Studio (SSMS).
3. Clone or download this repository.
4. Open the `.sql` file in SSMS.
5. Connect to your SQL Server instance.
6. Execute the SQL script to create and populate the database.
7. Run the analysis queries to explore the database.

## Project Files

```text
NovaStoreDB_Project/
│
├── NovaStoreDB_Project.sql
├── README.md
└── Screenshots/
    ├── 03-multi-table-join.png
    ├── 04-category-product-analysis.png
    ├── 05-customer-revenue-analysis.png
    ├── 06-order-time-analysis.png
    ├── 07-view-siparis-ozet.png
    ├── 08-database-backup.png
    └── 09-final-database-check.png
```

## Purpose

This project was developed to practice relational database design and SQL Server operations through a practical e-commerce scenario. It demonstrates fundamental database development skills, data retrieval, reporting, and backup management.

---

**Project:** NovaStore – E-Commerce Database Management System  
**Database:** NovaStoreDB  
**Platform:** Microsoft SQL Server  
**Language:** T-SQL
