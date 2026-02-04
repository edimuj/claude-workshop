# /cli-screenshot:screenshot

Generate beautiful terminal screenshots for documentation and READMEs.

## Usage

```
/cli-screenshot:screenshot <description of what to show>
```

## Examples

- `/cli-screenshot:screenshot Show a git status with modified files`
- `/cli-screenshot:screenshot Create npm install output with some warnings`
- `/cli-screenshot:screenshot Capture "ls -la" output showing a project directory`

## Prerequisites

This plugin requires:
- **Python 3.6+** (for local HTTP server)
- **shot-scraper** (for capturing screenshots)

Install shot-scraper: `pip install shot-scraper && shot-scraper install`

## Instructions

When the user invokes this skill, create a polished terminal screenshot:

### Step 0: Check Dependencies

First, verify the required tools are installed:

```bash
which python3 && which shot-scraper
```

If `shot-scraper` is missing, tell the user:
```
shot-scraper is required but not installed. Install it with:
  pip install shot-scraper && shot-scraper install
```

### Step 1: Gather Requirements

Ask the user (if not clear from their request):

- What command/output should be shown?
- What filename to save as? (default: `cli-screenshot.png`)
- What directory to save in? (default: `./assets/`)
- Terminal title? (default: `terminal — zsh`)

### Step 2: Create the HTML Terminal Mockup

Create an HTML file with this structure. Customize the content based on the user's request:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terminal Screenshot</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: transparent;
            padding: 20px;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        .terminal {
            background: #1a1b26;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            max-width: 720px;
            margin: 0 auto;
        }

        .terminal-header {
            background: #24283b;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .terminal-button {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }

        .terminal-button.red { background: #f7768e; }
        .terminal-button.yellow { background: #e0af68; }
        .terminal-button.green { background: #9ece6a; }

        .terminal-title {
            flex: 1;
            text-align: center;
            color: #565f89;
            font-size: 13px;
            margin-right: 52px;
        }

        .terminal-content {
            padding: 20px;
            font-family: 'SF Mono', 'Fira Code', 'JetBrains Mono', Consolas, monospace;
            font-size: 13px;
            line-height: 1.6;
            color: #a9b1d6;
        }

        /* Colors - Tokyo Night theme */
        .prompt { color: #7aa2f7; }
        .command { color: #c0caf5; }
        .dim { color: #565f89; }
        .green { color: #9ece6a; }
        .yellow { color: #e0af68; }
        .red { color: #f7768e; }
        .cyan { color: #7dcfff; }
        .magenta { color: #bb9af7; }
        .blue { color: #7aa2f7; }
        .orange { color: #ff9e64; }
        .bold { font-weight: 600; }
        .mb-1 { margin-bottom: 8px; }
        .mb-2 { margin-bottom: 16px; }
        .mt-1 { margin-top: 8px; }
        .mt-2 { margin-top: 16px; }
        .indent { padding-left: 16px; }
    </style>
</head>
<body>
<div class="terminal">
    <div class="terminal-header">
        <div class="terminal-button red"></div>
        <div class="terminal-button yellow"></div>
        <div class="terminal-button green"></div>
        <div class="terminal-title">{{TERMINAL_TITLE}}</div>
    </div>
    <div class="terminal-content">
        {{CONTENT}}
    </div>
</div>
</body>
</html>
```

**Content formatting tips:**

- Use `<span class="prompt">❯</span>` for the prompt
- Use `<span class="command">command here</span>` for user input
- Use color classes: `green` (success), `red` (error), `yellow` (warning), `cyan` (info), `magenta` (functions), `dim` (secondary text)
- Use `<div class="mb-1">` for spacing between lines
- For code/output lines, wrap in appropriate color spans

### Step 3: Capture the Screenshot

1. Save the HTML file temporarily (e.g., `/tmp/cli-screenshot.html`)

2. Start a local server and capture:

```bash
cd /tmp && python3 -m http.server 8765 &
sleep 2
shot-scraper shot http://localhost:8765/cli-screenshot.html \
  -o {{OUTPUT_PATH}} \
  -w 800 \
  -h {{HEIGHT}} \
  --wait 500 \
  --omit-background
pkill -f "python3 -m http.server 8765"
```

**Height calculation:** Estimate ~24px per line of content, plus ~100px for header/padding. Typical range: 400-1000px.

3. Show the user the resulting screenshot using the Read tool

### Step 4: Cleanup

- Remove the temporary HTML file: `rm /tmp/cli-screenshot.html`
- Report the saved screenshot path to the user

## Color Reference (Tokyo Night Theme)

| Class      | Color   | Use for                       |
|------------|---------|-------------------------------|
| `.green`   | #9ece6a | Success, additions, OK status |
| `.red`     | #f7768e | Errors, deletions, critical   |
| `.yellow`  | #e0af68 | Warnings, medium severity     |
| `.orange`  | #ff9e64 | High severity, attention      |
| `.cyan`    | #7dcfff | Info, numbers, paths          |
| `.magenta` | #bb9af7 | Functions, keywords           |
| `.blue`    | #7aa2f7 | Links, prompts                |
| `.dim`     | #565f89 | Secondary text, comments      |
| `.command` | #c0caf5 | User input                    |
