All build tools must be in the subfolder make_4lw of the project!!

make_4lw.exe
	Activate automated build process.
	File paths are relative.
	If directory structure changes, only adapt make_4lw.ini
	
-nc	do not perform file copy and cleanup. Only resource files are created
-ni	perform regular build, but do not create installer
-d	perform demo build, create demo installer

make_4lw.ini
	ini file for build process
	line 1: Absolute Path to WED
	line 2: Absolute Path to project
	line 3-x: WMP files necessary for building resource


make_4lw.ahk
	Script source for AutoHotkey if changes are necessary


4lw_copy.bat
	Copy all necessary files in place and delete unnecessary folders
	file is called by make_4lw.exe.
	Do not call unless make_4lw has run before with -nc
	
-ni	do not create installer
-d	copy demo files


4lw_inst.bat
	file is called by 4lw_copy.bat (this means also by make_4lw.exe).
	Do not call unless make_4lw has run before (with or without -ni)
	If directory structure changes, adapt path to Installmaker

-d	create demo installer
