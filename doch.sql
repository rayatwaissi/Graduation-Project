USE DocHub;
ALTER TABLE Categories
ALTER COLUMN CategoryType NVARCHAR(50) NOT NULL;
SELECT CategoryID, CategoryName, CategoryType
FROM dbo.Categories
WHERE CategoryType IS NULL;
UPDATE dbo.Categories
SET CategoryType =not n
WHERE CategoryType IS NULL;
ALTER TABLE dbo.Categories
ALTER COLUMN CategoryType NVARCHAR(50) NOT NULL;
SELECT CategoryID, CategoryName, CategoryType
FROM dbo.Categories
