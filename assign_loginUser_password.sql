USE AdventureWorksLT2022
CREATE LOGIN alex2 WITH PASSWORD = 'your-password'
CREATE USER alex2 FOR LOGIN 'username'
GRANT SELECT ON SCHEMA :: SalesLT TO 'username'
