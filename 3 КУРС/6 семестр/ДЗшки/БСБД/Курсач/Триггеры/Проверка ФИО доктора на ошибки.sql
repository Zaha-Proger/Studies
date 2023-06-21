USE MedExamSys
GO
CREATE OR ALTER TRIGGER Check_doc_name
ON Doctor
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE doc_fname LIKE '%[0-9]%') OR
	EXISTS (SELECT 1 FROM inserted WHERE doc_name LIKE '%[0-9]%') OR
	EXISTS (SELECT 1 FROM inserted WHERE doc_surname LIKE '%[0-9]%')
    BEGIN
        RAISERROR ('ФИО доктора не должно содержать цифры', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END