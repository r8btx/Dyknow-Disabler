# Alternative Methods

## Overwriting Log Data
forfiles /p "C:\ProgramData\DyKnow\data" /m *.dat /s /c "cmd /c del /f /q @path && fsutil file createnew @path @fsize" >nul 2>&1

