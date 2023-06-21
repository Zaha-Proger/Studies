USE MedExamSys;
CREATE TABLE Employee
(
	emp_id NCHAR(11) NOT NULL CONSTRAINT prim_emp_id PRIMARY KEY,
	emp_fname CHAR(30) NOT NULL,
	emp_name CHAR(30) NOT NULL,
	emp_surname CHAR(30) NULL,
	emp_age CHAR(3) NOT NULL,
	emp_gender CHAR(1) NOT NULL,
	emp_phone NCHAR(11)  NOT NULL,
	emp_email NCHAR(20) NULL,
	CONSTRAINT foreign_pass FOREIGN KEY(emp_id) REFERENCES Passport(pass_id) 
	ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE INDEX emp_name_idx ON Employee(emp_fname, emp_name)