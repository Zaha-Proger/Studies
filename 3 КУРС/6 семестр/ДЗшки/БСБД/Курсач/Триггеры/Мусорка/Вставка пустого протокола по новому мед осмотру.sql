USE MedExamSys
GO
CREATE OR ALTER TRIGGER Insert_null_prot_and_res
ON MedCheckup
AFTER INSERT
AS
BEGIN
    DECLARE @check_id INT
    SELECT @check_id = inserted.check_id FROM inserted
	INSERT INTO Results (res_id, res_temp, res_sys_pres, res_dias_pres, res_pulse, res_alco, res_compl)
	VALUES (@check_id, 0, '0', '0', '0', 0.0, '-')
END