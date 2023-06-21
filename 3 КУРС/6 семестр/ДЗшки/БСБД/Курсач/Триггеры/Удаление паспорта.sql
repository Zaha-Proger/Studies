USE MedExamSys
GO
CREATE OR ALTER TRIGGER Delete_pass
	ON Employee
	AFTER DELETE
	AS
	BEGIN
		DELETE FROM Passport
		WHERE pass_id IN (SELECT emp_id FROM deleted)
	END