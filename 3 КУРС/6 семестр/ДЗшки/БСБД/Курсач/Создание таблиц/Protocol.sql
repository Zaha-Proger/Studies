USE MedExamSys;
CREATE TABLE Protocol
(
	prot_num INT NOT NULL CONSTRAINT prim_prot PRIMARY KEY,
	prot_concl NCHAR(100) NOT NULL,
	CONSTRAINT foreign_res FOREIGN KEY(prot_num) REFERENCES Results(res_id) 
	ON DELETE CASCADE
)