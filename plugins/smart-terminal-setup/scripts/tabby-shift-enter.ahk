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
