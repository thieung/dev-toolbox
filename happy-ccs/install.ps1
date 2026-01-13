# Install happy-ccs globally (Windows PowerShell)
Write-Host "Installing happy-ccs..." -ForegroundColor Cyan

# Check and install prerequisites if needed
$ccsInstalled = Get-Command ccs -ErrorAction SilentlyContinue
if (-not $ccsInstalled) {
    Write-Host "Installing CCS CLI..." -ForegroundColor Yellow
    npm install -g @kaitranntt/ccs
}

$happyInstalled = Get-Command happy -ErrorAction SilentlyContinue
if (-not $happyInstalled) {
    Write-Host "Installing Happy CLI..." -ForegroundColor Yellow
    npm install -g happy-coder
}

# Remove old installation if exists
npm uninstall -g happy-ccs -ErrorAction SilentlyContinue | Out-Null

# Install dependencies and global package
npm install
npm install -g .

Write-Host ""
Write-Host "Done! Run 'happy-ccs --help' to get started." -ForegroundColor Green
Write-Host ""
Write-Host "If 'command not found', restart your terminal." -ForegroundColor Gray
