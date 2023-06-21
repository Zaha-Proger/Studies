USE MedExamSys
GO
CREATE OR ALTER PROCEDURE Delete_emp
	@emp_fname CHAR(30),
	@emp_name CHAR(30),
	@emp_surname CHAR(30)
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		DELETE FROM Employee 
		WHERE emp_fname = @emp_fname AND 
				emp_name = @emp_name AND
				emp_surname = @emp_surname
	END