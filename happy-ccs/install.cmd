@echo off
:: Install happy-ccs globally (Windows)
echo Installing happy-ccs...

:: Check and install prerequisites if needed
where ccs >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing CCS CLI...
    call npm install -g @kaitranntt/ccs
)

where happy >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing Happy CLI...
    call npm install -g happy-coder
)

:: Remove old installation if exists
call npm uninstall -g happy-ccs 2>nul

:: Install dependencies and global package
call npm install
call npm install -g .

echo.
echo Done! Run 'happy-ccs --help' to get started.
echo.
echo If 'command not found', restart your terminal.
