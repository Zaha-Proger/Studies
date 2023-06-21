USE MedExamSys;
GO
CREATE or ALTER PROCEDURE Select_res_for_id
	@medcheck_id INT
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		SELECT emp_fname, emp_name, emp_surname, prot_concl, check_data
		FROM Employee as emp, MedCheckup as med_check, Protocol as prot, Results as res
		WHERE med_check.check_id = @medcheck_id AND emp.emp_id = med_check.emp_id AND med_check.check_id = res.res_id AND res.res_id = prot.prot_num
	END
GO
	