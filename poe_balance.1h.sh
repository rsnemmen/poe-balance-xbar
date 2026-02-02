#!/usr/bin/env bash
#<xbar.title>Poe Balance</xbar.title>
#<xbar.version>1.0</xbar.version>
#<xbar.author>Rodrigo Nemmen da Silva</xbar.author>
#<xbar.desc>Display remaining Poe API credits</xbar.desc>
#<xbar.dependencies>curl,bc</xbar.dependencies>

# User variables
# ================
# For detailed instructions, visit https://github.com/rsnemmen/poe-balance
#
#<xbar.var>number(VAR_STARTING_DATE="0"): Billing period starting date (1-31). Set to 0 to disable.</xbar.var>
#<xbar.var>boolean(VAR_PERCENT="true"): Display remaining balance as percentage?.</xbar.var>

STARTING_DATE=$VAR_STARTING_DATE
PERCENT=$VAR_PERCENT
INITIAL_BALANCE=1000000

POE_ICON="iVBORw0KGgoAAAANSUhEUgAAADIAAAAqCAYAAADxughHAAAACXBIWXMAAC4jAAAuIwF4pT92AAADEUlEQVRogdWZ25WbMBCGv8nJe+gglEAqWEpwByEdOB1QgktwKohTQdgOSAVhO2ArmDwwPshYEkbGl8w5erA0I82vuSKLqhIjEdkCmyjTenRQ1V2SpKoGB7AF9M5jG9MpqOsMkPYBQNoUIBJzLRGJ+92NSFVlqcyH0IKI5Ncocw2lnB0EAqQF3Tq0+Owz1xKRzDb6alM/gAbortNtlnKgnJy7VdX+ImkDsgEODAr3jIFXpQTeNQOonPN706kG8hk5avzZo743CEepkE6bYNYyBh99UdU2ZEkRKYAM6GN8KTIW7H89S39UtQjJefP5zI01E/79Bbe8n8g0M/yhOlOEXGsREMLVPmh2hhhcVMUjQErfWbH0G6IyMB80eWQttNccFSJykqJTgGSJh6+9V2WlAkgD8iz0Cacr/5+BAOQiUotI9jFBuAVePPOxChxauyhtz1AJZCkW2QHvk7l3hvQaon1AZq1+bhPrfr2BqKodwy38Al4ZeqJCIz2RrRXG+2qype118dlGPpnPcF7cHtZnOTWkCujU2PrOfteO/mQBMB2QPQBEZmefgTjq4+g7AplsUthtHDvg1lzgXiBKxs/r3nTJPTrqFIj3U9d8tD36ntGrxzfXpIKhNgC84cSdNZHHsXP4vjGAfYndTqg/usfYOLffRPhyfK61oHG76XBipY/wVSfx8oRA+klmcoN9yxBH+Vm8PCGQ/SQzKU67b8qXBnS02JMBaRlTbGdzBwdAF5A7pPRaAN9Zp086IVVtAESkZMyYe8taDWO2OtIbw6NJnWKR+sa1ZMNpkJecfiZ7a9tSIAdn7RAAeovAbxwQ3m5jCZCO0X/rO4BQxhR7tFCwy7j0EfvdNmlFZAP8dNj+mHXWpkZVG4uX3wAae9yesUiF9TxO5nD9t+NGjSVDQayc87oo/8KN3f9LeuyNiXgbsdbYrQVkP9n4aKVpBb7F2M9ZPhXIznG9Mws9YiwBUjEE9TYQL9WjQCwC4omX7lL/fWYgbjFsHg1CNe3t16U37vcffJSiBTEoNBSpnMEa3boqpdE/EDqlk/DR3JgAAAAASUVORK5CYII="

# === Grabs API key === 
# (inspired by Dev/openai.30m.sh plugin)

# Method 1: Environment variable (works in terminal)
if [ -n "$POE_API_KEY" ]; then
    API_KEY="$POE_API_KEY"
fi

# Method 2: from Z shell config file (works for GUI apps like SwiftBar)
if [ -z "$API_KEY" ] && [ -f "$HOME/.zshrc" ]; then
    API_KEY=$(grep '^export POE_API_KEY=' "$HOME/.zshrc" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
fi

# Method 3: from bash config file 
if [ -z "$API_KEY" ] && [ -f "$HOME/.bashrc" ]; then
    API_KEY=$(grep '^export POE_API_KEY=' "$HOME/.bashrc" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
fi

# Prefer SwiftBar-provided API_KEY; fallback to POE_API_KEY from environment
API_KEY="${API_KEY:-${POE_API_KEY:-}}"

if [ -z "$API_KEY" ]; then
  echo "⚠️ No API Key"
  echo "Missing API key. Set API_KEY via export POE_API_KEY in .bashrc or .zshrc." >&2
  exit 1
fi

# === Fetch balance ===
response="$(curl -s -w "\n%{http_code}" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Accept: application/json" \
  "https://api.poe.com/usage/current_balance")"

http_code="$(printf '%s\n' "$response" | tail -n 1)"
body="$(printf '%s\n' "$response" | sed '$d')"

if [ "$http_code" = "401" ]; then
  echo "⚠️ Invalid Key"
  exit 1
elif [ "$http_code" -lt 200 ] || [ "$http_code" -ge 300 ]; then
  echo "⚠️ POE API Error ($http_code)"
  echo "Response body: $body" >&2
  exit 1
fi

# Extract balance from JSON (kept simple; assumes integer field)
balance="$(printf '%s\n' "$body" | sed -n 's/.*"current_point_balance"[[:space:]]*:[[:space:]]*\([0-9][0-9]*\).*/\1/p')"

if [ -z "$balance" ]; then
  echo "⚠️ Parse Error"
  echo "Could not parse current_point_balance from: $body" >&2
  exit 1
fi

# === Format number ===
# (e.g., 693000 -> 693k)
format_number() {
  local n="$1"
  if [ "$n" -lt 1000 ]; then
    echo "$n"
  elif [ "$n" -lt 1000000 ]; then
    echo "$((n / 1000))k"
  elif [ "$n" -lt 1000000000 ]; then
    echo "$(echo "scale=1; $n / 1000000" | bc | sed 's/\.0$//')M"
  else
    echo "$(echo "scale=1; $n / 1000000000" | bc | sed 's/\.0$//')B"
  fi
}

# Round number to integer
round() {
  printf "%.0f" "$(echo "scale=10; $1" | bc)"
}

formatted="$(format_number "$balance")"

# if STARTING_DATE=0 or the variable was not defined, then the code displays only the 
# remaining balance
if [ "$PERCENT" = "true" ]; then
  # Calculate percentage
  pct=$(round "$balance / 10000")
  
  if [ -n "$STARTING_DATE" ] && [ $STARTING_DATE -gt 0 ]; then
    # Validate STARTING_DATE (1-31)
    if [ "$STARTING_DATE" -gt 31 ]; then
      echo "⚠️ Invalid STARTING_DATE" >&2
      exit 1
    fi

    # === Compute DAYS passed since STARTING_DATE ===
    # Compute DAYS passed since STARTING_DATE as a fractional number
    TODAY=$((10#$(date +%d)))   # force base-10 (avoids issues with leading zeros)
    NOW_S=$(date +%s)

    if [ "$STARTING_DATE" -le "$TODAY" ]; then
      # start date is in the current month at 00:00:00
      START_S=$(date -j -v"${STARTING_DATE}"d -v0H -v0M -v0S +%s)
    else
      # start date is in the previous month at 00:00:00
      START_S=$(date -j -v-1m -v"${STARTING_DATE}"d -v0H -v0M -v0S +%s)
    fi

    DAYS=$(echo "scale=4; ($NOW_S - $START_S) / 86400" | bc)  # e.g. 4.3333

    # Compute estimated spent: 1M credits/day * DAYS
    DAILY_CREDITS=32895 # 1E6/30.4, assumes equal usage every day
    ESTIMATED_SPENT=$(round "$INITIAL_BALANCE - ($DAYS * $DAILY_CREDITS)")

    # Calculate estimated percentage
    est_pct=$(round "$ESTIMATED_SPENT / 10000")
    
    # SwiftBar output (header)
    echo "${pct}% (Est.: ${est_pct}%) | image=$POE_ICON"
  else
    echo "${pct}% | image=$POE_ICON"
  fi
else
  if [ -n "$STARTING_DATE" ] && [ $STARTING_DATE -gt 0 ]; then
    # Validate STARTING_DATE (1-31)
    if [ "$STARTING_DATE" -gt 31 ]; then
      echo "⚠️ Invalid STARTING_DATE" >&2
      exit 1
    fi

    # Compute DAYS passed since STARTING_DATE (exclusive)
    TODAY=$(date +%d)
    if [ "$STARTING_DATE" -le "$TODAY" ]; then
      DAYS=$((TODAY - STARTING_DATE))
    else
      DAYS=$TODAY
    fi

    # Compute estimated spent: 1M credits/day * DAYS
    DAILY_CREDITS=32895 # 1E6/30.4, assumes equal usage every day
    ESTIMATED_SPENT=$((INITIAL_BALANCE-DAYS * DAILY_CREDITS))

    # === SwiftBar output ===
    echo "$formatted (Est.: $(format_number "$ESTIMATED_SPENT")) | image=$POE_ICON"
  else
    echo "$formatted | image=$POE_ICON"
  fi
fi