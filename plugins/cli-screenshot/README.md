# cli-screenshot

Generate beautiful terminal screenshots for documentation and READMEs. Creates polished macOS-style terminal mockups
with syntax highlighting.

## Requirements

- Python 3.6+
- shot-scraper (installed automatically on first use)

## Usage

```
/cli-screenshot:screenshot <description of what to show>
```

## Examples

```
/cli-screenshot:screenshot Show a git status with modified files
/cli-screenshot:screenshot Create npm install output with some warnings
/cli-screenshot:screenshot Capture "ls -la" output showing a project directory
```

## Features

- macOS-style terminal window with traffic light buttons
- Multiple color themes
- Syntax highlighting for commands and output
- Transparent PNG background
- Customizable dimensions and content

## Themes

| Theme          | Style                                   |
|----------------|-----------------------------------------|
| `tokyo-night`  | Dark with purple/blue accents (default) |
| `dracula`      | Dark with vibrant pink/purple           |
| `nord`         | Arctic, cool blue tones                 |
| `github-light` | Clean light theme                       |

Specify a theme in your request: `/cli-screenshot:screenshot git status --theme dracula`

## Color Classes

All themes support these CSS classes:

| Class      | Use for                       |
|------------|-------------------------------|
| `.green`   | Success, additions, OK status |
| `.red`     | Errors, deletions, critical   |
| `.yellow`  | Warnings, medium severity     |
| `.orange`  | High severity, attention      |
| `.cyan`    | Info, numbers, paths          |
| `.magenta` | Functions, keywords           |
| `.blue`    | Links, prompts                |
| `.dim`     | Secondary text, comments      |
| `.command` | User input                    |
| `.prompt`  | Shell prompt                  |

## License

Apache-2.0
