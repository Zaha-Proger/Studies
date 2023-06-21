USE MedExamSys;
CREATE TABLE Doctor
(
	doc_id INT NOT NULL CONSTRAINT prim_doc_id PRIMARY KEY,
	doc_fname CHAR(30) NOT NULL,
	doc_name CHAR(30) NOT NULL,
	doc_surname CHAR(30) NULL,
	doc_spec CHAR(20) NOT NULL,
	doc_email NCHAR(20) NULL
);
CREATE INDEX doc_name_idx ON Doctor(doc_fname, doc_name)