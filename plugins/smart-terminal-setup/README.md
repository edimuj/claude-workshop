# smart-terminal-setup

Smart terminal configuration for Claude Code. Extends the built-in `/terminal-setup` command to support terminals that Claude Code doesn't configure natively.

## The Problem

Claude Code's `/terminal-setup` command configures Shift+Enter for multi-line input, but only supports a handful of terminals (VS Code, Alacritty, Zed, Warp, WezTerm, Kitty, iTerm2, Ghostty). If you use a different terminal like Tabby, the command fails and you're stuck without multi-line input.

## The Solution

This plugin detects your terminal and OS, then applies the right configuration method:

| Terminal | OS      | Method                    |
|----------|---------|---------------------------|
| Tabby    | Windows | AutoHotkey v2 script      |
| Tabby    | macOS   | Guidance + alternatives   |
| Tabby    | Linux   | Guidance + alternatives   |
| Hyper    | Any     | `.hyper.js` configuration |
| Other    | Any     | Generic guidance          |

## Usage

### As a Claude Code Skill

```bash
/smart-terminal-setup:setup
```

Claude will detect your environment and guide you through the setup interactively.

### Standalone Scripts

**Git Bash / macOS / Linux:**

```bash
bash plugins/smart-terminal-setup/scripts/setup.sh
```

**PowerShell (Windows):**

```powershell
.\plugins\smart-terminal-setup\scripts\setup.ps1
```

## Supported Terminals

### Tabby (Windows)

Uses an [AutoHotkey v2](https://www.autohotkey.com/) script that:
- Intercepts Shift+Enter when Tabby is the active window
- Sends ESC + Enter, which Claude Code interprets as "insert newline"
- Optionally auto-starts with Windows

**Requirements:** AutoHotkey v2 (installer will offer to install via winget)

### Universal Fallback

In any terminal, you can type `\` (backslash) at the end of a line and press Enter to insert a newline. No setup required.

## How It Works

Claude Code's multi-line input accepts the byte sequence `ESC` (0x1B) followed by a newline when Shift+Enter is pressed. Terminals that support this natively just work. For terminals that don't, this plugin bridges the gap using OS-level key remapping tools.

## Uninstall

### Windows (Tabby)

1. Close the AHK script from the system tray (right-click the green "H" icon > Exit)
2. Delete `~/bin/tabby-shift-enter.ahk`
3. Remove the startup shortcut (if added): delete `tabby-shift-enter.lnk` from `shell:startup`

## Contributing

To add support for a new terminal:

1. Add a detection case in `commands/setup.md`
2. Add the setup logic to `scripts/setup.sh` and `scripts/setup.ps1`
3. Update this README
4. Submit a PR to [claude-workshop](https://github.com/edimuj/claude-workshop)

## License

[Apache 2.0](../../LICENSE)
