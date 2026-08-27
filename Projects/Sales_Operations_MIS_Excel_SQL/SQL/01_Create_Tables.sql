-- PROJECT 1: Sales & Operations MIS
-- SQL Server compatible starter script

CREATE DATABASE SalesOperationsMIS;
GO
USE SalesOperationsMIS;
GO

CREATE TABLE Customers (
    Customer_ID VARCHAR(20) PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Gender VARCHAR(20),
    Age INT,
    Age_Group VARCHAR(20),
    City VARCHAR(50),
    State VARCHAR(50),
    Region VARCHAR(20),
    Customer_Segment VARCHAR(50),
    Customer_Since DATE
);

CREATE TABLE Products (
    Product_ID VARCHAR(20) PRIMARY KEY,
    Product_Name VARCHAR(150),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Brand VARCHAR(50),
    Standard_Cost DECIMAL(18,2),
    Selling_Price DECIMAL(18,2)
);

CREATE TABLE Salespersons (
    Salesperson_ID VARCHAR(20) PRIMARY KEY,
    Salesperson_Name VARCHAR(100),
    Region VARCHAR(20),
    Manager VARCHAR(100),
    Joining_Date DATE,
    Monthly_Target DECIMAL(18,2)
);

CREATE TABLE Sales (
    Order_ID VARCHAR(30) PRIMARY KEY,
    Order_Date DATE,
    Customer_ID VARCHAR(20),
    Product_ID VARCHAR(20),
    Salesperson_ID VARCHAR(20),
    Region VARCHAR(20),
    City VARCHAR(50),
    Quantity INT,
    Unit_Price DECIMAL(18,2),
    Discount DECIMAL(8,4),
    Revenue DECIMAL(18,2),
    Cost DECIMAL(18,2),
    Profit DECIMAL(18,2),
    Payment_Mode VARCHAR(30),
    Order_Status VARCHAR(30)
);

CREATE TABLE Monthly_Targets (
    Salesperson_ID VARCHAR(20),
    Target_Month DATE,
    Monthly_Target DECIMAL(18,2)
);
