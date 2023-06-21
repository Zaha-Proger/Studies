USE sample; 

CREATE TABLE department(dept_no CHAR(4) NOT NULL, 
dept_name CHAR(25) NOT NULL, 
location CHAR(30) NULL, 
CONSTRAINT prim_dept PRIMARY KEY (dept_no)); 

CREATE TABLE employee (emp_no INTEGER NOT NULL, 
emp_fname CHAR(20) NOT NULL, 
emp_lname CHAR(20) NOT NULL, 
dept_no CHAR(4) NULL, 
CONSTRAINT prim_emp PRIMARY KEY (emp_no), 
CONSTRAINT foreign_emp FOREIGN KEY(dept_no) REFERENCES 
department(dept_no)); 

CREATE TABLE project (project_no CHAR(4) NOT NULL, 
project_name CHAR(15) NOT NULL, 
budget FLOAT NULL, 
CONSTRAINT prim_proj PRIMARY KEY (project_no)); 

CREATE TABLE works_on (emp_no INTEGER NOT NULL, 
project_no CHAR(4) NOT NULL, 
job CHAR (15) NULL, 
enter_date DATE NULL, 
CONSTRAINT prim_works PRIMARY KEY(emp_no, project_no), 
CONSTRAINT foreign1_works FOREIGN KEY(emp_no) REFERENCES 
employee(emp_no), 
CONSTRAINT foreign2_works FOREIGN KEY(project_no) 
REFERENCES project(project_no)); 

insert into department values ('d1', 'research','Dallas') 
insert into department values ('d2', 'accounting', 'Seattle') 
insert into department values ('d3', 'marketing', 'Dallas') 
insert into employee values(25348, 'Matthew', 'Smith','d3') 
insert into employee values(10102, 'Ann', 'Jones','d3') 
insert into employee values(18316, 'John', 'Barrimore', 'd1') 
insert into employee values(29346, 'James', 'James', 'd2') 
insert into employee values(9031, 'Elsa', 'Bertoni', 'd2') 
insert into employee values(2581, 'Elke', 'Hansel', 'd2') 
insert into employee values(28559, 'Sybill', 'Moser', 'd1') 
insert into project values ('p1', 'Apollo', 120000.00) 
insert into project values ('p2', 'Gemini', 95000.00) 
insert into project values ('p3', 'Mercury', 186500.00) 
insert into works_on values (10102,'p1', 'analyst', '2006.10.1') 
insert into works_on values (10102, 'p3', 'manager', '2008.1.1') 
insert into works_on values (25348, 'p2', 'clerk', '2007.2.15') 
insert into works_on values (18316, 'p2', NULL, '2007.6.1') 
insert into works_on values (29346, 'p2', NULL, '2006.12.15')
insert into works_on values (2581, 'p3', 'analyst', '2007.10.15') 
insert into works_on values (9031, 'p1', 'manager', '2007.4.15') 
insert into works_on values (28559, 'p1', NULL, '2007.8.1') 
insert into works_on values (28559, 'p2', 'clerk', '2008.2.1') 
insert into works_on values (9031, 'p3', 'clerk', '2006.11.15') 
insert into works_on values (29346, 'p1','clerk', '2007.1.4')

-- Люди работают на проектах
SELECT [emp_no]
      ,[emp_fname]
      ,[emp_lname]
      ,[dept_no]
FROM employee as e
where not exists (select w.emp_no from works_on as w where w.emp_no = e.emp_no)

-- Люди и проекты
SELECT *
FROM employee as e join works_on as wo on (e.emp_no = wo.emp_no)

-- Кол-во проектов у людей
SELECT e.[emp_no]
      ,[emp_fname]
      ,[emp_lname]
      ,count (*)
FROM employee as e join works_on as wo on (e.emp_no = wo.emp_no)
Group by e.[emp_no]
      ,[emp_fname]
      ,[emp_lname]

SELECT e.[emp_no]
      ,[emp_fname]
      ,[emp_lname]
      ,(select count (*) from works_on as wos where wos.emp_no = wo.emp_no)
FROM employee as e join works_on as wo on (e.emp_no = wo.emp_no)

SELECT e.[emp_no]
      ,[emp_fname]
      ,[emp_lname]
      ,(select count (*) from works_on as wos where wos.emp_no = e.emp_no)
FROM employee as e 

  
