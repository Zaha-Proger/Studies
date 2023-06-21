USE MedExamSys;
CREATE TABLE Results
(
	res_id INT NOT NULL CONSTRAINT prim_res_id PRIMARY KEY,
	res_temp FLOAT NOT NULL,
	res_sys_pres CHAR(3) NOT NULL,
	res_dias_pres CHAR(3) NOT NULL,
	res_pulse CHAR(3) NOT NULL,
	res_alco FLOAT NOT NULL,
	res_compl NCHAR(100) NULL,
	CONSTRAINT foreign_check FOREIGN KEY(res_id) REFERENCES MedCheckup(check_id) 
	ON DELETE CASCADE
);
