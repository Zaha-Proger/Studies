@echo off

set MY_CONSOLE_CHECK=1

rem "��������� ������� � ������� �������"
cd /d "%~dp0"
if not exist "%~nx0" goto error2

cscript //nologo view_usbstore_2n.js -legal legalSerials.txt
REM > view_usbstore_out.txt

goto end

:error2
rem "��������� ������! �� ������� ������� � ���������� ��������� �������!."
echo "�ந��諠 �訡��! �� 㤠���� ��३� � ��४��� �ਯ�."
goto end


:end
pause