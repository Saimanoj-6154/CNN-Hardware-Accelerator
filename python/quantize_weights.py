#!/usr/bin/env python3

import argparse
import json
import numpy as np


def quantize(values, frac_bits=8, width=16):
    scale = 1 << frac_bits

    minimum = -(1 << (width - 1))
    maximum = (1 << (width - 1)) - 1

    values = np.asarray(values, dtype=np.float64)
    quantized = np.rint(values * scale)

    return np.clip(
        quantized, minimum, maximum
    ).astype(np.int64)


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("--input", default=None)
    parser.add_argument(
        "--output", default="weights_quantized.json"
    )
    parser.add_argument("--frac-bits", type=int, default=8)
    parser.add_argument("--width", type=int, default=16)

    args = parser.parse_args()

    if args.input:
        with open(args.input, "r", encoding="utf-8") as f:
            values = json.load(f)
    else:
        values = [
            [0.1, -0.2, 0.3],
            [0.4, 0.5, -0.6],
            [0.7, -0.8, 0.9],
        ]

    result = quantize(
        values,
        frac_bits=args.frac_bits,
        width=args.width,
    )

    with open(args.output, "w", encoding="utf-8") as f:
        json.dump(result.tolist(), f, indent=2)

    print("Quantized weights saved to:", args.output)
    print("Fixed-point scale:", 1 << args.frac_bits)
    print(result)


if __name__ == "__main__":
    main()
