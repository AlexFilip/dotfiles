#!/usr/bin/env python3
import sys
import json
import argparse
import os
import signal

def find_pid_by_name(name):
    """Return the PID of the first process whose /proc/<pid>/comm matches name."""
    for pid in os.listdir("/proc"):
        if not pid.isdigit():
            continue

        comm_path = f"/proc/{pid}/comm"
        try:
            with open(comm_path, "r") as f:
                comm = f.read().strip()
        except (FileNotFoundError, PermissionError):
            continue

        if comm == name:
            return int(pid)

    return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--field", required=True, help="JSON field to inspect")
    parser.add_argument("--values", required=True, help="Comma-separated list of trigger values")
    args = parser.parse_args()

    field = args.field
    triggers = {v.strip() for v in args.values.split(",")}
    sig = signal.SIGRTMIN + 3
    lastTitle = ""

    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue

        try:
            obj = json.loads(line)
        except json.JSONDecodeError:
            continue

        if field not in obj:
            continue

        value = obj[field]
        newTitle = obj["container"]["name"]
        if isinstance(value, str) and value in triggers and newTitle != lastTitle:
            lastTitle = newTitle
            pid = find_pid_by_name("i3blocks")
            if pid is not None:
                os.kill(pid, sig)

if __name__ == "__main__":
    main()

