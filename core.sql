-- =========================
-- Roles Table
-- =========================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Roles')
BEGIN
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL
);
END
GO

-- =========================
-- Departments Table
-- =========================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Departments')
BEGIN
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY IDENTITY(1,1),
    DeptName NVARCHAR(100) NOT NULL
);
END
GO

-- =========================
-- Programs Table
-- =========================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Programs')
BEGIN
CREATE TABLE Programs (
    ProgramID INT PRIMARY KEY IDENTITY(1,1),
    ProgramName NVARCHAR(100) NOT NULL,
    DeptID INT NOT NULL
);
END
GO

-- =========================
-- Categories Table
-- =========================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categories')
BEGIN
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    Type NVARCHAR(20) NOT NULL
);
END
GO

-- =========================
-- Users Table
-- =========================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    RoleID INT NOT NULL,
    DeptID INT NOT NULL
);
END
GO