USE MedExamSys
GO 
CREATE OR ALTER PROCEDURE Insert_passport
	@pass_id NCHAR(11),
	@pass_date DATE,
	@pass_issued VARCHAR(100),
	@pass_code NCHAR(7)
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		INSERT INTO Passport(pass_id, pass_date, pass_issued, pass_code)
		VALUES (@pass_id, @pass_date, @pass_issued, @pass_code)
	END