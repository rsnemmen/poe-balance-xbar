#!/usr/bin/env bash
#<xbar.title>POE Credits</xbar.title>
#<xbar.version>1.0</xbar.version>
#<xbar.author>User</xbar.author>
#<xbar.desc>Display remaining POE API credits</xbar.desc>
#<xbar.dependencies>curl,bc</xbar.dependencies>

# Get API key
API_KEY="${POE_API_KEY}"
if [ -z "$API_KEY" ]; then
    echo "⚠️ No API Key" >&2
    exit 1
fi

# Fetch balance
response=$(curl -s -w "\n%{http_code}" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Accept: application/json" \
    "https://api.poe.com/usage/current_balance")

http_code=$(echo "$response" | tail -1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" = "401" ]; then
    echo "⚠️ Invalid Key"
    exit 1
fi

# Extract balance from JSON
balance=$(echo "$body" | sed 's/.*"current_point_balance": \([0-9]*\).*/\1/')

# Format number (e.g., 693000 -> 693k)
format_number() {
    n=$1
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

formatted=$(format_number "$balance")

# SwiftBar output
echo "Poe balance = $formatted"
