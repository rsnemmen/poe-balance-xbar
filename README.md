# Check Poe API balance remaining

A command-line tool to display remaining POE API balance.

## Usage

(1) Set your POE API key:  

    export POE_API_KEY="your_api_key_here"

(2) Run the tool to display credits:

    ./poe_balance.py

(3) Shows expected balance assuming uniform usage (specify the starting day of your Poe account as an argument, here for example on the 15th):

	./poe_balance --since 15

### Direct Script Usage

You can also run the script specifying the API key directly in the command-line:

```bash
POE_API_KEY="your_api_key_here" python3 poe_balance.py
```

**Note:** Please make sure `requests` is installed in your Python environment:

```bash
pip install requests
```

## SwiftBar Integration

This tool also works with [SwiftBar](https://github.com/swiftbar/SwiftBar):

1. Install SwiftBar
2. Place `poe_balance.1h.sh` in your SwiftBar plugins folder
3. Optionally, set your API key via SwiftBar's environment variable panel or in `.bashrc` or `.zshrc` (depending on your shell) with 

```shell
export POE_API_KEY="your-API-key-here"
```

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
