USE MedExamSys
GO
CREATE OR ALTER PROCEDURE Update_prot_concl
	@prot_id INT,
	@prot_concl NCHAR(100)
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		UPDATE Protocol
		SET prot_concl = @prot_concl
		WHERE prot_num = @prot_id	
	END