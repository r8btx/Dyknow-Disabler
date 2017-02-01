@echo off
setlocal EnableDelayedExpansion

:Main
for /f "tokens=1-2 delims=:" %%a in ('type %0 ^|findstr /n /c:"END OF BATCH FILE"') do (
	set "LineNum=%%a"
)

for /f "tokens=1-2 delims=:" %%a in ('more +%LineNum% %0 ^|findStr /n .') do (
	set "Srv%%a=%%b"
	set "Cnt=%%a"
)

if "%Srv1%"=="" goto :Setup

for /f "tokens=3" %%a in ('sc query %Srv1% ^|findstr STATE') do (set "State=%%a")

if "%State%"=="4" (
	call :Toggle Stop
	call :Overwrite
	goto :Eof
) else if "%State%"=="1" (
	call :Toggle Start
	goto :Eof
) else (
	echo.The script is processing previous command or encountered an error.
	timeout /nobreak /t 2 >nul
)
goto :Eof


:Setup
echo.Initial setup in progress...
bcdedit > nul
if not "%Errorlevel%" == "0" (
	call :ErrorMsg "Access Denied" "This script requires higher permission"
	goto :Eof
)
for /f "tokens=2" %%a in ('whoami /user /fo list') do (set "UserSSID=%%a")

for /f "tokens=5 delims=\" %%s in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /t "Reg_Expand_SZ" /f "Dyknow" ^|findstr /c:"CurrentControlSet\Services"') do (
	for /f "delims=" %%d in ('sc sdshow %%s ^|findstr /v "%UserSSID%"') do (
		set "Edit=%%d"
		set "Edit=!Edit:~0,2!(A;;RPWPCR;;;%UserSSID%)!Edit:~2!"
		sc sdset %%s "!Edit!" >nul
	)
	echo %%s>>%0
	set "Exist=True"
)

if not "%Exist%"=="True" (
	call :ErrorMsg "Service NOT Found" "Could not find Dyknow service"
	goto :Eof
)

goto :Main


:Toggle <1=Start-or-Stop>
for /l %%l in (1,1,%Cnt%) do (sc %1 !Srv%%l!)
goto :Eof

:Overwrite
cd "C:\ProgramData\DyKnow\data"
for /f "tokens=4-5" %%a in ('dir /s /-c ^|findstr /e dat') do (
	fsutil file createnew %%btmp %%a >nul 2>&1
)

for /f "tokens=5-6 delims=\" %%a in ('dir /s /b ^|findstr /e dat') do (
	del /q /f "%%a\%%b" >nul 2>&1
	move "%%btmp" "%%a\%%b" >nul 2>&1
)
goto :Eof

::---------------------------------------------------------
:ErrorMsg <1=Message-title> <2=Content>
echo result ^= MsgBox ^(%2,vb, %1^) >>"%tmp%\ErrMsg.vbs"
cscript /nologo "%tmp%\ErrMsg.vbs"
del /f "%tmp%\ErrMsg.vbs" >nul
goto :Eof
::::::::::::::::::::::END OF BATCH FILE::::::::::::::::::::::
