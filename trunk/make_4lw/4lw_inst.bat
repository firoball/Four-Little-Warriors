@echo off

echo.
echo Creating installer...
echo.

rd /s /q ..\warriors.ins > nul
md ..\warriors.ins 
if not "%1"=="-d" "c:\programme\install it!\installmaker" /b d:\a419\warriors\install\warriors.iit
if "%1"=="-d" "c:\programme\install it!\installmaker" /b d:\a419\warriors\install\dwarriors.iit

echo.
echo Finished...
