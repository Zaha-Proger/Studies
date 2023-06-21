USE MedExamSys;
CREATE TABLE Passport
(
	pass_id NCHAR(11) NOT NULL,
	pass_date DATE NOT NULL,
	pass_issued VARCHAR(100) NOT NULL,
	pass_code NCHAR(7) NOT NULL,
	CONSTRAINT prim_pass_id PRIMARY KEY(pass_id) 
)