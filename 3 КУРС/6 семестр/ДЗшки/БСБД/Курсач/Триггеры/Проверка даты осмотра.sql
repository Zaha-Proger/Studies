USE MedExamSys
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
