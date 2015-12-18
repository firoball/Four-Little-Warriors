FileReadLine, wedpath, make_4lw.ini, 1
FileReadLine, workpath, make_4lw.ini, 2

i = 2
Loop
{
	i += 1
	FileReadLine, line, make_4lw.ini, %i%
	if ErrorLevel <> 0
		break

	Run, %wedpath%\wed.exe %workpath%\%line%
	WinWait, WED - %workpath%\%line%
	WinWaitActive, WED - %workpath%\%line%
	Send, {ALTDOWN}f{ALTUP}rr{ENTER}

	WinWaitActive, Resource
	okready := 0
	loop
	{
		ControlGet, okready, Enabled, Ok
		if okready = 1
			break
	}
	Send, {ENTER}{ALTDOWN}{F4}{ALTUP}
	sleep, 1000
}
Run, 4lw_copy.bat %1% %2%