#!/bin/bash
# Setup script for cli-screenshot plugin
# Installs required dependencies: Python 3 and shot-scraper

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=== cli-screenshot Plugin Setup ==="
echo ""

# Check Python 3
echo -n "Checking Python 3... "
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    echo -e "${GREEN}found${NC} (v${PYTHON_VERSION})"
else
    echo -e "${RED}not found${NC}"
    echo ""
    echo "Python 3 is required but not installed."
    echo "Install it using your package manager:"
    echo "  - macOS:  brew install python3"
    echo "  - Ubuntu: sudo apt install python3"
    echo "  - Fedora: sudo dnf install python3"
    exit 1
fi

# Check if shot-scraper is already installed
echo -n "Checking shot-scraper... "
if command -v shot-scraper &> /dev/null; then
    SHOT_VERSION=$(shot-scraper --version 2>&1 | head -1)
    echo -e "${GREEN}found${NC} (${SHOT_VERSION})"
    echo ""
    echo -e "${GREEN}All dependencies are already installed!${NC}"
    exit 0
fi

echo -e "${YELLOW}not found${NC}"
echo ""

# Determine installation method
INSTALL_METHOD=""

if command -v pipx &> /dev/null; then
    INSTALL_METHOD="pipx"
    echo "Found pipx - will use it for isolated installation (recommended)"
elif command -v pip3 &> /dev/null; then
    INSTALL_METHOD="pip3"
    echo "Found pip3 - will use it for installation"
elif command -v pip &> /dev/null; then
    INSTALL_METHOD="pip"
    echo "Found pip - will use it for installation"
else
    echo -e "${RED}Error: No pip or pipx found${NC}"
    echo "Please install pip first:"
    echo "  - macOS:  brew install python3 (includes pip)"
    echo "  - Ubuntu: sudo apt install python3-pip"
    exit 1
fi

echo ""
echo "Installing shot-scraper using ${INSTALL_METHOD}..."
echo ""

case $INSTALL_METHOD in
    pipx)
        pipx install shot-scraper
        ;;
    pip3)
        pip3 install --user shot-scraper
        ;;
    pip)
        pip install --user shot-scraper
        ;;
esac

# Verify installation
echo ""
echo -n "Verifying shot-scraper installation... "
if command -v shot-scraper &> /dev/null; then
    echo -e "${GREEN}success${NC}"
else
    # Check if it's in user's local bin (pip --user)
    USER_BIN="$HOME/.local/bin"
    if [ -f "$USER_BIN/shot-scraper" ]; then
        echo -e "${YELLOW}installed but not in PATH${NC}"
        echo ""
        echo "Add this to your shell profile (~/.bashrc or ~/.zshrc):"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
        echo "Then restart your terminal or run: source ~/.bashrc"
        exit 1
    else
        echo -e "${RED}failed${NC}"
        exit 1
    fi
fi

# Install browser for shot-scraper (Playwright/Chromium)
echo ""
echo "Installing browser for screenshot capture..."
shot-scraper install

echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "You can now use the cli-screenshot plugin:"
echo "  /cli-screenshot:screenshot <description>"
