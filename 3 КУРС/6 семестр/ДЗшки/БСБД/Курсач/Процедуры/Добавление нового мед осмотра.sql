USE MedExamSys
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