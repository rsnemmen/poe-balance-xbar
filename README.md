# Check Poe API balance remaining in the menu bar

A SwiftBar/xbar plugin and command-line tool to display your remaining Poe API balance. Works in the MacOS menu bar or terminal.

## Find the API key

To use this tool, define your Poe API key by adding the following line to your `.bashrc` or `.zshrc` (depending on your shell):  

    export POE_API_KEY="your-API-key-here"

You can find your API key by [going here](https://poe.com/api_key).

## SwiftBar / xbar Integration

This includes a [SwiftBar](https://github.com/swiftbar/SwiftBar) (also xbar) plugin to display your remaining Poe balance in the MacOS menu bar. It can display the balance in one of the following ways:

![Balance remaining](images/credits.png)  
`Poe: 670k` ← actual credits remaining  

![Percentage remaining](images/percent.png)  
`Poe: 67%` ← percentage remaining  

`Poe: 670k (Est.: 720k)` ← (a) actual credits remaining and (b) expected credits today assuming the user consumes the same amount of credits everyday throughout the month. Example: if your credit starts at 1E6 units and 1 day has passed, you are expected 967k credits remaining for typical usage. “Est.” can be useful to judge if you are overspending your credits.  

![More details](images/percent_est.png)  
`Poe: 67% (Est.: 72%)` ← same as above in percentage

### Installing and configuring the SwiftBar plugin

(1) Install [SwiftBar](https://github.com/swiftbar/SwiftBar) (can be installed with Homebrew: `brew install swiftbar`).  

(2) Place `poe_balance.1h.sh` in your SwiftBar plugins folder.  

(3) Change the following variables in `poe_balance.1h.sh` to define how you would like the menu app to behave.  

*To display balance as percentage:*

```shell
#<xbar.var>boolean(VAR_PERCENT="true"): Display remaining balance as percentage?.</xbar.var>
```
(set it to `false` to display actual credits).

*To display the estimated credits remaining today assuming average use*, change this line:

```shell
#<xbar.var>number(VAR_STARTING_DATE="21"): Billing period starting date (1-31). Set to 0 to disable.</xbar.var>
```
For example, the line above defines the starting of the billing period in the 21st of each month.

## Command-line tool usage

(1) Set your POE API key in `.bashrc` or `.zshrc` (depending on your shell):

    export POE_API_KEY="your_api_key_here"

(2) Run the tool to display credits:

    ./poe_balance.py

(3) Shows expected balance assuming uniform usage (specify the starting day of your Poe account as an argument, here for example on the 15th):

	./poe_balance --since 15

**Note:** Please make sure `requests` is installed in your Python environment:

```bash
pip install requests
```


## Output

Credits are displayed in human-readable format:

| Range | Example |
|------|-------|
| < 1,000 | `500` |
| 1,000 - 999,999 | `150k` |
| 1,000,000 - 999,999,999 | `1.5M` |
| 1B+ | `1.2B` |

