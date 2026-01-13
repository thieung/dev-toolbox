@echo off
:: Install happy-ccs globally (Windows)
echo Installing happy-ccs...

:: Remove old installation if exists
call npm uninstall -g happy-ccs 2>nul

:: Install dependencies and global package
call npm install
call npm install -g .

echo.
echo Done! Run 'happy-ccs --help' to get started.
echo.
echo If 'command not found', restart your terminal.
