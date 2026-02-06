# smart-terminal-setup installer for Windows (PowerShell)
# Part of claude-workshop: https://github.com/edimuj/claude-workshop
#Requires -Version 5.1

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BinDir = Join-Path $env:USERPROFILE "bin"
$AhkDst = Join-Path $BinDir "tabby-shift-enter.ahk"

# Terminals natively supported by Claude Code's /terminal-setup
$BuiltinTerminals = @("vscode", "Alacritty", "Zed", "WarpTerminal", "WezTerm", "kitty", "iTerm.app", "ghostty")

function Get-Terminal {
    $term = $env:TERM_PROGRAM
    if (-not $term) { return "unknown" }
    return $term
}

function Test-AutoHotkey {
    try {
        $ahk = Get-Command autohotkey -ErrorAction SilentlyContinue
        return $null -ne $ahk
    } catch {
        return $false
    }
}

function Install-AutoHotkey {
    Write-Host "AutoHotkey v2 is required but not installed."
    $answer = Read-Host "Install via winget? [Y/n]"
    if (-not $answer -or $answer -match "^[Yy]") {
        winget install AutoHotkey.AutoHotkey --accept-source-agreements --accept-package-agreements
    } else {
        Write-Host "Skipping installation. Setup cannot continue."
        exit 1
    }
}

function Install-TabbyWindows {
    Write-Host "==> Configuring Shift+Enter for Tabby on Windows..."

    # Check AutoHotkey
    if (-not (Test-AutoHotkey)) {
        Install-AutoHotkey
    }

    # Create bin directory
    if (-not (Test-Path $BinDir)) {
        New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
    }

    # Install AHK script
    $ahkSrc = Join-Path $ScriptDir "tabby-shift-enter.ahk"
    if (Test-Path $ahkSrc) {
        Copy-Item $ahkSrc $AhkDst -Force
    } else {
        # Fallback: write script directly
        @"
; Shift+Enter -> newline in Tabby (for Claude Code multi-line input)
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
"@ | Set-Content -Path $AhkDst -Encoding UTF8
    }

    Write-Host "    Installed: $AhkDst"

    # Launch
    Start-Process $AhkDst
    Write-Host "    Script launched."

    # Auto-start prompt
    $startup = Read-Host "Add to Windows startup? [Y/n]"
    if (-not $startup -or $startup -match "^[Yy]") {
        $startupDir = [Environment]::GetFolderPath("Startup")
        $lnkPath = Join-Path $startupDir "tabby-shift-enter.lnk"
        $ws = New-Object -ComObject WScript.Shell
        $shortcut = $ws.CreateShortcut($lnkPath)
        $shortcut.TargetPath = $AhkDst
        $shortcut.Save()
        Write-Host "    Added to Windows startup."
    }

    Write-Host ""
    Write-Host "Done! Shift+Enter now inserts newlines in Claude Code when using Tabby."
}

# Main
$terminal = Get-Terminal
Write-Host "smart-terminal-setup"
Write-Host "Terminal: $terminal"
Write-Host "OS:       Windows"
Write-Host ""

if ($BuiltinTerminals -contains $terminal) {
    Write-Host "Your terminal ($terminal) is supported by Claude Code's built-in /terminal-setup."
    Write-Host "Run /terminal-setup inside Claude Code instead."
    exit 0
}

switch ($terminal) {
    "Tabby" {
        Install-TabbyWindows
    }
    default {
        Write-Host "Terminal '$terminal' is not yet supported by this setup script."
        Write-Host ""
        Write-Host "Workarounds:"
        Write-Host "  1. Use \ + Enter for multi-line input (works in any terminal)"
        Write-Host "  2. Configure your terminal to send ESC (0x1B) + LF (0x0A) on Shift+Enter"
        Write-Host "  3. Open an issue: https://github.com/edimuj/claude-workshop/issues"
    }
}
