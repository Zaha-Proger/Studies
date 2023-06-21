USE MedExamSys;
GO
CREATE or ALTER PROCEDURE Select_res_for_emp
	@emp_fname CHAR(30),
	@emp_name CHAR(30),
	@emp_surname CHAR(30),
	@flag BIT = 0
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		IF @flag = 0
			SELECT check_id, check_data, res_temp, res_sys_pres, res_dias_pres, res_pulse, res_alco, res_compl
				FROM MedCheckup AS med_check, Results AS res, Employee AS emp
				WHERE emp.emp_fname = @emp_fname AND emp.emp_name = @emp_name AND
					emp.emp_surname = @emp_surname AND emp.emp_id = med_check.emp_id AND
					med_check.check_id = res.res_id
		ELSE
		SELECT check_id, check_data, res_temp, res_sys_pres, res_dias_pres, res_pulse, res_alco, res_compl, prot_concl
				FROM MedCheckup AS med_check, Results AS res, Employee AS emp, Protocol AS prot
				WHERE emp.emp_fname = @emp_fname AND emp.emp_name = @emp_name AND
					emp.emp_surname = @emp_surname AND emp.emp_id = med_check.emp_id AND
					med_check.check_id = res.res_id AND res.res_id = prot.prot_num
	END
GO
		