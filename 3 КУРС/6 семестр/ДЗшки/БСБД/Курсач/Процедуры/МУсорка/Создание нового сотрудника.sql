USE MedExamSys
GO 
CREATE OR ALTER PROCEDURE Insert_emp
	@emp_id NCHAR(11),
	@emp_fname CHAR(30),
	@emp_name CHAR(30),
	@emp_surname CHAR(30),
	@emp_age CHAR(3),
	@emp_gender CHAR(1),
	@emp_phone NCHAR(11),
	@emp_email NCHAR(20)
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		UPDATE Employee
		SET emp_fname = @emp_fname,
			emp_name = @emp_name,
			emp_surname = @emp_surname,
			emp_age = @emp_age,
			emp_phone = @emp_phone,
			emp_email = @emp_email
		WHERE emp_id = @emp_id
	END