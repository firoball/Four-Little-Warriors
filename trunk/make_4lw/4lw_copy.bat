@echo off
set demo=
if "%1"=="-d" set demo=-d
if "%2"=="-d" set demo=-d

if "%1"=="-nc" exit
cd..

echo.
echo Copy files...
echo.

rem deltree /Y warriors.cd\music > nul
rd /s /q warriors.cd\music > nul
md warriors.cd\music
copy bass.dll warriors.cd
copy basswrap.dll warriors.cd
copy ackwii.dll warriors.cd
xcopy music\track2.xm warriors.cd\music\
xcopy music\track3.xm warriors.cd\music\
xcopy music\track4.xm warriors.cd\music\
if not "%demo%"=="-d" xcopy music\track5.xm warriors.cd\music\
if not "%demo%"=="-d" xcopy music\track6.xm warriors.cd\music\
if not "%demo%"=="-d" xcopy music\track7.xm warriors.cd\music\
rem xcopy music\track10.xm warriors.cd\music\
xcopy /Y wrs_levels.cd\*.wrs warriors.cd\
xcopy /Y wrs_models.cd\*.wrs warriors.cd\
xcopy /Y wrs_entities.cd\*.wrs warriors.cd\
xcopy /Y wrs_sprites.cd\*.wrs warriors.cd\
xcopy /Y wrs_panel.cd\*.wrs warriors.cd\
xcopy /Y wrs_sounds.cd\*.wrs warriors.cd\
xcopy /Y install\acknex.wdf warriors.cd\
xcopy /Y install\wiimote.txt warriors.cd\
xcopy /Y help\manual.chm warriors.cd\
xcopy /Y install\readme.txt warriors.cd\
xcopy /Y install\bugfix.txt warriors.cd\
if "%demo%"=="-d" del warriors.cd\readme.txt > nul
if "%demo%"=="-d" xcopy install\dreadme.txt warriors.cd\
if "%demo%"=="-d" ren warriors.cd\dreadme.txt readme.txt
echo.
echo Performing Cleanup...
echo.

del warriors.cd\weds.exe
del warriors.cd\weds.dat
del warriors.cd\wwmp2wmb.exe
del warriors.cd\palette.raw
rd /s /q wrs_levels.cd
rd /s /q wrs_models.cd
rd /s /q wrs_entities.cd
rd /s /q wrs_sprites.cd
rd /s /q wrs_panel.cd
rd /s /q wrs_sounds.cd

echo.
echo Finished...

cd make_4lw
if not "%1"=="-ni" call 4lw_inst.bat %demo%


