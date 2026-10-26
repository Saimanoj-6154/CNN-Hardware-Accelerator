#!/usr/bin/env python3

import argparse
import json
from pathlib import Path

import numpy as np

from cnn_reference import conv2d_valid, relu, max_pool2x2


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--out-dir", default="tb/test_vectors"
    )
    parser.add_argument("--seed", type=int, default=7)

    args = parser.parse_args()

    output_dir = Path(args.out_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    rng = np.random.default_rng(args.seed)

    image = rng.integers(-3, 8, size=(4, 4))
    kernel = rng.integers(-2, 3, size=(3, 3))

    conv = conv2d_valid(image.tolist(), kernel.tolist())
    activated = relu(conv)
    pooled = max_pool2x2(activated)

    data = {
        "image": image.tolist(),
        "kernel": kernel.tolist(),
        "convolution": conv,
        "relu": activated,
        "max_pool": pooled,
    }

    with open(
        output_dir / "vectors.json", "w", encoding="utf-8"
    ) as f:
        json.dump(data, f, indent=2)

    np.savetxt(
        output_dir / "input.mem",
        image.reshape(-1),
        fmt="%d",
    )

    np.savetxt(
        output_dir / "weights.mem",
        kernel.reshape(-1),
        fmt="%d",
    )

    np.savetxt(
        output_dir / "expected_conv.mem",
        np.asarray(conv).reshape(-1),
        fmt="%d",
    )

    print("Test vectors generated in:", output_dir)
    print("Image:\n", image)
    print("Kernel:\n", kernel)
    print("Expected convolution:\n", np.asarray(conv))
    print("Expected ReLU:\n", np.asarray(activated))
    print("Expected pooling:\n", np.asarray(pooled))


if __name__ == "__main__":
    main()
