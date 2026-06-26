# install.ps1 — Network Recon Tool installer for Windows PowerShell
# Usage: .\install.ps1

#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$REQUIRED_MAJOR = 3
$REQUIRED_MINOR = 12
$VENV_DIR = '.venv'

function Write-Header {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║      Network Recon Tool — Installer      ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Info    ($msg) { Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Write-Success ($msg) { Write-Host "[OK]    $msg" -ForegroundColor Green }
function Write-Warn    ($msg) { Write-Host "[WARN]  $msg" -ForegroundColor Yellow }
function Write-Err     ($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

Write-Header

# ── 1. Verify Python version ───────────────────────────────────────────────────
Write-Info "Checking Python version…"

$pythonCmd = $null
foreach ($cmd in @('python', 'python3', 'py')) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        $verStr = & $cmd -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}')" 2>$null
        $major  = & $cmd -c "import sys; print(sys.version_info.major)" 2>$null
        $minor  = & $cmd -c "import sys; print(sys.version_info.minor)" 2>$null
        if ([int]$major -ge $REQUIRED_MAJOR -and [int]$minor -ge $REQUIRED_MINOR) {
            $pythonCmd = $cmd
            Write-Success "Found Python $verStr"
            break
        }
    }
}

if (-not $pythonCmd) {
    Write-Err "Python ${REQUIRED_MAJOR}.${REQUIRED_MINOR}+ is required but was not found.`n  Download it from https://python.org/downloads"
}

# ── 2. Create virtual environment ─────────────────────────────────────────────
if (Test-Path $VENV_DIR) {
    Write-Warn "Virtual environment '$VENV_DIR' already exists — skipping creation."
} else {
    Write-Info "Creating virtual environment in '$VENV_DIR'…"
    & $pythonCmd -m venv $VENV_DIR
    Write-Success "Virtual environment created."
}

# ── 3. Install dependencies ───────────────────────────────────────────────────
$pip = Join-Path $VENV_DIR 'Scripts\pip.exe'
Write-Info "Upgrading pip…"
& $pip install --quiet --upgrade pip

Write-Info "Installing dependencies from requirements.txt…"
& $pip install --quiet -r requirements.txt
Write-Success "Dependencies installed."

# ── 4. Verify installation ────────────────────────────────────────────────────
$python = Join-Path $VENV_DIR 'Scripts\python.exe'
Write-Info "Verifying installation…"
& $python -c "from recon import __version__; print(f'recon v{__version__} — OK')"
Write-Success "Verification passed."

# ── 5. Done ───────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "╔═══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  Installation complete!                   ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "  Activate the virtual environment:" -ForegroundColor White
Write-Host "    .\.venv\Scripts\Activate.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Then run the tool:" -ForegroundColor White
Write-Host "    python main.py --help" -ForegroundColor Cyan
Write-Host "    python main.py discover 192.168.1.0/24" -ForegroundColor Cyan
Write-Host "    python main.py dns example.com" -ForegroundColor Cyan
Write-Host ""
