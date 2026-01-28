# AGENTS.md

## Build, Lint, and Test Commands

This project is a Python command-line tool that requires no build process. Linting is handled by ruff and mypy.

### Linting
- **Run linter**: `ruff check .`
- **Auto-fix linting issues**: `ruff check --fix .`
- **Run type checker**: `mypy .`

### Testing
- **Run all tests**: `python -m pytest` (if tests exist)
- **Run specific test**: `python -m pytest tests/test_name.py::test_function_name`
- **Run single test file**: `python -m pytest tests/test_file.py`

### Code Style Guidelines

#### Imports
- Standard library imports first
- Third-party imports second
- Local imports third
- Group imports with blank lines between each group

#### Formatting
- Use 4 spaces for indentation (no tabs)
- Maximum line length of 88 characters (PEP 8)
- Use blank lines to separate functions and classes
- Use docstrings for all functions and classes

#### Types
- Use type hints for all function parameters and return values
- Use Optional for parameters that can be None
- Use Union for parameters that accept multiple types
- Prefer built-in types like int, str, list, dict over typing module where appropriate

#### Naming Conventions
- Use `snake_case` for variables and functions
- Use `PascalCase` for classes
- Use `UPPER_CASE` for constants
- Use descriptive names; avoid abbreviations unless widely understood

#### Error Handling
- Prefer explicit exception handling over silent failures
- Use `try/except/finally` blocks for error-prone code
- Raise appropriate built-in exceptions (ValueError, TypeError, etc.)
- Use `sys.exit(1)` with descriptive error messages to exit on critical errors

#### Documentation
- Include docstrings for all public functions and classes
- Use `"""` for docstrings (not single quotes)
- Document all parameters and return values
- Include examples in docstrings when helpful

#### Git Hooks
- Pre-commit hook checks code formatting with ruff and type checking with mypy
- Run `pre-commit install` to set up the hooks

#### Environment
- Project uses Python 3.8+
- Dependencies managed with pip
- `requests` library required for HTTP operations