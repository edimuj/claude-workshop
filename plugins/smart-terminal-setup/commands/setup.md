# /smart-terminal-setup:setup

Configure Shift+Enter for multi-line input in Claude Code, for terminals not supported by the built-in `/terminal-setup` command.

## Instructions

### Step 1: Detect Environment

Detect the current terminal and operating system:

```bash
echo "TERM_PROGRAM=$TERM_PROGRAM"
echo "OS=$(uname -s)"
echo "MSYSTEM=$MSYSTEM"
```

Use the results to determine:
- **Terminal**: `TERM_PROGRAM` value (e.g., `Tabby`, `Hyper`, `WarpTerminal`)
- **OS**: Windows (MINGW/MSYS), macOS (Darwin), or Linux

If `TERM_PROGRAM` is empty or corresponds to a terminal already supported by `/terminal-setup` (VS Code, Alacritty, Zed, Warp, WezTerm, Kitty, iTerm2, Ghostty), inform the user they can use the built-in `/terminal-setup` command instead and stop.

### Step 2: Route by Terminal + OS

#### Tabby on Windows (MINGW/MSYS)

Tabby does not natively support custom key-to-escape-sequence mappings. The solution uses an AutoHotkey v2 script that intercepts Shift+Enter when Tabby is focused and sends the ESC + Enter key sequence that Claude Code interprets as "insert newline."

**Check if AutoHotkey v2 is installed:**

```bash
powershell -Command "Get-Command autohotkey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source"
```

If not found, check via winget:

```bash
winget list AutoHotkey.AutoHotkey 2>/dev/null
```

**If AutoHotkey is not installed**, ask the user if they want to install it:

> AutoHotkey v2 is required to configure Shift+Enter in Tabby on Windows. Would you like me to install it via winget?

If yes:

```bash
winget install AutoHotkey.AutoHotkey --accept-source-agreements --accept-package-agreements
```

**Install the AHK script:**

Copy the script from the plugin's scripts directory to the user's local bin:

```bash
mkdir -p ~/bin
cp plugins/smart-terminal-setup/scripts/tabby-shift-enter.ahk ~/bin/tabby-shift-enter.ahk
```

If the plugin path is not accessible (e.g., running from marketplace install), create the script directly in `~/bin/tabby-shift-enter.ahk` with this content:

```autohotkey
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
```

**Launch the script:**

```bash
powershell -Command "Start-Process '$HOME\bin\tabby-shift-enter.ahk'"
```

**Ask the user if they want it to auto-start with Windows:**

> The script is now running. Would you like it to start automatically when Windows boots?

If yes, create a shortcut in the Windows startup folder:

```powershell
powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut(\"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\tabby-shift-enter.lnk\"); $s.TargetPath = \"$env:USERPROFILE\bin\tabby-shift-enter.ahk\"; $s.Save()"
```

**Verify it works** by telling the user:

> Shift+Enter should now insert newlines in Claude Code when running inside Tabby. Try it now: type some text, press Shift+Enter, then type more text.

#### Tabby on macOS/Linux

Tabby on macOS/Linux also lacks native key-to-sequence mapping. Suggest alternatives:

1. Use `\` + Enter (backslash then Enter) for multi-line input — works immediately, no setup needed.
2. Switch to a terminal that supports Shift+Enter natively (iTerm2, WezTerm, Ghostty, Kitty) or via config (Alacritty).
3. If using a desktop environment, suggest `xdotool`-based solution or similar key remapper (e.g., `keyd`, `xremap`).

#### Hyper on any OS

Hyper supports custom key mappings via `~/.hyper.js`. Guide the user to add:

```javascript
module.exports = {
  config: {
    // ... existing config
  },
  keymaps: {
    'editor:newline': 'shift+enter',
  },
};
```

Or suggest adding a Hyper plugin that sends the raw escape sequence.

#### Other / Unknown Terminals

For terminals not specifically handled:

1. Tell the user their terminal (`$TERM_PROGRAM`) is not yet specifically supported by this plugin.
2. Explain the mechanism: Shift+Enter needs to send the byte sequence ESC (0x1B) followed by newline (0x0A) to the terminal.
3. Suggest checking their terminal's documentation for custom key binding configuration.
4. Mention that `\` + Enter works as a universal fallback in any terminal.
5. Suggest opening an issue at https://github.com/edimuj/claude-workshop/issues to request support for their terminal.

### Step 3: Summary

After setup, provide a summary of what was configured:

- Terminal detected
- Method used (AHK script, config file, etc.)
- How to use it (Shift+Enter for newlines)
- How to disable/uninstall if needed
- Remind about `\` + Enter as a universal fallback
