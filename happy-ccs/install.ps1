# Install happy-ccs globally (Windows PowerShell)
$ErrorActionPreference = "Stop"

Write-Host "Installing happy-ccs..." -ForegroundColor Cyan

$ArchiveUrl = if ($env:HAPPY_CCS_ARCHIVE_URL) {
    $env:HAPPY_CCS_ARCHIVE_URL
} else {
    "https://github.com/thieung/dev-toolbox/archive/refs/heads/main.zip"
}

$InstallDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$TempDir = $null

function Invoke-Npm {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$NpmArgs)
    & npm @NpmArgs
    if ($LASTEXITCODE -ne 0) {
        throw "npm $($NpmArgs -join ' ') failed with exit code $LASTEXITCODE"
    }
}

function Test-HappyCcsPackage {
    param([string]$Path)
    $PackageJson = Join-Path $Path "package.json"
    $BinScript = Join-Path $Path "scripts/happy-ccs.mjs"
    if (-not (Test-Path $PackageJson) -or -not (Test-Path $BinScript)) {
        return $false
    }
    try {
        $Package = Get-Content $PackageJson -Raw | ConvertFrom-Json
        return $Package.name -eq "happy-ccs"
    } catch {
        return $false
    }
}

try {
if (-not (Test-HappyCcsPackage $InstallDir)) {
    Write-Host "Downloading happy-ccs package..." -ForegroundColor Yellow
    $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("happy-ccs-" + [System.Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $TempDir | Out-Null
    $ArchivePath = Join-Path $TempDir "dev-toolbox.zip"
    Invoke-WebRequest -Uri $ArchiveUrl -OutFile $ArchivePath -UseBasicParsing
    Expand-Archive -Path $ArchivePath -DestinationPath $TempDir -Force
    $PackageDir = Get-ChildItem -Path $TempDir -Directory -Recurse -Filter "happy-ccs" | Select-Object -First 1
    if (-not $PackageDir -or -not (Test-HappyCcsPackage $PackageDir.FullName)) {
        throw "Could not find happy-ccs package in downloaded archive."
    }
    $InstallDir = $PackageDir.FullName
}

# Check and install prerequisites if needed
$ccsInstalled = Get-Command ccs -ErrorAction SilentlyContinue
if (-not $ccsInstalled) {
    Write-Host "Installing CCS CLI..." -ForegroundColor Yellow
    Invoke-Npm install -g @kaitranntt/ccs
}

$happyInstalled = Get-Command happy -ErrorAction SilentlyContinue
if (-not $happyInstalled) {
    Write-Host "Installing Happy CLI..." -ForegroundColor Yellow
    Invoke-Npm install -g happy-coder
}

# Remove old installation if exists
& npm uninstall -g happy-ccs 2>$null | Out-Null

# Install dependencies and global package
Push-Location $InstallDir
try {
    Invoke-Npm install
    Invoke-Npm install -g .
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "Done! Run 'happy-ccs --help' to get started." -ForegroundColor Green
Write-Host ""
Write-Host "If 'command not found', restart your terminal." -ForegroundColor Gray
} finally {
    if ($TempDir -and (Test-Path $TempDir)) {
        Remove-Item -Recurse -Force $TempDir
    }
}
