#!/usr/bin/env bash
# smart-terminal-setup installer for Unix-like environments (Git Bash, macOS, Linux)
# Part of claude-workshop: https://github.com/edimuj/claude-workshop
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/bin"

detect_os() {
    case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        Darwin)               echo "macos" ;;
        Linux)                echo "linux" ;;
        *)                    echo "unknown" ;;
    esac
}

detect_terminal() {
    echo "${TERM_PROGRAM:-unknown}"
}

# Terminals natively supported by Claude Code's /terminal-setup
is_builtin_supported() {
    case "$1" in
        vscode|Alacritty|Zed|WarpTerminal|WezTerm|kitty|iTerm.app|ghostty)
            return 0 ;;
        *)
            return 1 ;;
    esac
}

install_tabby_windows() {
    echo "==> Configuring Shift+Enter for Tabby on Windows..."

    # Check for AutoHotkey
    if ! command -v autohotkey &>/dev/null; then
        echo "AutoHotkey v2 is required but not installed."
        read -p "Install via winget? [Y/n] " answer
        answer="${answer:-Y}"
        if [[ "$answer" =~ ^[Yy] ]]; then
            winget install AutoHotkey.AutoHotkey --accept-source-agreements --accept-package-agreements
        else
            echo "Skipping AutoHotkey installation. Setup cannot continue."
            exit 1
        fi
    fi

    # Install AHK script
    mkdir -p "$BIN_DIR"
    local ahk_src="$SCRIPT_DIR/tabby-shift-enter.ahk"
    local ahk_dst="$BIN_DIR/tabby-shift-enter.ahk"

    if [[ -f "$ahk_src" ]]; then
        cp "$ahk_src" "$ahk_dst"
    else
        # Fallback: write script directly
        cat > "$ahk_dst" << 'AHK'
; Shift+Enter → newline in Tabby (for Claude Code multi-line input)
; Part of smart-terminal-setup from claude-workshop
; https://github.com/edimuj/claude-workshop
#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe Tabby.exe") or WinActive("ahk_exe tabby.exe")
+Enter::
{
    Send "{Escape}{Enter}"
}
#HotIf
AHK
    fi

    echo "    Installed: $ahk_dst"

    # Launch the script
    powershell.exe -Command "Start-Process '$ahk_dst'" 2>/dev/null || true
    echo "    Script launched."

    # Auto-start prompt
    read -p "Add to Windows startup? [Y/n] " startup
    startup="${startup:-Y}"
    if [[ "$startup" =~ ^[Yy] ]]; then
        local win_path
        win_path=$(cygpath -w "$ahk_dst")
        powershell.exe -Command "
            \$ws = New-Object -ComObject WScript.Shell
            \$s = \$ws.CreateShortcut(\"\$env:APPDATA\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\tabby-shift-enter.lnk\")
            \$s.TargetPath = '$win_path'
            \$s.Save()
        "
        echo "    Added to Windows startup."
    fi

    echo ""
    echo "Done! Shift+Enter now inserts newlines in Claude Code when using Tabby."
}

main() {
    local os terminal
    os=$(detect_os)
    terminal=$(detect_terminal)

    echo "smart-terminal-setup"
    echo "Terminal: $terminal"
    echo "OS:       $os"
    echo ""

    if is_builtin_supported "$terminal"; then
        echo "Your terminal ($terminal) is supported by Claude Code's built-in /terminal-setup."
        echo "Run /terminal-setup inside Claude Code instead."
        exit 0
    fi

    case "$terminal" in
        Tabby)
            case "$os" in
                windows)
                    install_tabby_windows
                    ;;
                *)
                    echo "Tabby on $os does not support custom key-to-sequence mappings."
                    echo ""
                    echo "Alternatives:"
                    echo "  1. Use \\ + Enter for multi-line input (works now, no setup)"
                    echo "  2. Switch to a terminal with native Shift+Enter support:"
                    echo "     - iTerm2, WezTerm, Ghostty, Kitty (native)"
                    echo "     - Alacritty (configurable)"
                    ;;
            esac
            ;;
        *)
            echo "Terminal '$terminal' is not yet supported by this setup script."
            echo ""
            echo "Workarounds:"
            echo "  1. Use \\ + Enter for multi-line input (works in any terminal)"
            echo "  2. Configure your terminal to send ESC (0x1B) + LF (0x0A) on Shift+Enter"
            echo "  3. Open an issue: https://github.com/edimuj/claude-workshop/issues"
            ;;
    esac
}

main "$@"
