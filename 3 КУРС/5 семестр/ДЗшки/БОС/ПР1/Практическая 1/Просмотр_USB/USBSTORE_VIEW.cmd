@echo off

set MY_CONSOLE_CHECK=1

rem "Переходим обратно в каталог скрипта"
cd /d "%~dp0"
if not exist "%~nx0" goto error2

cscript //nologo view_usbstore_2n.js -legal legalSerials.txt
REM > view_usbstore_out.txt

goto end

:error2
rem "Произошла ошибка! Не удалось перейти в директорию выполнеия скрипта!."
echo "Џа®Ё§®и«  ®иЁЎЄ ! ЌҐ г¤ «®бм ЇҐаҐ©вЁ ў ¤ЁаҐЄв®аЁо бЄаЁЇв ."
goto end


:end
pause