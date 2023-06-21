USE MedExamSys;
CREATE TABLE MedCheckup
(
	check_id INT NOT NULL CONSTRAINT prim_check_id PRIMARY KEY,
	emp_id NCHAR(11) NOT NULL,
	doc_id INT NOT NULL,
	check_data DATETIME NOT NULL,
	CONSTRAINT foreign_emp FOREIGN KEY(emp_id) REFERENCES Employee(emp_id) 
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT foreign_doc FOREIGN KEY(doc_id) REFERENCES Doctor(doc_id)
);
