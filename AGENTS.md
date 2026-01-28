# AGENTS.md

## Build, Lint, and Test Commands

This project is a Python command-line tool. No build process required.

### Linting
- **Run linter**: `ruff check .`
- **Auto-fix linting issues**: `ruff check --fix .`
- **Run type checker**: `mypy .`

### Testing
- **Run all tests**: `python -m pytest` (no tests currently exist)
- **Run specific test**: `python -m pytest tests/test_name.py::test_function_name`
- **Run single test file**: `python -m pytest tests/test_file.py`

### Git Hooks
- Pre-commit hook runs ruff and mypy checks
- Run `pre-commit install` to set up hooks

## Code Style Guidelines

### Imports
- Standard library imports first (os, sys, argparse, etc.)
- Third-party imports second (requests)
- Local imports third
- Group imports with blank lines between each group
- Example:
  ```python
  import os
  import sys
  import argparse
  from typing import Optional
  from datetime import date

  import requests
  ```

### Formatting
- Use 4 spaces for indentation (no tabs)
- Maximum line length of 88 characters (PEP 8)
- Use blank lines to separate functions and classes
- Use blank lines within functions sparingly to separate logical sections
- No trailing whitespace
- End files with a single newline

### Type Hints
- Use type hints for all function parameters and return values
- Use `Optional[T]` for parameters that can be None
- Use `Union[T, U]` for parameters accepting multiple types
- Use built-in types like `int`, `str`, `list`, `dict` over `typing` module where appropriate
- Example:
  ```python
  def format_number(n: int) -> str: ...
  def get_balance(api_key: str) -> Optional[int]: ...
  ```

### Naming Conventions
- Variables and functions: `snake_case`
- Classes: `PascalCase`
- Constants: `UPPER_CASE`
- Use descriptive names; avoid abbreviations unless widely understood
- Private module-level variables: leading underscore (e.g., `_api_endpoint`)

### Error Handling
- Prefer explicit exception handling over silent failures
- Use `try/except/finally` blocks for error-prone code (especially network operations)
- Raise appropriate built-in exceptions (ValueError, TypeError, etc.)
- Use `sys.exit(1)` with descriptive error messages for CLI errors
- Example:
  ```python
  try:
      balance = get_balance(api_key)
  except requests.exceptions.RequestException as e:
      print(f"Error: {e}", file=sys.stderr)
      sys.exit(1)
  ```

### Documentation
- Include docstrings for all public functions and classes
- Use triple double quotes `"""` for docstrings (not single quotes)
- Document all parameters and return values
- Include examples in docstrings when helpful
- Keep docstrings concise but informative
- Example:
  ```python
  def days_since_day(since_day: int) -> int:
      """Calculate days passed since a given day of the month."""
      ...
  ```

### Code Structure
- Keep functions focused and single-purpose
- Maximum ~50 lines per function when possible
- Put main logic in `main()` function
- Use `if __name__ == "__main__":` guard for CLI entry point

### Project-Specific Notes
- Environment variable: `POE_API_KEY` must be set for the tool to work
- API endpoint: `https://api.poe.com/usage/current_balance`
- Dependencies: `requests` library for HTTP operations
- Python version: 3.8+ (uses walrus operator in code, requires 3.8+)

### Critical Rules
- NEVER commit or expose API keys or secrets
- Always use environment variables for credentials
- Never print sensitive information to stdout
- Write errors to stderr, not stdout

### Running the Tool
```bash
# With environment variable
export POE_API_KEY="your_key"
./poe_balance.py

# Or inline
POE_API_KEY="your_key" python3 poe_balance.py

# With --since argument
./poe_balance.py --since 15
```
