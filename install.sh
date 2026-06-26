#!/usr/bin/env bash
# install.sh — Network Recon Tool installer for Linux and macOS
# Usage: bash install.sh

set -euo pipefail

REQUIRED_PYTHON_MAJOR=3
REQUIRED_PYTHON_MINOR=12
VENV_DIR=".venv"

# ── colour helpers ────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RESET='\033[0m'
info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*" >&2; exit 1; }

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║      Network Recon Tool — Installer      ║${RESET}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${RESET}"
echo ""

# ── 1. Verify Python version ──────────────────────────────────────────────────
info "Checking Python version…"

PYTHON_CMD=""
for cmd in python3 python; do
    if command -v "$cmd" &>/dev/null; then
        VER=$("$cmd" -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
        MAJOR=$("$cmd" -c "import sys; print(sys.version_info.major)")
        MINOR=$("$cmd" -c "import sys; print(sys.version_info.minor)")
        if [[ "$MAJOR" -ge "$REQUIRED_PYTHON_MAJOR" && "$MINOR" -ge "$REQUIRED_PYTHON_MINOR" ]]; then
            PYTHON_CMD="$cmd"
            break
        fi
    fi
done

if [[ -z "$PYTHON_CMD" ]]; then
    error "Python ${REQUIRED_PYTHON_MAJOR}.${REQUIRED_PYTHON_MINOR}+ is required but was not found.\n  Install it from https://python.org/downloads or via your package manager."
fi

success "Found Python $VER at $(command -v "$PYTHON_CMD")"

# ── 2. Create virtual environment ─────────────────────────────────────────────
if [[ -d "$VENV_DIR" ]]; then
    warn "Virtual environment '$VENV_DIR' already exists — skipping creation."
else
    info "Creating virtual environment in '$VENV_DIR'…"
    "$PYTHON_CMD" -m venv "$VENV_DIR"
    success "Virtual environment created."
fi

# ── 3. Activate and install dependencies ─────────────────────────────────────
info "Installing dependencies from requirements.txt…"
"$VENV_DIR/bin/pip" install --quiet --upgrade pip
"$VENV_DIR/bin/pip" install --quiet -r requirements.txt
success "Dependencies installed."

# ── 4. Verify installation ────────────────────────────────────────────────────
info "Verifying installation…"
"$VENV_DIR/bin/python" -c "from recon import __version__; print(f'recon v{__version__} — OK')"
success "Verification passed."

# ── 5. Done ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║  Installation complete!                   ║${RESET}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${RESET}"
echo ""
echo "  Activate the virtual environment:"
echo -e "    ${CYAN}source ${VENV_DIR}/bin/activate${RESET}"
echo ""
echo "  Then run the tool:"
echo -e "    ${CYAN}python main.py --help${RESET}"
echo -e "    ${CYAN}python main.py discover 192.168.1.0/24${RESET}"
echo -e "    ${CYAN}python main.py dns example.com${RESET}"
echo ""
