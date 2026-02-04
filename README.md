<p align="center">
  <img src="https://raw.githubusercontent.com/edimuj/claude-workshop/main/assets/claude-workshop-mascot-200.png" alt="Claude Workshop Mascot" />
</p>

<h1 align="center">Claude Workshop</h1>

<p align="center">
  <strong>A collection of useful plugins and tools for Claude Code</strong>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache%202.0-blue.svg" alt="License" /></a>
  <a href="https://github.com/edimuj/claude-workshop/issues"><img src="https://img.shields.io/github/issues/edimuj/claude-workshop" alt="Issues" /></a>
</p>

---

## Quick Start

Add the marketplace to Claude Code:

```bash
/plugin marketplace add edimuj/claude-workshop
```

Install a plugin:

```bash
/plugin install cli-screenshot
```

## Plugins

### cli-screenshot

Generate beautiful terminal screenshots for documentation and READMEs.

```bash
/cli-screenshot:screenshot Show a git status with modified files
```

**Features:**

- macOS-style terminal window with traffic light buttons
- Multiple themes: Tokyo Night, Dracula, Nord, GitHub Light
- Syntax highlighting for commands and output
- Transparent PNG background

**Requirements:** Python 3.6+ (shot-scraper installed automatically)

[View documentation](plugins/cli-screenshot/README.md)

## Plugin Development

Create your own plugins with this structure:

```
plugins/my-plugin/
├── .claude-plugin/
│   └── plugin.json       # Plugin manifest
├── commands/
│   └── my-command.md     # Skill definitions
├── templates/            # Optional templates
├── scripts/              # Optional helper scripts
└── README.md             # Documentation
```

Add your plugin to `marketplace.json` to make it available.

## Related Projects

Other Claude Code tools by the same author:

| Project                                                                | Description                                                        |
|------------------------------------------------------------------------|--------------------------------------------------------------------|
| [claude-mneme](https://github.com/edimuj/claude-mneme)                 | Persistent memory plugin for Claude Code                           |
| [vexscan-claude-code](https://github.com/edimuj/vexscan-claude-code)   | Security vulnerability scanner plugin for Claude Code              |
| [claude-simple-status](https://github.com/edimuj/claude-simple-status) | Simple status line for Claude Code                                 |
| [tokenlean](https://github.com/edimuj/tokenlean)                       | CLI tools to explore codebases efficiently and save context tokens |

## Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a plugin in `plugins/your-plugin/`
3. Add it to `marketplace.json`
4. Submit a pull request

## License

[Apache 2.0](LICENSE)
