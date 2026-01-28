#!/usr/bin/env python

import os
import sys
import argparse
from typing import Optional

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


def main():
    parser = argparse.ArgumentParser(
        prog="poe-credits",
        description="Display remaining POE API credits",
    )
    parser.parse_args()

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
