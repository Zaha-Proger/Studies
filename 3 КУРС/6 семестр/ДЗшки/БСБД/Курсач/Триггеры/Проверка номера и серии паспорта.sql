USE MedExamSys
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