#!/usr/bin/env python3

import argparse
from pathlib import Path


def read_integers(filename):
    values = []

    for line in Path(filename).read_text().splitlines():
        line = line.strip()

        if line and not line.startswith("#"):
            values.append(int(line, 0))

    return values


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("--expected", default="expected.txt")
    parser.add_argument("--actual", default="actual.txt")

    args = parser.parse_args()

    expected = read_integers(args.expected)
    actual = read_integers(args.actual)

    if len(expected) != len(actual):
        raise SystemExit(
            f"FAIL: expected {len(expected)} values, "
            f"received {len(actual)}"
        )

    errors = []

    for index, (exp, got) in enumerate(zip(expected, actual)):
        if exp != got:
            errors.append((index, exp, got))

    if errors:
        for index, exp, got in errors:
            print(
                f"Mismatch at {index}: "
                f"expected={exp}, actual={got}"
            )

        raise SystemExit(
            f"FAIL: {len(errors)} mismatches"
        )

    print(f"PASS: all {len(expected)} outputs match")


if __name__ == "__main__":
    main()
