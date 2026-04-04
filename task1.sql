create database TrainingPrograms;
Create table TrainingPrograms..employees ( 
EmployeeID Integer  primary key,
 FullName varchar(50),
 Gender varchar(50),
 DateOfBirth varchar(50),
 HireDate varchar(50),
 Department varchar(50),
 LocationEM varchar(50)

);
Create table TrainingPrograms..Training ( 
TrainingID  Integer  primary key,
 CourseName varchar(50),
 ProviderT varchar(50),
 DurationHours varchar(50),
 ScheduledDate varchar(50)

);
Create table TrainingPrograms..TrainingParticipation ( 
ParticipationID  Integer  primary key,
 CompletionStatus  varchar(50),
 FeedbackScore  integer,
 EmployeeID integer ,
 TrainingID integer ,
 CONSTRAINT TrainingID FOREIGN KEY (TrainingID )
        REFERENCES TrainingPrograms..Training(TrainingID),
CONSTRAINT EmployeeID FOREIGN KEY (EmployeeID )
        REFERENCES TrainingPrograms..employees(EmployeeID)
);
Create table TrainingPrograms..PerformanceReviews ( 
ReviewID   Integer  primary key,
 EmployeeID   integer,
 ReviewDate  integer,
 ReviewerName varchar ,
 PerformanceRating  integer ,
  Comments  varchar ,
CONSTRAINT FK_Employee_PerformanceReviews  FOREIGN KEY (EmployeeID )
        REFERENCES TrainingPrograms..employees(EmployeeID)
);
drop database test ;