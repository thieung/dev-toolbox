@echo off
:: happy-ccs - Windows launcher
:: Automatically finds Node.js and runs the main script

setlocal
set "SCRIPT_DIR=%~dp0"
node "%SCRIPT_DIR%happy-ccs.mjs" %*
