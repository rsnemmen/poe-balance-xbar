#!/usr/bin/env bash
#<xbar.title>Poe Balance</xbar.title>
#<xbar.version>1.0</xbar.version>
#<xbar.author>Rodrigo Nemmen da Silva</xbar.author>
#<xbar.desc>Display remaining Poe API points</xbar.desc>
#<xbar.image>https://raw.githubusercontent.com/rsnemmen/poe-balance/780b20c79f3433f1908353888a6fa59217f3b8f9/images/cover.png</xbar.image>
#<xbar.dependencies>curl,bc</xbar.dependencies>

# User variables
# ================
# For detailed instructions, visit https://github.com/rsnemmen/poe-balance
#
#<xbar.var>number(VAR_STARTING_DATE="0"): Billing period starting date (1-31). Set to 0 to disable.</xbar.var>
#<xbar.var>boolean(VAR_PERCENT="true"): Display remaining balance as percentage?.</xbar.var>
#<xbar.var>boolean(VAR_COMPACT="false"): Use compact display format (e.g., 520k/600k)?.</xbar.var>
#<xbar.var>boolean(VAR_COLORS="true"): Enable color coding for low balance?.</xbar.var>

STARTING_DATE=$VAR_STARTING_DATE
PERCENT=$VAR_PERCENT
COMPACT=$VAR_COMPACT
COLORS=$VAR_COLORS
INITIAL_BALANCE=1000000
DAILY_POINTS=32895  # 1M / 30.4 days

POE_ICON="iVBORw0KGgoAAAANSUhEUgAAAB4AAAAZCAYAAAAmNZ4aAAAAAXNSR0IArs4c6QAAAJhlWElmTU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAIdpAAQAAAABAAAATgAAAAAAAABIAAAAAQAAAEgAAAABAASQBAACAAAAFAAAAISgAQADAAAAAQABAACgAgAEAAAAAQAAAB6gAwAEAAAAAQAAABkAAAAAMjAyNjowMzoyMCAwODoxNDo0MwDn0GBeAAAACXBIWXMAAAsTAAALEwEAmpwYAAABsmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNi4wLjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iPgogICAgICAgICA8eG1wOkNyZWF0b3JUb29sPkFkb2JlIFBob3Rvc2hvcCAyNy40IChNYWNpbnRvc2gpPC94bXA6Q3JlYXRvclRvb2w+CiAgICAgICAgIDx4bXA6Q3JlYXRlRGF0ZT4yMDI2LTAzLTIwVDA4OjE0OjQzPC94bXA6Q3JlYXRlRGF0ZT4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiC5oOMAAALZSURBVEgNvZRZiM5RGIdn7NvczBRFkRqSsSREsky5IImQyVyJMtbIBXGF5EqkRNPIFokbLqRcaDTIhWS5sWS5sMzV2EO2Gc/zcWbO95//fN9n0vzq+b73vO855/2/ZysuStc03AdhSHo4p/cU0T3wPmevlGAFviZohpZO8I0xtZBT3VKiY/CVQXFKrBBXLzrNyDe+R2Imk1XDF7BqK/5XmXgkVMJVSFVIPJ7oOKiCEpgELyAkdtnTVgd363aEeG98i+EE1MF9aIBPkKXZtD6DSX5AOSQ1IOmI2n58n6gdzMMYzikXoSdkqZFW6PAMO56kL+1jYPX7IKwQZkYT+L0Lj2FOxtP2swozzPsRe3Bb6I8Vgv6buF/UYSZ2HB8dxTSPRvH6RKwminleKmEBZBT2JbST//0TDlcgVvyR8UrFfbT9eA/ddugOHR4YY8o9j/UzbmD/itoewFyyrx83FUqt2AsfFJY1tO9g3AQTXoInEOsMjXfg9TsZB7DjD7FKr6q5psAOKFoJIaGHYKDOSC73WHCp0jQM54iUwG58Yd5b2M7h/5q//syXLKOxHx7Bcch1fQjnlW/9KzgHW2AQeFAfwmposfxYpTSugFU+B5cr2QdXh7JCx/oAbYYjMBm8dtvgK+wFi2unFXjCEnX234/2wYivm76FEObHzNYimp1NGMZdYA6rtH0ahkM5uAVP4VryJcLX7orV4/sATlKI3tBpF/gUN8I68KBZqfmsfHlaYvytqsVaC57afH3DoGaMCtgJt2EebISt4Eq8Bve6nZbisboG8P6tByfzLnsP8/GdPo73as6FQ1AHWUqrwmV9ANUwHQ6AD4n3zwNTqN7S0Q9fAhuSg4qTDtp29k32IbkOJpsI82ETFLLX9nGeofASKsH9blVa4hD0QakBE5bAebD6y1CofOtdvaZCB9jPAzULfOpctrNgFV2mG2S6B2VdlpFEbkUVjPrfSX8DUH/SFT5EHMYAAAAASUVORK5CYII="

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

# Method 3: from Z shell env file (sourced by all zsh shells)
if [ -z "$API_KEY" ] && [ -f "$HOME/.zshenv" ]; then
    API_KEY=$(grep '^export POE_API_KEY=' "$HOME/.zshenv" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
fi

# Method 4: from bash config file 
if [ -z "$API_KEY" ] && [ -f "$HOME/.bashrc" ]; then
    API_KEY=$(grep '^export POE_API_KEY=' "$HOME/.bashrc" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
fi

# Prefer SwiftBar-provided API_KEY; fallback to POE_API_KEY from environment
API_KEY="${API_KEY:-${POE_API_KEY:-}}"

if [ -z "$API_KEY" ]; then
  echo "! | templateImage=$POE_ICON"
  echo "---"
  echo "Missing API key. Set POE_API_KEY in .bashrc or .zshrc."
  exit 0
fi

# === Fetch balance ===
response="$(curl -s --connect-timeout 5 --max-time 10 -w "\n%{http_code}" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Accept: application/json" \
  "https://api.poe.com/usage/current_balance")"

http_code="$(printf '%s\n' "$response" | tail -n 1)"
body="$(printf '%s\n' "$response" | sed '$d')"

if [ -z "$http_code" ] || [ "$http_code" = "000" ]; then
  echo "? | templateImage=$POE_ICON"
  echo "---"
  echo "No internet connection"
  exit 0
elif [ "$http_code" = "401" ]; then
  echo "! | templateImage=$POE_ICON"
  echo "---"
  echo "Invalid API key (401)"
  exit 0
elif [ "$http_code" -lt 200 ] || [ "$http_code" -ge 300 ]; then
  echo "! | templateImage=$POE_ICON"
  echo "---"
  echo "API error: HTTP $http_code"
  exit 0
fi

# Extract balance from JSON (kept simple; assumes integer field)
balance="$(printf '%s\n' "$body" | sed -n 's/.*"current_point_balance"[[:space:]]*:[[:space:]]*\([0-9][0-9]*\).*/\1/p')"

if [ -z "$balance" ]; then
  echo "! | templateImage=$POE_ICON"
  echo "---"
  echo "Could not parse balance from API response"
  exit 0
fi

# === Format number ===
# (e.g., 693000 -> 693k)
format_number() {
  local n="$1"
  local prefix=""
  if [ "$n" -lt 0 ]; then
    prefix="-"
    n=$((-n))
  fi
  if [ "$n" -lt 1000 ]; then
    echo "${prefix}${n}"
  elif [ "$n" -lt 1000000 ]; then
    echo "${prefix}$(round "$n / 1000")k"
  elif [ "$n" -lt 1000000000 ]; then
    echo "${prefix}$(printf "%.1f" "$(echo "scale=10; $n / 1000000" | bc)" | sed 's/\.0$//')M"
  else
    echo "${prefix}$(printf "%.1f" "$(echo "scale=10; $n / 1000000000" | bc)" | sed 's/\.0$//')B"
  fi
}

# Round number to integer
round() {
  printf "%.0f" "$(echo "scale=10; $1" | bc)"
}

formatted="$(format_number "$balance")"

# === Compute derived values ===
consumed=$((INITIAL_BALANCE - balance))
pct=$(round "$balance / 10000")
consumed_pct=$(round "$consumed / 10000")

# Determine color based on percentage (if enabled)
COLOR=""
if [ "$COLORS" = "true" ]; then
  if [ "$pct" -lt 10 ]; then
    COLOR="#FF0000"
  elif [ "$pct" -lt 20 ]; then
    COLOR="#FFD700"
  fi
fi

# Compute billing cycle info when STARTING_DATE is configured
HAVE_CYCLE=false
if [ -n "$STARTING_DATE" ] && [ "$STARTING_DATE" -gt 0 ]; then
  if [ "$STARTING_DATE" -gt 31 ]; then
    echo "⚠️ Invalid STARTING_DATE" >&2
    exit 1
  fi
  HAVE_CYCLE=true

  TODAY=$((10#$(date +%d)))
  NOW_S=$(date +%s)

  if [ "$STARTING_DATE" -le "$TODAY" ]; then
    START_S=$(date -j -v"${STARTING_DATE}"d -v0H -v0M -v0S +%s)
    END_S=$(date -j -v+1m -v"${STARTING_DATE}"d -v0H -v0M -v0S +%s)
  else
    START_S=$(date -j -v-1m -v"${STARTING_DATE}"d -v0H -v0M -v0S +%s)
    END_S=$(date -j -v"${STARTING_DATE}"d -v0H -v0M -v0S +%s)
  fi

  DAYS_ELAPSED=$(echo "scale=4; ($NOW_S - $START_S) / 86400" | bc)
  DAYS_REMAINING=$(echo "scale=4; ($END_S - $NOW_S) / 86400" | bc)

  # Expected remaining balance based on uniform usage
  ESTIMATED=$(round "$INITIAL_BALANCE - ($DAYS_ELAPSED * $DAILY_POINTS)")
  if [ "$ESTIMATED" -lt 0 ]; then
    ESTIMATED=0
  fi
  est_pct=$(round "$ESTIMATED / 10000")

  # Actual daily burn rate (points consumed / days elapsed)
  if [ "$(echo "$DAYS_ELAPSED > 0" | bc)" -eq 1 ]; then
    ACTUAL_DAILY_BURN=$(round "$consumed / $DAYS_ELAPSED")
  else
    ACTUAL_DAILY_BURN=0
  fi

  # Projected balance at end of billing cycle
  PROJECTED=$(round "$balance - ($ACTUAL_DAILY_BURN * $DAYS_REMAINING)")
fi

# === Menu bar header ===
if [ "$PERCENT" = "true" ]; then
  if [ "$HAVE_CYCLE" = "true" ]; then
    if [ "$COMPACT" = "true" ]; then
      echo "${pct}%/${est_pct}% | templateImage=$POE_ICON color=${COLOR}"
    else
      echo "${pct}% (Est.: ${est_pct}%) | templateImage=$POE_ICON color=${COLOR}"
    fi
  else
    echo "${pct}% | templateImage=$POE_ICON color=${COLOR}"
  fi
else
  if [ "$HAVE_CYCLE" = "true" ]; then
    if [ "$COMPACT" = "true" ]; then
      echo "$formatted/$(format_number "$ESTIMATED") | templateImage=$POE_ICON color=${COLOR}"
    else
      echo "$formatted (Est.: $(format_number "$ESTIMATED")) | templateImage=$POE_ICON color=${COLOR}"
    fi
  else
    echo "$formatted | templateImage=$POE_ICON color=${COLOR}"
  fi
fi

# === Dropdown menu ===
echo "---"

# Balance details
if [ "$PERCENT" = "true" ]; then
  echo "Balance: $formatted"
else
  echo "Balance: ${pct}%"
fi
echo "Consumed: $(format_number "$consumed") (${consumed_pct}%)"

# Billing cycle info
if [ "$HAVE_CYCLE" = "true" ]; then
  echo "---"
  DAYS_E=$(echo "scale=0; $DAYS_ELAPSED / 1" | bc)
  DAYS_R=$(round "$DAYS_REMAINING")
  TOTAL_DAYS=$((DAYS_E + DAYS_R))
  echo "Day ${DAYS_E} of ${TOTAL_DAYS} (${DAYS_R} remaining)"
  echo "Daily burn: $(format_number "$ACTUAL_DAILY_BURN") (expected: $(format_number "$DAILY_POINTS"))"
  echo "Projected end balance: $(format_number "$PROJECTED")"
fi