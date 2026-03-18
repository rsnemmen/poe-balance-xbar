# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A SwiftBar/xbar plugin and CLI tool that displays remaining Poe API credits in the macOS menu bar. Two implementations exist:

- **`poe_balance.30m.sh`** — Bash script, the SwiftBar plugin (runs every 30 minutes). This is the primary, feature-complete implementation. Handles menu bar display, dropdown details, color-coded warnings, billing cycle estimation, and compact display mode.
- **`poe_balance.py`** — Python CLI tool with a subset of features (balance display and `--since` estimation). Requires `requests` (`pip install requests`).

Both query `https://api.poe.com/usage/current_balance` using Bearer token auth via the `POE_API_KEY` environment variable.

## Lint Commands

```bash
ruff check .            # Python linter
ruff check --fix .      # Auto-fix
mypy .                  # Type checking
```

No tests exist. No build step required.

## Architecture Notes

The shell script has a multi-method API key discovery chain (env var -> `.zshrc` -> `.zshenv` -> `.bashrc`) because SwiftBar runs as a GUI app without shell environment. This is intentional — do not simplify it.

The shell script uses `sed` to parse JSON (no `jq` dependency) and `bc` for floating-point math. Dependencies are intentionally minimal (`curl`, `bc`).

Key constants shared between both implementations:
- `INITIAL_BALANCE = 1,000,000` (monthly Poe credit allocation)
- `DAILY_CREDITS = 32,895` (1M / 30.4 days)

SwiftBar plugin metadata (`#<xbar.var>` comments) controls user-configurable variables: `VAR_STARTING_DATE`, `VAR_PERCENT`, `VAR_COMPACT`, `VAR_COLORS`.

## SwiftBar Output Protocol

The shell script follows SwiftBar/xbar output format:
- First `echo` line = menu bar text. Pipe-separated params: `templateImage=`, `color=`, `image=`.
- `echo "---"` = separator between menu bar and dropdown.
- Subsequent lines = dropdown menu items.
- On errors, always `exit 0` (not `exit 1`) so SwiftBar still shows the Poe icon with an error indicator.
