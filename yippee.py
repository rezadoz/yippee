#!/usr/bin/env python3

import os
import sys
from datetime import datetime
import subprocess

LOG_PATH = os.path.expanduser("~/.yippee.log")

def main():
    if not os.path.exists(LOG_PATH):
        print("~/.yippee.log not found, creating one now")
        with open(LOG_PATH, "w"):
            pass

    with open(LOG_PATH, "r") as f:
        lines = [line.strip() for line in f.readlines()]

    last_time = None
    if lines:
        last_line = lines[-1]
        if last_line:
            try:
                last_time = datetime.fromisoformat(last_line)
            except ValueError:
                pass

    if last_time:
        now = datetime.now()
        delta = now - last_time
        total_seconds = delta.total_seconds()

        if total_seconds >= 0:
            components = []
            weeks, rem = divmod(total_seconds, 604800)
            days, rem = divmod(rem, 86400)
            hours, rem = divmod(rem, 3600)
            minutes = rem // 60

            if weeks >= 1:
                components.append(f"{int(weeks)}w")
            if days >= 1:
                components.append(f"{int(days)}d")
            if hours >= 1:
                components.append(f"{int(hours)}h")
            if minutes >= 1:
                components.append(f"{int(minutes)}m")

            if not components:
                print("last yay was less than a minute ago")
            else:
                print(f"last yay was {' '.join(components[:2])} ago")
        else:
            print("last yay unknown")
    else:
        print("last yay unknown")

    with open(LOG_PATH, "a") as f:
        f.write(f"{datetime.now().isoformat()}\n")

    proc = subprocess.run(["yay"] + sys.argv[1:])
    sys.exit(proc.returncode)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nalright whatever")
        sys.exit(0)
