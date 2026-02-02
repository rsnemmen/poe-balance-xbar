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

### Documentation
- Include docstrings for all public functions and classes
- Use triple double quotes `"""` for docstrings (not single quotes)
- Document all parameters and return values
- Include examples in docstrings when helpful
- Keep docstrings concise but informative

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

## Shell Script Guidelines (for `poe_balance.1h.sh`)

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
- Use `exit 1` for error conditions

### SwiftBar/xbar Plugin Format
- Include metadata comments at the top:
  ```bash
  #<xbar.title>Plugin Name</xbar.title>
  #<xbar.version>1.0</xbar.version>
  ```
- Use `templateImage=` for icons that adapt to dark/light mode
- Use `image=` for fixed-color icons

## Dependency Management

### Python Dependencies
- No formal requirements.txt - install manually: `pip install requests`
- Keep dependencies minimal (only `requests` currently required)

### Shell Script Dependencies
- Document dependencies in `<xbar.dependencies>` comment
- Currently requires: `curl`, `bc`

## Git Workflow

### Pre-Commit Setup
```bash
# Install pre-commit hooks
pre-commit install
```

### Commit Guidelines
- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests liberally after first line

### Testing Best Practices
- Create test files in `tests/` directory: `test_<module>.py`
- Name test functions: `test_<function_name>`
- Use pytest fixtures for common setup
- Mock external API calls in tests
- Tests should not require real API keys
