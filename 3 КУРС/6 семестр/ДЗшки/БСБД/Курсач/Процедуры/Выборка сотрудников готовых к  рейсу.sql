USE MedExamSys;
GO
CREATE or ALTER PROCEDURE Select_emp_ready
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		SELECT emp_fname, emp_name, emp_surname, check_data
		FROM MedCheckup AS med_check, Protocol AS prot, Employee AS emp
		WHERE emp.emp_id = med_check.emp_id AND
			 med_check.check_id = prot_num AND 
			 prot_concl = 'ѕризнаки состо€ний и заболеваний отсутствуют'
	END
GO