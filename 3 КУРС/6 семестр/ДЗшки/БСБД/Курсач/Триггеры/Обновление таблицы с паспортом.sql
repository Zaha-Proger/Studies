USE MedExamSys
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