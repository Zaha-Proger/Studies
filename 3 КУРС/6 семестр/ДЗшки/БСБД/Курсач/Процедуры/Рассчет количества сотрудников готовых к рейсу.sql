USE MedExamSys
GO
CREATE OR ALTER PROCEDURE Calc_emp_ready
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		SELECT COUNT(DISTINCT emp_id) AS count_ready 
		FROM MedCheckup AS m, Protocol AS p 
		WHERE m.check_id = p.prot_num AND 
		p.prot_concl = 'ѕризнаки состо€ний и заболеваний отсутствуют'
	END