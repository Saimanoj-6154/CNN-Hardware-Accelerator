#!/usr/bin/env python3

def conv2d_valid(image, kernel):
    """2-D valid convolution, stride 1, without padding."""
    height = len(image)
    width = len(image[0])
    kh = len(kernel)
    kw = len(kernel[0])

    if kh > height or kw > width:
        raise ValueError("Kernel must fit inside image")

    output = []

    for y in range(height - kh + 1):
        row = []

        for x in range(width - kw + 1):
            total = 0

            for ky in range(kh):
                for kx in range(kw):
                    total += image[y + ky][x + kx] * kernel[ky][kx]

            row.append(total)

        output.append(row)

    return output


def relu(matrix):
    return [
        [max(0, value) for value in row]
        for row in matrix
    ]


def max_pool2x2(matrix):
    """Non-overlapping 2x2 max pooling with stride 2."""
    height = len(matrix)
    width = len(matrix[0])

    if height < 2 or width < 2:
        raise ValueError("Pooling input must be at least 2x2")

    output = []

    for y in range(0, height - 1, 2):
        row = []

        for x in range(0, width - 1, 2):
            values = [
                matrix[y][x],
                matrix[y][x + 1],
                matrix[y + 1][x],
                matrix[y + 1][x + 1],
            ]

            row.append(max(values))

        output.append(row)

    return output


if __name__ == "__main__":
    image = [
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
    ]

    kernel = [
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1],
    ]

    conv = conv2d_valid(image, kernel)
    activated = relu(conv)
    pooled = max_pool2x2(activated)

    print("Input:", image)
    print("Kernel:", kernel)
    print("Convolution:", conv)
    print("ReLU:", activated)
    print("Max pool:", pooled)
