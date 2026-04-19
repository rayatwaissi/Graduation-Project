
use DocHub;
INSERT INTO Roles (RoleName) VALUES
('Dean'),                        -- العميد
('Vice Dean'),                   -- نائب العميد للكلية
('Vice Dean Student Affairs'),   -- نائب العميد لشؤون الطلبة
('Quality Office'),              -- مكتب الجودة
('Department Head'),             -- رئيس قسم
('Quality Liaison Officer'),     -- ضابط ارتباط الجودة
('Doctor')                       -- الدكاترة والموظفين


INSERT INTO Departments (DeptName) VALUES
('BIT'),
('AI'),
('CIS'),
('CS')
INSERT INTO Programs (ProgramName, DeptID) VALUES
-- BIT = 5
('B.Sc. in Business Information Technology', 5),
('M.Sc. in Business Information Technology', 5),

-- AI = 6
('B.Sc. in Artificial Intelligence', 6),

-- CIS = 7
('B.Sc. in Computer Information Systems', 7),
('M.Sc. in Computer Information Systems', 7),

-- CS = 8
('B.Sc. in Computer Science', 8),
('M.Sc. in Computer Science', 8),
('Ph.D. in Computer Science', 8)