USE MedExamSys
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