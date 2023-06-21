USE MedExamSys;
CREATE TABLE Passport
(
	pass_id NCHAR(11) NOT NULL,
	pass_date DATE NOT NULL,
	pass_issued VARCHAR NOT NULL,
	pass_code NCHAR(7) NOT NULL,
	CONSTRAINT prim_pass_id PRIMARY KEY(pass_id)
)
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
);CREATE INDEX emp_name_idx ON Employee(emp_fname, emp_name)
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
CREATE TABLE MedCheckup
(
	check_id INT NOT NULL CONSTRAINT prim_check_id PRIMARY KEY,
	emp_id NCHAR(11) NOT NULL,
	doc_id INT NOT NULL,
	check_data DATETIME NOT NULL,
	CONSTRAINT foreign_emp FOREIGN KEY(emp_id) REFERENCES Employ-ee(emp_id) 
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT foreign_doc FOREIGN KEY(doc_id) REFERENCES Doctor(doc_id)
CREATE TABLE Results
(
	res_id INT NOT NULL CONSTRAINT prim_res_id PRIMARY KEY,
	res_temp FLOAT NOT NULL,
	res_sys_pres CHAR(3) NOT NULL,
	res_dias_pres CHAR(3) NOT NULL,
	res_pulse CHAR(3) NOT NULL,
	res_alco FLOAT NOT NULL,
	res_compl NCHAR(100) NULL,
	CONSTRAINT foreign_check FOREIGN KEY(res_id) REFERENCES MedCheck-up(check_id) 
	ON DELETE CASCADE
CREATE TABLE Protocol
(
	prot_num INT NOT NULL CONSTRAINT prim_prot PRIMARY KEY,
	prot_concl NCHAR(100) NOT NULL,
	CONSTRAINT foreign_res FOREIGN KEY(prot_num) REFERENCES Results(res_id)
)
GO
CREATE or ALTER PROCEDURE Select_concl_for_date
	@med_date DATE
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		SELECT emp_fname, emp_name, emp_surname, prot_concl, check_data
		FROM Employee as emp, MedCheckup as med_check, Protocol as prot
		WHERE CAST(med_check.check_data AS DATE) = @med_date 
		AND emp.emp_id = med_check.emp_id AND 
		med_check.check_id = prot.prot_num
	END
GO
GO
CREATE or ALTER PROCEDURE Select_res_for_emp
	@emp_fname CHAR(30),
	@emp_name CHAR(30),
	@emp_surname CHAR(30),
	@flag BIT = 0
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		IF @flag = 0
			SELECT check_id, check_data, res_temp, res_sys_pres, res_dias_pres, res_pulse, res_alco, res_compl
				FROM MedCheckup AS med_check, Results AS res, Employee AS emp
				WHERE emp.emp_fname = @emp_fname AND emp.emp_name = @emp_name AND
					emp.emp_surname = @emp_surname AND emp.emp_id = med_check.emp_id AND
					med_check.check_id = res.res_id
		ELSE
		SELECT check_id, check_data, res_temp, res_sys_pres, res_dias_pres, res_pulse, res_alco, res_compl, prot_concl
				FROM MedCheckup AS med_check, Results AS res, Employee AS emp, Protocol AS prot
				WHERE emp.emp_fname = @emp_fname AND emp.emp_name = @emp_name AND
					emp.emp_surname = @emp_surname AND emp.emp_id = med_check.emp_id AND
					med_check.check_id = res.res_id AND res.res_id = prot.prot_num
	END
GO
GO
CREATE or ALTER PROCEDURE Select_emp_ready
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		SELECT emp_fname, emp_name, emp_surname, check_data
		FROM MedCheckup AS med_check, Protocol AS prot, Employee AS emp
		WHERE emp.emp_id = med_check.emp_id AND
			 med_check.check_id = prot_num AND 
			 prot_concl = 'Признаки состояний и заболеваний отсутствуют'
	END
GO
GO
CREATE OR ALTER PROCEDURE Insert_med_check
	@new_check_id INT,
	@emp_id NCHAR(11),
	@doc_id INT,
	@new_check_date DATETIME
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		IF EXISTS(SELECT * FROM MedCheckup WHERE check_id = @new_check_id)
			UPDATE MedCheckup
			SET emp_id = @emp_id,
				doc_id = @doc_id,
				check_data = @new_check_date
			WHERE check_id = @new_check_id
		ELSE
			INSERT INTO MedCheckup
			VALUES (@new_check_id, @emp_id, @doc_id, @new_check_date)
	END
GO
CREATE OR ALTER PROCEDURE Update_data_pass
	@new_pass_id NCHAR(11),
	@new_pass_date DATE,
	@new_pass_issued VARCHAR(100),
	@new_pass_code NCHAR(7)
	WITH EXECUTE AS OWNER
	AS
	DISABLE TRIGGER  Update_old_pass ON Passport
	BEGIN
		IF EXISTS(SELECT pass_id FROM Passport WHERE pass_id = @new_pass_id)
		BEGIN
			UPDATE Passport
			SET pass_date = @new_pass_date,
				pass_issued = @new_pass_issued,
				pass_code = @new_pass_code
			WHERE pass_id = @new_pass_id
		END
		ELSE
			RAISERROR ('Таких номера и серии паспорта не существует для об-новления', 16, 1)
	END
GO
CREATE OR ALTER PROCEDURE Update_pass_id
	@old_pass_id NCHAR(11),
	@new_pass_id NCHAR(11)
	WITH EXECUTE AS OWNER
	AS
	ENABLE TRIGGER Update_old_pass ON Passport
	IF NOT EXISTS (SELECT pass_id FROM Passport WHERE pass_id = @new_pass_id)
		BEGIN 
			UPDATE Passport SET pass_id = @new_pass_id
			WHERE pass_id = @old_pass_id
		END
	ELSE
		RAISERROR ('Такие номер и серия паспорта уже существуют в базе данных', 16, 1)
GO
CREATE OR ALTER PROCEDURE Calc_emp_ready
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		SELECT COUNT(DISTINCT emp_id) AS count_ready 
		FROM MedCheckup AS m, Protocol AS p 
		WHERE m.check_id = p.prot_num AND 
		p.prot_concl = 'Признаки состояний и заболеваний отсутствуют'
	END
GO
CREATE OR ALTER PROCEDURE Delete_emp
	@emp_fname CHAR(30),
	@emp_name CHAR(30),
	@emp_surname CHAR(30)
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		DELETE FROM Employee 
		WHERE emp_fname = @emp_fname AND 
				emp_name = @emp_name AND
				emp_surname = @emp_surname
	END
GO
CREATE OR ALTER TRIGGER Update_old_pass
ON Passport
AFTER UPDATE
AS
BEGIN
	UPDATE Passport
		SET pass_code = '000-000',
		pass_date = '1900-01-01',
		pass_issued = 'Данные устарели'
		WHERE pass_id = (SELECT pass_id FROM inserted)
END
GO
CREATE OR ALTER TRIGGER Insert_prot_concl
ON Protocol
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @new_prot_id INT,
			@emp_fname CHAR(30),
			@emp_name CHAR(30),
			@emp_surname CHAR(30)
	SELECT @new_prot_id = inserted.prot_num FROM inserted
	SELECT @emp_fname = (SELECT emp_fname FROM Employee AS e, MedCheckup AS m
							WHERE e.emp_id = m.emp_id AND m.check_id = @new_prot_id)
	SELECT @emp_name = (SELECT emp_name FROM Employee AS e, MedCheckup AS m
							WHERE e.emp_id = m.emp_id AND m.check_id = @new_prot_id)
	SELECT @emp_surname = (SELECT emp_surname FROM Employee AS e, MedCheck-up AS m
							WHERE e.emp_id = m.emp_id AND m.check_id = @new_prot_id)
    EXEC Select_res_for_emp @emp_fname, @emp_name, @emp_surname, 1
END
GO
CREATE OR ALTER TRIGGER Check_date 
	ON MedCheckup
	AFTER INSERT, UPDATE
	AS
	BEGIN
		DECLARE
		 @med_check_id INT,
		 @check_date DATE;
		SET @med_check_id = (SELECT MAX(check_id) FROM MedCheckup)
		SET @check_date = (SELECT check_data FROM MedCheckup WHERE check_id = @med_check_id)
		IF @check_date > GETDATE()
		BEGIN
			RAISERROR('Дата прохождения мед. осмотра не может быть позже сегодняшней даты!', 16,1)
			ROLLBACK TRANSACTION
		END
	END
GO
CREATE OR ALTER TRIGGER Check_pass_id
ON Passport
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted WHERE pass_id LIKE '[0-9][0-9][0-9][0-9] [0-9][0-9][0-9][0-9][0-9][0-9]')
		RETURN
	ELSE
		RAISERROR ('Ошибка при вводе данных паспорта', 16, 1)
        ROLLBACK TRANSACTION
END
GO
CREATE OR ALTER TRIGGER Check_phone 
	ON Employee
	AFTER INSERT, UPDATE
	AS 
	BEGIN
		DECLARE @phone NCHAR(11)
		SELECT @phone = inserted.emp_phone FROM inserted
		IF (@phone LIKE '8[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
			RETURN
		ELSE
			BEGIN
				RAISERROR('Некорректный номер телефона (ожидается ввод только цифр) или номер начинается не с цифры ''8''!', 16,1)
				ROLLBACK TRANSACTION
			END
	END
GO
CREATE OR ALTER TRIGGER Check_doc_name
ON Doctor
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE doc_fname LIKE '%[0-9]%') OR
	EXISTS (SELECT 1 FROM inserted WHERE doc_name LIKE '%[0-9]%') OR
	EXISTS (SELECT 1 FROM inserted WHERE doc_surname LIKE '%[0-9]%')
    BEGIN
        RAISERROR ('ФИО доктора не должно содержать цифры', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO
CREATE OR ALTER TRIGGER Check_emp_name
ON Employee
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE emp_fname LIKE '%[0-9]%') OR
	EXISTS (SELECT 1 FROM inserted WHERE emp_name LIKE '%[0-9]%') OR
	EXISTS (SELECT 1 FROM inserted WHERE emp_surname LIKE '%[0-9]%')
    BEGIN
        RAISERROR ('ФИО сотрудника не должно содержать цифры', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO
CREATE OR ALTER TRIGGER Delete_pass
	ON Employee
	AFTER DELETE
	AS
	BEGIN
		DELETE FROM Passport
		WHERE pass_id IN (SELECT emp_id FROM deleted)
	END
USE [master]
GO
CREATE LOGIN [employee01] WITH PASSWORD=N'VerySTRPass1' MUST_CHANGE,
DEFAULT_DATABASE=[MedExamSys], CHECK_EXPIRATION=ON,CHECK_POLICY=ON

CREATE LOGIN [employee02] WITH PASSWORD=N'VerySTRPass2' MUST_CHANGE,
DEFAULT_DATABASE=[MedExamSys], CHECK_EXPIRATION=ON,CHECK_POLICY=ON

CREATE LOGIN [employee03] WITH PASSWORD=N'VerySTRPass3' MUST_CHANGE,
DEFAULT_DATABASE=[MedExamSys], CHECK_EXPIRATION=ON,CHECK_POLICY=ON

CREATE LOGIN [employee04] WITH PASSWORD=N'VerySTRPass4' MUST_CHANGE,
DEFAULT_DATABASE=[MedExamSys], CHECK_EXPIRATION=ON,CHECK_POLICY=ON

CREATE LOGIN [employee05] WITH PASSWORD=N'VerySTRPass5' MUST_CHANGE,
DEFAULT_DATABASE=[MedExamSys], CHECK_EXPIRATION=ON,CHECK_POLICY=ON

CREATE LOGIN [employee06] WITH PASSWORD=N'VerySTRPass6' MUST_CHANGE,
DEFAULT_DATABASE=[MedExamSys], CHECK_EXPIRATION=ON,CHECK_POLICY=ON

CREATE LOGIN [employee07] WITH PASSWORD=N'VerySTRPass7' MUST_CHANGE,
DEFAULT_DATABASE=[MedExamSys], CHECK_EXPIRATION=ON,CHECK_POLICY=ON

CREATE LOGIN [employee08] WITH PASSWORD=N'VerySTRPass8' MUST_CHANGE,
DEFAULT_DATABASE=[MedExamSys], CHECK_EXPIRATION=ON,CHECK_POLICY=ON

CREATE LOGIN [employee09] WITH PASSWORD=N'VerySTRPass9' MUST_CHANGE,
DEFAULT_DATABASE=[MedExamSys], CHECK_EXPIRATION=ON,CHECK_POLICY=ON
USE MedExamSys
CREATE USER emp_muhanov FOR LOGIN employee01;
CREATE USER emp_romanko FOR LOGIN employee02;
CREATE USER emp_krutov FOR LOGIN employee03;
CREATE USER emp_petrov FOR LOGIN employee04;
CREATE USER emp_sidorov FOR LOGIN employee05;
CREATE USER emp_simonenko FOR LOGIN employee06;
CREATE USER emp_kozlov FOR LOGIN employee07;
CREATE USER emp_smirnova FOR LOGIN employee08;
CREATE USER emp_nikolaev FOR LOGIN employee09;
USE MedExamSys
CREATE ROLE admins
ALTER ROLE admins ADD MEMBER emp_romanko 
ALTER ROLE admins ADD MEMBER emp_krutov
USE MedExamSys
CREATE ROLE directors
ALTER ROLE directors ADD MEMBER emp_muhanov
USE MedExamSys
CREATE ROLE doctors
ALTER ROLE doctors ADD MEMBER emp_petrov
ALTER ROLE doctors ADD MEMBER emp_sidorov
ALTER ROLE doctors ADD MEMBER emp_simonenko
ALTER ROLE doctors ADD MEMBER emp_kozlov
ALTER ROLE doctors ADD MEMBER emp_smirnova
ALTER ROLE doctors ADD MEMBER emp_nikolaev
USE MedExamSys
GRANT CREATE PROCEDURE TO admins
GRANT CREATE TABLE TO admins
GRANT EXECUTE ON Insert_med_check TO admins
GRANT EXECUTE ON Delete_emp TO admins
GRANT EXECUTE ON Update_pass_id  TO admins
GRANT EXECUTE ON Update_data_pass  TO admins
USE MedExamSys
GRANT INSERT ON Passport TO directors
GRANT INSERT ON Employee TO directors
GRANT SELECT ON Passport TO directors
GRANT SELECT ON Employee TO directors
GRANT EXECUTE ON Select_concl_for_date TO directors
GRANT EXECUTE ON Select_res_for_emp TO directors
GRANT EXECUTE ON Select_emp_ready TO directors
GRANT EXECUTE ON Update_data_pass TO directors
GRANT EXECUTE ON Update_pass_id TO directors
GRANT EXECUTE ON Delete_emp TO directors
GRANT EXECUTE ON Calc_emp_ready TO directors
USE MedExamSys
GRANT INSERT ON Protocol TO doctors
GRANT EXECUTE ON Select_res_for_emp To doctors
USE MedExamSys
DENY SELECT ON Employee TO doctors
DENY SELECT ON Passport TO doctors
USE MedExamSys
REVOKE EXECUTE ON Delete_emp TO directors
USE MedExamSys
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'DMKbdMedExamSys2023'
USE MedExamSys
CREATE ASYMMETRIC KEY ASMKEY
WITH ALGORITHM = RSA_2048
ENCRYPTION BY PASSWORD = 'ASYMKEYMedExamSys2023'
USE MedExamSys
CREATE SYMMETRIC KEY SYMKEY
WITH ALGORITHM = AES_256
ENCRYPTION BY ASYMMETRIC KEY ASMKEY
USE MedExamSys
OPEN SYMMETRIC KEY SYMKEY
DECRYPTION BY ASYMMETRIC KEY ASMKEY
WITH PASSWORD = 'ASYMKEYMedExamSys2023'
USE MedExamSys
ALTER TABLE Employee
  ADD emp_enc_phone VARBINARY(100)
GO
UPDATE Employee
SET emp_enc_phone = ENCRYPTBYKEY(KEY_GUID('SYMKEY'), emp_phone)
GO
SELECT emp_phone, emp_enc_phone,
CONVERT(NCHAR(11), DECRYPTBYKEY(emp_enc_phone)) AS emp_dec_phone
FROM Employee
USE master;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MedExamSysMASTER'
BACKUP MASTER KEY
TO FILE = 'D:\MSS\MSSQL15.MSSQLSERVER\MSSQL\Backup\Master.bak'
ENCRYPTION BY PASSWORD = 'MedExamSysBACKUP'
GO
SELECT * FROM sys.key_encryptions
USE master;
CREATE CERTIFICATE MedExamSysCERT WITH SUBJECT = 'BDMESCERT'
BACKUP CERTIFICATE MedExamSysCERT
TO FILE = 'D:\MSS\MSSQL15.MSSQLSERVER\MSSQL\Backup\CERT.bak'
WITH PRIVATE KEY
(FILE = 'D:\MSS\MSSQL15.MSSQLSERVER\MSSQL\Backup\PRIVATE.bak',
ENCRYPTION BY PASSWORD = 'MESprivCRT')
GO
SELECT * FROM sys.certificates WHERE name = 'MedExamSysCERT'
USE MedExamSys;
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE MedExamSysCERT;
ALTER DATABASE MedExamSys SET ENCRYPTION ON;
SELECT DB_NAME(database_id), *
FROM sys.dm_database_encryption_keys

		
