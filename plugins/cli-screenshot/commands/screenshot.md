# /cli-screenshot:screenshot

Generate a polished terminal screenshot based on the user's description.

## Instructions

### Step 0: Check and Install Dependencies

Verify the required tools are installed:

```bash
command -v python3 && command -v shot-scraper
```

**If Python 3 is missing:** Tell the user to install it:

- macOS: `brew install python3`
- Ubuntu/Debian: `sudo apt install python3`
- Fedora: `sudo dnf install python3`

**If shot-scraper is missing:** Offer to install it automatically.

Ask the user: "shot-scraper is not installed. Would you like me to install it now?"

If yes, run the setup script:

```bash
bash plugins/cli-screenshot/scripts/setup.sh
```

The setup script handles detection of pipx/pip, PATH issues, and browser installation.

**Manual alternative** (if setup script fails):

```bash
# Using pipx (recommended)
pipx install shot-scraper && shot-scraper install

# Or using pip
pip3 install --user shot-scraper && shot-scraper install
```

If `shot-scraper` is still not found after pip install, add `~/.local/bin` to PATH.

### Step 1: Gather Requirements

Ask the user (if not clear from their request):

- What command/output should be shown?
- What filename to save as? (default: `cli-screenshot.png`)
- What directory to save in? (default: `./assets/`)
- Terminal title? (default: `terminal — zsh`)
- Theme? (default: `tokyo-night`)

**Available templates** in `plugins/cli-screenshot/templates/`:

| Template            | Description                                   |
|---------------------|-----------------------------------------------|
| `tokyo-night.html`  | Dark theme with purple/blue accents (default) |
| `dracula.html`      | Dark theme with vibrant pink/purple colors    |
| `nord.html`         | Arctic, cool blue dark theme                  |
| `github-light.html` | Clean light theme matching GitHub's style     |

### Step 2: Create the HTML Terminal Mockup

1. Read the template file:

```bash
cat plugins/cli-screenshot/templates/{{THEME}}.html
```

2. Copy the template to `/tmp/cli-screenshot.html`, replacing:
    - `{{TERMINAL_TITLE}}` with the terminal title
    - `{{CONTENT}}` with the formatted terminal content

**Content formatting:**

- Prompt: `<span class="prompt">❯</span>`
- User input: `<span class="command">command here</span>`
- Colors: `green` (success), `red` (error), `yellow` (warning), `cyan` (info), `magenta` (functions), `dim` (secondary)
- Spacing: `<div class="mb-1">` between lines

### Step 3: Capture the Screenshot

Start a local server and capture:

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

**Height calculation:** ~24px per line + ~100px for header/padding. Typical range: 400-1000px.

Show the user the resulting screenshot using the Read tool.

### Step 4: Cleanup

```bash
rm /tmp/cli-screenshot.html
```

Report the saved screenshot path to the user.
