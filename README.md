# Check Poe API balance remaining

A command-line tool to display remaining POE API balance.

## Usage

(1) Set your POE API key:  

    export POE_API_KEY="your_api_key_here"

(2) Run the tool to display credits:

    ./poe_balance.py

3. Calculate days passed since a given day:
   ```bash
   poe-credits --since 15
   ```

## Direct Script Usage

You can also run the script directly:

```bash
POE_API_KEY="your_api_key_here" python3 poe_balance.py
```

**Note:** When running directly, you need `requests` installed in your Python environment:
```bash
pip install requests
```

## SwiftBar Integration

This tool also works with SwiftBar (https://github.com/swiftbar/SwiftBar):

1. Install SwiftBar
2. Place `poe_balance.1h.sh` in your SwiftBar plugins folder
3. Optionally, set your API key via SwiftBar's environment variable panel or export `POE_API_KEY` in your shell

## Output

Credits are displayed in human-readable format:

| Range | Example |
|------|-------|
| < 1,000 | `500` |
| 1,000 - 999,999 | `150k` |
| 1,000,000 - 999,999,999 | `1.5M` |
| 1B+ | `1.2B` |

## Error Messages

- `Error: POE_API_KEY environment variable not set` - Set the `POE_API_KEY` environment variable
- `Error: Invalid API key` - Your API key is invalid or expired
