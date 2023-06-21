USE MedExamSys;
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