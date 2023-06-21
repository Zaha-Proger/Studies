USE MedExamSys
GO
CREATE OR ALTER TRIGGER Check_phone 
	ON Employee
	AFTER INSERT, UPDATE
	AS 
	BEGIN
		DECLARE @phone NCHAR(11)
		SELECT @phone = inserted.emp_phone FROM inserted
		IF (@phone LIKE '8[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
			RETURN
		ELSE
			BEGIN
				RAISERROR('Некорректный номер телефона (ожидается ввод только цифр) или номер начинается не с цифры ''8''!', 16,1)
				ROLLBACK TRANSACTION
			END
	END