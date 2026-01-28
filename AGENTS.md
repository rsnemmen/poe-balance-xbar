# Agent Development Guidelines for poe-credits

## Project Overview
This is a Python command-line tool that displays remaining POE API credits. It uses the requests library for HTTP calls and supports command-line argument parsing.

## Build Commands
- `pip install -e .` - Install the package in development mode
- `pip install -e .[dev]` - Install with development dependencies (if defined)
- `python -m py_compile poe_credits.py` - Compile Python file to check syntax

## Lint Commands
- `ruff check .` - Run Ruff code quality checks
- `ruff format .` - Format code with Ruff
- `mypy poe_credits.py` - Run mypy type checking
- `flake8 poe_credits.py` - Run flake8 style checks

## Test Commands
- `python -m pytest` - Run all tests (if tests exist)
- `python -m pytest tests/` - Run tests in tests directory (if exists)
- `python -m pytest --tb=short` - Run tests with short tracebacks
- `python -c "import poe_credits; print('Import successful')" ` - Validate import
- For single test: `python -m pytest test_file.py::test_function_name` (if applicable)
- `python poe_credits.py` - Direct script execution for basic testing

## Python Code Style Guidelines

### Imports
- Standard library imports first
- Third-party imports second
- Local imports third
- Group imports with blank lines between each group
- Use `from typing import Optional` style for type hints
- Use absolute imports

### Formatting
- Use 4 spaces for indentation
- Maximum line length: 88 characters
- Use black-style formatting
- One statement per line
- Use f-strings for string formatting
- Use docstrings for all functions (Google style)

### Naming Conventions
- Function names: snake_case
- Class names: PascalCase
- Constants: UPPER_CASE
- Variables: snake_case
- Private methods: _private_method (leading underscore)

### Types
- Use type hints for all function parameters and return values
- Use Optional[T] for values that can be None
- Use Union types for multiple possible types
- Use List[T], Dict[T, U] for collections

### Error Handling
- Use try/except blocks for network calls
- Handle requests.exceptions.RequestException specifically
- Return None or raise appropriate exceptions for invalid API responses
- Use sys.exit(1) for fatal errors with error messages to stderr
- Provide clear error messages for common failure scenarios

### Documentation
- Include docstrings for all functions (Google style)
- Document all parameters and return values
- Include brief module description
- Add usage examples in comments where appropriate

## Cursor/Copilot Rules
No specific Cursor or Copilot rules defined in this repository.

## Special Considerations
- Uses requests library for HTTP calls
- Requires POE_API_KEY environment variable
- Handles API rate limits through HTTP status codes (401 for invalid key)
- Supports human-readable number formatting for large values
- Follows Unix-style command-line conventions with argparse

## Test Structure
The project is structured as a single module with no complex test directory structure. Tests can be added using pytest framework if desired.