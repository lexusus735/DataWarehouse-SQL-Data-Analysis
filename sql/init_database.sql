
/*
=============================================
Create Database and Schema
=============================================

Purpose:
    This script creates a new database named DataWarehouse after checking if it exists already
*/



-- drop and recreate if the database exist
-- run the drop and creat separately to avoid errors

--DROP DATABASE IF EXISTS DataWarehouse;

CREATE DATABASE DataWarehouse;

-- CREATE A SCHEME BRONE, SILVER GOLD
-- logical containers used to organize and group database objects like tables, vies, index, functions,sequence

CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

