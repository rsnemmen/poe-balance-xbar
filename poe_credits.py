#!/usr/bin/env python

import os
import sys
import argparse
from typing import Optional
from datetime import date

import requests


def format_number(n: int) -> str:
    if n < 1000:
        return str(n)
    elif n < 1_000_000:
        return f"{n / 1000:.0f}k"
    elif n < 1_000_000_000:
        return f"{n / 1_000_000:.1f}M".rstrip("0").rstrip(".") + "M"
    else:
        return f"{n / 1_000_000_000:.1f}B".rstrip("0").rstrip(".") + "B"


def get_balance(api_key: str) -> Optional[int]:
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Accept": "application/json",
    }
    response = requests.get(
        "https://api.poe.com/usage/current_balance",
        headers=headers,
    )
    if response.status_code == 401:
        return None
    response.raise_for_status()
    return response.json()["current_point_balance"]


def days_since_day(since_day: int) -> int:
    """Calculate days passed since a given day of the month."""
    today = date.today()
    year = today.year
    month = today.month
    
    # Get days in current month
    import calendar
    days_in_month = calendar.monthrange(year, month)[1]
    
    # If specified day is greater than days in month, use max valid day
    actual_since_day = min(since_day, days_in_month)
    
    if today.day >= actual_since_day:
        # We've passed the specified day in current month
        return today.day - actual_since_day
    else:
        # We haven't passed the specified day yet
        # Days from specified day to end of month + days from start of month to today
        days_from_since_to_end = days_in_month - actual_since_day
        days_from_start_to_today = today.day
        return days_from_since_to_end + days_from_start_to_today


def main():
    parser = argparse.ArgumentParser(
        prog="poe-credits",
        description="Display remaining POE API credits",
    )
    parser.add_argument(
        "--since",
        type=int,
        choices=range(1, 32),
        help="Calculate days passed since a given day of the month (1-31)"
    )
    args = parser.parse_args()

    # If --since argument is provided, calculate days since that day
    if args.since is not None:
        days = days_since_day(args.since)
        print(f"Days passed since day {args.since}: {days}")
        return

    api_key = os.environ.get("POE_API_KEY")
    if not api_key:
        print("Error: POE_API_KEY environment variable not set", file=sys.stderr)
        sys.exit(1)

    try:
        balance = get_balance(api_key)
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

    if balance is None:
        print("Error: Invalid API key", file=sys.stderr)
        sys.exit(1)

    print(format_number(balance))


if __name__ == "__main__":
    main()
