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
#<xbar.var>number(VAR_STARTING_DATE="0"): Billing period starting date (1-31). Set to 0 to disable cycle tracking.</xbar.var>
#<xbar.var>boolean(VAR_PERCENT="true"): Display remaining balance as percentage?.</xbar.var>
#<xbar.var>boolean(VAR_COMPACT="false"): Use compact display format (e.g., 520k/600k)?.</xbar.var>
#<xbar.var>boolean(VAR_COLORS="true"): Enable color coding for low balance?.</xbar.var>
#<xbar.var>boolean(VAR_MINIMAL_MENUBAR="false"): Keep menu bar minimal (current balance only) even when a billing cycle is configured?.</xbar.var>

STARTING_DATE=$VAR_STARTING_DATE
PERCENT=$VAR_PERCENT
COMPACT=$VAR_COMPACT
COLORS=$VAR_COLORS
MINIMAL_MENUBAR=$VAR_MINIMAL_MENUBAR
INITIAL_BALANCE=1000000
DAILY_POINTS=32895  # 1M / 30.4 days
STATE_DIR="$HOME/Library/Application Support/poe-balance"
STATE_FILE="$STATE_DIR/cycle_state"

POE_ICON="iVBORw0KGgoAAAANSUhEUgAAABIAAAAPCAYAAADphp8SAAAAAXNSR0IArs4c6QAAAJhlWElmTU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAIdpAAQAAAABAAAATgAAAAAAAABIAAAAAQAAAEgAAAABAASQBAACAAAAFAAAAISgAQADAAAAAQABAACgAgAEAAAAAQAAABKgAwAEAAAAAQAAAA8AAAAAMjAyNjowMzoyMCAwODoxNDo0MwBm6dBXAAAACXBIWXMAAAsTAAALEwEAmpwYAAABsmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNi4wLjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iPgogICAgICAgICA8eG1wOkNyZWF0b3JUb29sPkFkb2JlIFBob3Rvc2hvcCAyNy40IChNYWNpbnRvc2gpPC94bXA6Q3JlYXRvclRvb2w+CiAgICAgICAgIDx4bXA6Q3JlYXRlRGF0ZT4yMDI2LTAzLTIwVDA4OjE0OjQzPC94bXA6Q3JlYXRlRGF0ZT4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiC5oOMAAAF5SURBVDgRpdI9KMVRGMfx46XL4DXvpbysZPA2WimDUhYWmZRFGcVMYrgpK8bLIGUg5S4GSiZFXuoio7ws3vn+dM7f8XeRPPW55znnf+7/nvM815iPSCHtxxWuv3HJei9+jGKevuD1F3c8z8On0CkUFehDORK4RzrSoHi2IozVOMQ8zhDEENkN5oIVY+rIs725TlDrzWPkKkGHtxZcZdQuNjPqigvephVynUo/oBiDSjCFKphUfdhw18xnrrzMPWAshfa62ri9Oaz1IKI67KABGVBsYRarcBElacGuXci04y1jIaJ6cwkGUINxnEPF1gncyzXXdTWvxCD00mO0o9Udkdw0IY4nuG6Rfgl9pwvdUJeXMOK/SDU5gLp1ikeEQwWOQ6cuQgJqzolq5EJ5FlSPdajduk44HljoxBq0ZwLb/hX0EnVhGZPYh7qVG1LAfBONGMYe3tus0YWutYEZtOEIya6of/gFppHs1EYb6rEIdfJfof+IavCneANwl1NxwdLNXQAAAABJRU5ErkJggg=="

# === Grabs API key === 
# (inspired by Dev/openai.30m.sh plugin)

# Method 1: Environment variable (works in terminal)
if [ -n "$POE_API_KEY" ]; then
    API_KEY="$POE_API_KEY"
fi

# Method 2: from Z shell config file (works for GUI apps like SwiftBar)
if [ -z "$API_KEY" ] && [ -f "$HOME/.zshrc" ]; then
    API_KEY=$(grep '^export POE_API_KEY=' "$HOME/.zshrc" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
fi

# Method 3: from Z shell env file (sourced by all zsh shells)
if [ -z "$API_KEY" ] && [ -f "$HOME/.zshenv" ]; then
    API_KEY=$(grep '^export POE_API_KEY=' "$HOME/.zshenv" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
fi

# Method 4: from bash config file 
if [ -z "$API_KEY" ] && [ -f "$HOME/.bashrc" ]; then
    API_KEY=$(grep '^export POE_API_KEY=' "$HOME/.bashrc" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
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

# === Format number (3 significant figures) ===
# (e.g., 693456 -> 693k, 52341 -> 52.3k, 5234 -> 5.23k, 1140000 -> 1.14M)
format_number() {
  local n="$1"
  local prefix=""
  if [ "$n" -lt 0 ]; then
    prefix="-"
    n=$((-n))
  fi
  # Helper: strip trailing zeros after decimal (e.g., "1.00" -> "1", "5.20" -> "5.2")
  strip_zeros() { echo "$1" | sed 's/\.00$//' | sed 's/\(\.[0-9]\)0$/\1/'; }
  if [ "$n" -lt 1000 ]; then
    echo "${prefix}${n}"
  elif [ "$n" -lt 10000 ]; then
    echo "${prefix}$(strip_zeros "$(printf "%.2f" "$(echo "scale=10; $n / 1000" | bc)")")k"
  elif [ "$n" -lt 100000 ]; then
    echo "${prefix}$(strip_zeros "$(printf "%.1f" "$(echo "scale=10; $n / 1000" | bc)")")k"
  elif [ "$n" -lt 1000000 ]; then
    echo "${prefix}$(round "$n / 1000")k"
  elif [ "$n" -lt 10000000 ]; then
    echo "${prefix}$(strip_zeros "$(printf "%.2f" "$(echo "scale=10; $n / 1000000" | bc)")")M"
  elif [ "$n" -lt 100000000 ]; then
    echo "${prefix}$(strip_zeros "$(printf "%.1f" "$(echo "scale=10; $n / 1000000" | bc)")")M"
  elif [ "$n" -lt 1000000000 ]; then
    echo "${prefix}$(round "$n / 1000000")M"
  else
    echo "${prefix}$(strip_zeros "$(printf "%.2f" "$(echo "scale=10; $n / 1000000000" | bc)")")B"
  fi
}

# Round number to integer
round() {
  printf "%.0f" "$(echo "scale=10; $1" | bc)"
}

is_positive_integer() {
  case "$1" in
    ''|*[!0-9]*) return 1 ;;
  esac
  [ "$((10#$1))" -gt 0 ]
}

load_cycle_state() {
  SAVED_CYCLE_START=""
  SAVED_START_BALANCE=""

  if [ ! -f "$STATE_FILE" ]; then
    return
  fi

  SAVED_CYCLE_START="$(sed -n 's/^cycle_start=//p' "$STATE_FILE")"
  SAVED_START_BALANCE="$(sed -n 's/^start_balance=//p' "$STATE_FILE")"
}

save_cycle_state() {
  local cycle_start="$1"
  local start_balance="$2"

  if ! mkdir -p "$STATE_DIR"; then
    echo "Could not create state directory: $STATE_DIR" >&2
    return 1
  fi

  if ! printf 'cycle_start=%s\nstart_balance=%s\n' "$cycle_start" "$start_balance" > "$STATE_FILE"; then
    echo "Could not write state file: $STATE_FILE" >&2
    return 1
  fi
}

last_day_of_month() {  # args: year month
  date -j -v"${1}"y -v"${2}"m -v1d -v+1m -v-1d +%d
}

formatted="$(format_number "$balance")"

# === Compute derived values ===
pct=$(round "$balance / 10000")

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
if [ -n "$STARTING_DATE" ] && [ "$STARTING_DATE" != "0" ] && ! is_positive_integer "$STARTING_DATE"; then
  echo "! | templateImage=$POE_ICON"
  echo "---"
  echo "Invalid STARTING_DATE: $STARTING_DATE"
  exit 0
fi

if is_positive_integer "$STARTING_DATE"; then
  STARTING_DATE=$((10#$STARTING_DATE))
  if [ "$STARTING_DATE" -gt 31 ]; then
    echo "! | templateImage=$POE_ICON"
    echo "---"
    echo "Invalid STARTING_DATE: $STARTING_DATE"
    exit 0
  fi
  HAVE_CYCLE=true

  TODAY=$((10#$(date +%d)))
  NOW_S=$(date +%s)
  CURRENT_YEAR=$((10#$(date +%Y)))
  CURRENT_MONTH=$((10#$(date +%m)))

  if [ "$STARTING_DATE" -le "$TODAY" ]; then
    START_Y=$CURRENT_YEAR
    START_M=$CURRENT_MONTH
  else
    if [ "$CURRENT_MONTH" -eq 1 ]; then
      START_Y=$((CURRENT_YEAR - 1))
      START_M=12
    else
      START_Y=$CURRENT_YEAR
      START_M=$((CURRENT_MONTH - 1))
    fi
  fi

  if [ "$START_M" -eq 12 ]; then
    END_Y=$((START_Y + 1))
    END_M=1
  else
    END_Y=$START_Y
    END_M=$((START_M + 1))
  fi

  START_LAST=$(last_day_of_month "$START_Y" "$START_M")
  END_LAST=$(last_day_of_month "$END_Y" "$END_M")
  START_DAY=$(( STARTING_DATE < START_LAST ? STARTING_DATE : START_LAST ))
  END_DAY=$(( STARTING_DATE < END_LAST ? STARTING_DATE : END_LAST ))

  START_S=$(date -j -v"${START_Y}"y -v"${START_M}"m -v"${START_DAY}"d -v0H -v0M -v0S +%s)
  END_S=$(date -j -v"${END_Y}"y -v"${END_M}"m -v"${END_DAY}"d -v0H -v0M -v0S +%s)

  DAYS_ELAPSED=$(echo "scale=4; ($NOW_S - $START_S) / 86400" | bc)
  DAYS_REMAINING=$(echo "scale=4; ($END_S - $NOW_S) / 86400" | bc)
  BASELINE_NOTE=""

  load_cycle_state
  if [ "$SAVED_CYCLE_START" = "$START_S" ] && is_positive_integer "$SAVED_START_BALANCE"; then
    CYCLE_START_BALANCE="$SAVED_START_BALANCE"
  else
    CYCLE_START_BALANCE="$balance"
    if ! save_cycle_state "$START_S" "$CYCLE_START_BALANCE"; then
      CYCLE_START_BALANCE="$INITIAL_BALANCE"
      BASELINE_NOTE="Could not persist cycle baseline; using 1M default."
    elif [ "$(echo "$DAYS_ELAPSED > 0" | bc)" -eq 1 ]; then
      BASELINE_NOTE="Tracking from the first balance observed this cycle."
    fi
  fi

  consumed=$((CYCLE_START_BALANCE - balance))
  EXPECTED_DAILY_BURN=$DAILY_POINTS

  # Expected remaining balance based on uniform usage
  ESTIMATED=$(round "$CYCLE_START_BALANCE - ($DAYS_ELAPSED * $EXPECTED_DAILY_BURN)")
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
SHOW_CYCLE_IN_MENUBAR="$HAVE_CYCLE"
if [ "$MINIMAL_MENUBAR" = "true" ]; then
  SHOW_CYCLE_IN_MENUBAR=false
fi

if [ "$PERCENT" = "true" ]; then
  if [ "$SHOW_CYCLE_IN_MENUBAR" = "true" ]; then
    if [ "$COMPACT" = "true" ]; then
      echo "${pct}%/${est_pct}% | templateImage=$POE_ICON${COLOR:+ color=$COLOR}"
    else
      echo "${pct}% (Est.: ${est_pct}%) | templateImage=$POE_ICON${COLOR:+ color=$COLOR}"
    fi
  else
    echo "${pct}% | templateImage=$POE_ICON${COLOR:+ color=$COLOR}"
  fi
else
  if [ "$SHOW_CYCLE_IN_MENUBAR" = "true" ]; then
    if [ "$COMPACT" = "true" ]; then
      echo "$formatted/$(format_number "$ESTIMATED") | templateImage=$POE_ICON${COLOR:+ color=$COLOR}"
    else
      echo "$formatted (Est.: $(format_number "$ESTIMATED")) | templateImage=$POE_ICON${COLOR:+ color=$COLOR}"
    fi
  else
    echo "$formatted | templateImage=$POE_ICON${COLOR:+ color=$COLOR}"
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

# Billing cycle info
if [ "$HAVE_CYCLE" = "true" ]; then
  echo "---"
  DAYS_E=$(echo "scale=0; $DAYS_ELAPSED / 1" | bc)
  DAYS_R=$(round "$DAYS_REMAINING")
  TOTAL_DAYS=$(echo "scale=0; ($END_S - $START_S) / 86400" | bc)
  DAY_NUM=$((DAYS_E + 1))
  echo "Day ${DAY_NUM} of ${TOTAL_DAYS} (${DAYS_R} days until renewal)"
  echo "Cycle start balance: $(format_number "$CYCLE_START_BALANCE")"
  if [ -n "$BASELINE_NOTE" ]; then
    echo "$BASELINE_NOTE"
  fi
  echo "Expected balance now: $(format_number "$ESTIMATED") (${est_pct}%)"
  echo "Daily burn: $(format_number "$ACTUAL_DAILY_BURN") (expected: $(format_number "$EXPECTED_DAILY_BURN"))"
  echo "Projected end balance: $(format_number "$PROJECTED")"
fi
