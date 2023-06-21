USE MedExamSys
GO
CREATE OR ALTER TRIGGER Check_emp_name
ON Employee
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE emp_fname LIKE '%[0-9]%') OR
	EXISTS (SELECT 1 FROM inserted WHERE emp_name LIKE '%[0-9]%') OR
	EXISTS (SELECT 1 FROM inserted WHERE emp_surname LIKE '%[0-9]%')
    BEGIN
        RAISERROR ('ФИО сотрудника не должно содержать цифры', 16, 1)
        ROLLBACK TRANSACTION
    END
END
