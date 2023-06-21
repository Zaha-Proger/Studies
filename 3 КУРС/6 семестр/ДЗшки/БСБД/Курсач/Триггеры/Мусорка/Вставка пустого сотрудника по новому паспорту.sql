USE MedExamSys
GO
CREATE OR ALTER TRIGGER Insert_null_emp
ON Passport
AFTER INSERT
AS
BEGIN
    DECLARE @pass_id NCHAR(11)
    SELECT @pass_id = inserted.pass_id FROM inserted
	INSERT INTO Employee
	VALUES (@pass_id, 'нет данных', 'нет данных', 'нет данных', '-', '-', '00000000000', '-')
END