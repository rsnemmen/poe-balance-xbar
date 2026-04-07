# AGENTS.md

## Project Overview

This is a SwiftBar/xbar plugin to display remaining Poe API points in the macOS menu bar. The tool queries the Poe API to get the current point balance and optionally calculates expected points based on average usage.

## Build, Lint, and Test Commands

No build process required. No tests currently exist. No pre-commit hooks configured.

## Shell Script Guidelines (for `poe_balance.30m.sh`)

### Bash Style
- Use `#!/usr/bin/env bash` shebang
- Use 2 spaces for indentation in shell scripts
- Quote all variables: `"$VAR"` not `$VAR`
- Use `[[ ]]` for conditionals instead of `[ ]` when available
- Use `$(command)` instead of backticks for command substitution

### Error Handling in Shell
- Use `set -euo pipefail` at the top of scripts when appropriate
- Always check exit codes from critical commands
- Redirect errors to stderr: `echo "Error" >&2`
- For SwiftBar plugins, always use `exit 0` for error conditions — `exit 1` prevents SwiftBar from showing the Poe icon with an error indicator.

### SwiftBar/xbar Plugin Format
- Include metadata comments at the top:
  ```bash
  #<xbar.title>Plugin Name</xbar.title>
  #<xbar.version>1.0</xbar.version>
  ```
- Use `templateImage=` for icons that adapt to dark/light mode
- Use `image=` for fixed-color icons
- Include xbar variables for user configuration:
  ```bash
  #<xbar.var>boolean(VAR_NAME="true"): Description</xbar.var>
  #<xbar.var>number(VAR_NAME="21"): Description</xbar.var>
  ```

### SwiftBar Output Protocol
- **First `echo` line** = menu bar text; pipe-separated params: `templateImage=`, `color=`, `image=`
- **`echo "---"`** = separator between the menu bar line and dropdown items
- **Subsequent lines** = dropdown menu items
- **Always `exit 0` on errors** — never `exit 1` from the plugin

## Project-Specific Notes

### Environment and API
- Environment variable: `POE_API_KEY` must be set for the tool to work
- API endpoint: `https://api.poe.com/usage/current_balance`
- Dependencies: `curl`, `bc`

### Shell Script API Key Discovery Chain
The shell script uses a multi-method discovery chain (env var → `.zshrc` → `.zshenv` → `.bashrc`) because SwiftBar runs as a GUI app without shell environment. **Do not simplify this chain** — all fallback methods are intentional.

### Critical Rules
- NEVER commit or expose API keys or secrets
- Always use environment variables for credentials
- Never print sensitive information to stdout
- Write errors to stderr, not stdout
- Use Bearer token authentication for API calls

### Output Format
Points are displayed in human-readable format:
| Range | Example |
|-------|---------|
| < 1,000 | `500` |
| 1,000 - 999,999 | `150k` |
| 1,000,000 - 999,999,999 | `1.5M` |
| 1B+ | `1.2B` |

### Key Constants
- `INITIAL_BALANCE = 1,000,000` (monthly Poe point allocation)
- `DAILY_POINTS = 32,895` (1M / 30.4 days)

### Dependencies
- Document dependencies in `<xbar.dependencies>` comment
- Currently requires: `curl`, `bc`
- Uses `sed` for JSON parsing (no `jq` dependency) and `bc` for floating-point math — this is intentional. Do not introduce `jq` or other external tools.

## Git Workflow

### Commit Guidelines
- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests liberally after first line
