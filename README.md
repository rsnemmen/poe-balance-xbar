# poe-credits

A command-line tool to display remaining POE API credits.

## Usage

1. Set your POE API key:
   ```bash
   export POE_API_KEY="your_api_key_here"
   ```

2. Run the tool:
   ```bash
   poe-credits
   ```

## Direct Script Usage

You can also run the script directly:

```bash
POE_API_KEY="your_api_key_here" python3 poe_credits.py
```

**Note:** When running directly, you need `requests` installed in your Python environment:
```bash
pip install requests
```

## Output

Credits are displayed in human-readable format:

| Range | Example |
|-------|---------|
| < 1,000 | `500` |
| 1,000 - 999,999 | `150k` |
| 1,000,000 - 999,999,999 | `1.5M` |
| 1B+ | `1.2B` |

## Error Messages

- `Error: POE_API_KEY environment variable not set` - Set the `POE_API_KEY` environment variable
- `Error: Invalid API key` - Your API key is invalid or expired
