# Claude Workshop

A collection of useful plugins and tools for Claude Code.

## Installation

Add the marketplace to Claude Code:

```
/plugin marketplace add edimuj/claude-workshop
```

Then install any plugin:

```
/plugin install cli-screenshot
```

## Available Plugins

### cli-screenshot

Generate beautiful terminal screenshots for documentation and READMEs.

**Usage:**
```
/cli-screenshot:screenshot Show a git status with modified files
```

**Features:**
- macOS-style terminal window with traffic light buttons
- Tokyo Night color theme with syntax highlighting
- Transparent background (PNG)
- Customizable dimensions and content

**Requirements:**
- Python 3.6+
- shot-scraper (`pip install shot-scraper && shot-scraper install`)

## Adding New Plugins

Each plugin lives in `plugins/<plugin-name>/` with this structure:

```
plugins/my-plugin/
├── .claude-plugin/
│   └── plugin.json      # Plugin manifest
├── commands/
│   └── my-command.md    # Skill definitions
├── hooks/               # Optional lifecycle hooks
└── scripts/             # Optional helper scripts
```

Update `marketplace.json` to include the new plugin.

## License

Apache 2.0
