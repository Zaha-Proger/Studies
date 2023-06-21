USE MedExamSys
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
			RAISERROR ('Таких номера и серии паспорта не существует для обновления', 16, 1)
	END
	