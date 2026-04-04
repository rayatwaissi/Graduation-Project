use Hr;



CREATE TABLE HR..salaries (
salary_id INT PRIMARY KEY IDENTITY(1,1),

employee_id INT REFERENCES employees(employee_id) ,
start_date DATE NOT NULL,
end_date DATE,
salary DECIMAL(10,2) NOT NULL
);
CREATE TABLE HR..employees  (
  employee_id INT PRIMARY KEY IDENTITY(1,1) ,
first_name VARCHAR(50) NOT NULL ,
last_name VARCHAR(50) NOT NULL ,
 email VARCHAR(120) UNIQUE ,
 phone VARCHAR(40),
hire_date DATE NOT NULL,
department_id INT REFERENCES departments(department_id),
job_id INT REFERENCES jobs(job_id),
manager_id INT REFERENCES employees(employee_id),
);
CREATE TABLE HR..jobs  (
  job_id INT PRIMARY KEY IDENTITY(1,1), 
title VARCHAR(100) NOT NULL UNIQUE,
 min_salary DECIMAL(10,2) CHECK(min_salary >= 0),
max_salary DECIMAL(10,2) CHECK(max_salary >= min_salary)
);
