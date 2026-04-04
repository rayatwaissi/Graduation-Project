-- ═══════════════════════════════════════
-- DocHub Database - Complete Script
-- KASIT · University of Jordan · 2025
-- ═══════════════════════════════════════

USE DocHub;
GO

USE DocHub;
GO

-- ─────────────────────────────────────
-- 1. ROLES
-- ─────────────────────────────────────
CREATE TABLE Roles (
    RoleID      INT IDENTITY(1,1) PRIMARY KEY,
    RoleName    NVARCHAR(50) NOT NULL
);
GO

-- Seed Data
INSERT INTO Roles (RoleName) VALUES
('Dean'),
('Vice Dean'),
('QA Officer'),
('Liaison Officer'),
('Staff');
GO

-- ─────────────────────────────────────
-- 2. DEPARTMENTS
-- ─────────────────────────────────────
CREATE TABLE Departments (
    DeptID      INT IDENTITY(1,1) PRIMARY KEY,
    DeptName    NVARCHAR(100) NOT NULL
);
GO

-- Seed Data
INSERT INTO Departments (DeptName) VALUES
('Computer Science'),
('Computer Information Systems'),
('Business Information Technology'),
('Artificial Intelligence');
GO

-- ─────────────────────────────────────
-- 3. PROGRAMS
-- ─────────────────────────────────────
CREATE TABLE Programs (
    ProgramID       INT IDENTITY(1,1) PRIMARY KEY,
    ProgramName     NVARCHAR(100) NOT NULL,
    DeptID          INT NOT NULL,

    CONSTRAINT FK_Programs_Dept
        FOREIGN KEY (DeptID)
        REFERENCES Departments(DeptID)
);
GO

-- Seed Data
INSERT INTO Programs (ProgramName, DeptID) VALUES
-- CS (DeptID = 1)
('Bachelor in Computer Science',       1),
('Bachelor in Cyber Security',         1),
('Master in Computer Science',         1),
('PhD in Computer Science',            1),
-- CIS (DeptID = 2)
('Bachelor in Computer Information Systems', 2),
('Master in Information Systems',      2),
-- AI (DeptID = 3)  
('Bachelor in Artificial Intelligence',3),
('Bachelor in Data Science',           3),
-- BIT (DeptID = 4)
('Bachelor in Business IT',            4),
('Master in E-Government',             4),
('Master in Network Intelligence',     4);
GO

-- ─────────────────────────────────────
-- 4. CATEGORIES
-- ─────────────────────────────────────
CREATE TABLE Categories (
    CategoryID      INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName    NVARCHAR(100) NOT NULL
);
GO

-- Seed Data
INSERT INTO Categories (CategoryName) VALUES
(N'محاضر اجتماعات'),
(N'أقسام مجالس الكلية'),
(N'قرارات'),
(N'إحصائيات'),
(N'استبانات');
GO

-- ─────────────────────────────────────
-- 5. USERS
-- ─────────────────────────────────────
CREATE TABLE Users (
    UserID          INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(100)   NOT NULL,
    Email           NVARCHAR(150)   NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255)   NOT NULL,
    RoleID          INT             NOT NULL,
    DeptID          INT             NULL,
        -- NULL for Dean / Vice Dean / QA Officer
    IsActive        BIT             NOT NULL DEFAULT 1,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Users_Role
        FOREIGN KEY (RoleID)
        REFERENCES Roles(RoleID),

    CONSTRAINT FK_Users_Dept
        FOREIGN KEY (DeptID)
        REFERENCES Departments(DeptID)
);
GO

-- ─────────────────────────────────────
-- 6. DOCUMENTS
-- ─────────────────────────────────────
CREATE TABLE Documents (
    DocumentID      INT IDENTITY(1,1) PRIMARY KEY,
    DocumentName    NVARCHAR(200)   NOT NULL,
    FileType        NVARCHAR(20)    NOT NULL,
        -- PDF / Word / Excel / Image / Form / Other
    FilePath        NVARCHAR(500)   NULL,
        -- NULL if FileType = Form
    ExternalLink    NVARCHAR(500)   NULL,
        -- NULL if FileType != Form
    DeptID          INT             NOT NULL,
    ProgramID       INT             NULL,
        -- NULL = whole department
    CategoryID      INT             NOT NULL,
    AcademicYear    NVARCHAR(20)    NULL,
    Description     NVARCHAR(500)   NULL,
    ExtractedText   NVARCHAR(MAX)   NULL,
    CurrentVersion  INT             NOT NULL DEFAULT 1,
    IsPublic        BIT             NOT NULL DEFAULT 0,
    IsDeleted       BIT             NOT NULL DEFAULT 0,
    UploadedBy      INT             NOT NULL,
    DeletedBy       INT             NULL,
    DeletedAt       DATETIME        NULL,
    UploadDate      DATETIME        NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Documents_Dept
        FOREIGN KEY (DeptID)
        REFERENCES Departments(DeptID),

    CONSTRAINT FK_Documents_Program
        FOREIGN KEY (ProgramID)
        REFERENCES Programs(ProgramID),

    CONSTRAINT FK_Documents_Category
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID),

    CONSTRAINT FK_Documents_UploadedBy
        FOREIGN KEY (UploadedBy)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Documents_DeletedBy
        FOREIGN KEY (DeletedBy)
        REFERENCES Users(UserID)
);
GO

-- ─────────────────────────────────────
-- 7. DOCUMENT_VERSIONS
-- ─────────────────────────────────────
CREATE TABLE Document_Versions (
    VersionID       INT IDENTITY(1,1) PRIMARY KEY,
    DocumentID      INT             NOT NULL,
    VersionNumber   INT             NOT NULL,
    FilePath        NVARCHAR(500)   NOT NULL,
    EditedBy        INT             NOT NULL,
    EditComment     NVARCHAR(300)   NOT NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Versions_Document
        FOREIGN KEY (DocumentID)
        REFERENCES Documents(DocumentID),

    CONSTRAINT FK_Versions_EditedBy
        FOREIGN KEY (EditedBy)
        REFERENCES Users(UserID)
);
GO

-- ─────────────────────────────────────
-- 8. DOCUMENT_TASKS
-- ─────────────────────────────────────
CREATE TABLE Document_Tasks (
    TaskID              INT IDENTITY(1,1) PRIMARY KEY,
    RequestedDocName    NVARCHAR(200)   NOT NULL,
    Instructions        NVARCHAR(500)   NOT NULL,
    Deadline            DATETIME        NOT NULL,
    ReminderEvery       INT             NOT NULL,
        -- number of days between reminders
    MicrosoftFormLink   NVARCHAR(500)   NULL,
    DeptID              INT             NOT NULL,
    ProgramID           INT             NULL,
        -- NULL = whole department
    CreatedBy           INT             NOT NULL,
    CreatedAt           DATETIME        NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Tasks_Dept
        FOREIGN KEY (DeptID)
        REFERENCES Departments(DeptID),

    CONSTRAINT FK_Tasks_Program
        FOREIGN KEY (ProgramID)
        REFERENCES Programs(ProgramID),

    CONSTRAINT FK_Tasks_CreatedBy
        FOREIGN KEY (CreatedBy)
        REFERENCES Users(UserID)
);
GO

-- ─────────────────────────────────────
-- 9. TASK_ASSIGNEES
-- ─────────────────────────────────────
CREATE TABLE Task_Assignees (
    AssigneeID      INT IDENTITY(1,1) PRIMARY KEY,
    TaskID          INT             NOT NULL,
    UserID          INT             NOT NULL,
    CanRead         BIT             NOT NULL DEFAULT 0,
    CanUpload       BIT             NOT NULL DEFAULT 0,
    CanEdit         BIT             NOT NULL DEFAULT 0,
    Status          NVARCHAR(20)    NOT NULL DEFAULT 'Pending',
        -- Pending / Done
    UploadedDocID   INT             NULL,
    LastReminderAt  DATETIME        NULL,
    CompletedAt     DATETIME        NULL,

    CONSTRAINT FK_Assignees_Task
        FOREIGN KEY (TaskID)
        REFERENCES Document_Tasks(TaskID),

    CONSTRAINT FK_Assignees_User
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Assignees_UploadedDoc
        FOREIGN KEY (UploadedDocID)
        REFERENCES Documents(DocumentID)
);
GO

-- ─────────────────────────────────────
-- 10. NOTIFICATIONS
-- ─────────────────────────────────────
CREATE TABLE Notifications (
    NotificationID  INT IDENTITY(1,1) PRIMARY KEY,
    UserID          INT             NOT NULL,
    AssigneeID      INT             NOT NULL,
    Message         NVARCHAR(300)   NOT NULL,
    Type            NVARCHAR(20)    NOT NULL,
        -- NewTask / Reminder
    IsRead          BIT             NOT NULL DEFAULT 0,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Notifications_User
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Notifications_Assignee
        FOREIGN KEY (AssigneeID)
        REFERENCES Task_Assignees(AssigneeID)
);
GO
ALTER TABLE Task_Assignees
DROP COLUMN LastReminderAt;
ALTER TABLE Users
DROP COLUMN IsActive;
SELECT name 
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('Users')
AND COL_NAME(parent_object_id, parent_column_id) = 'IsActive';
ALTER TABLE Users
DROP CONSTRAINT DF__Users__IsActive__5441852A;
ALTER TABLE Users
DROP COLUMN IsActive;
ALTER TABLE Users
DROP COLUMN CreatedAt;
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql += 'ALTER TABLE Users DROP CONSTRAINT ' + dc.name + ';' + CHAR(13)
FROM sys.default_constraints dc
JOIN sys.columns c 
    ON dc.parent_object_id = c.object_id 
    AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('Users')
AND c.name IN ('CreatedAt');

EXEC(@sql);

ALTER TABLE Users
DROP COLUMN  CreatedAt;
ALTER TABLE Categories
ADD CategoryType NVARCHAR(50) NULL;
ALTER TABLE Document_Versions
ALTER COLUMN EditComment NVARCHAR(MAX) NULL;
ALTER TABLE Task_Assignees
ALTER COLUMN UploadedDocID INT NOT NULL;