## CNN-Hardware-Accelerator
A hardware-accelerated Convolutional Neural Network (CNN) inference engine implemented in Verilog HDL and deployed on an FPGA using Xilinx Vivado. The project explores hardware-efficient neural network computation through parallel multiply-accumulate (MAC) operations, optimized convolution datapaths, pipelining, and on-chip data buffering.

The accelerator is designed to demonstrate how CNN workloads can be mapped from a Python-based reference model to synthesizable RTL hardware for efficient inference.

## Project Overview

## Key Features

Hardware-based convolution: Implements convolution operations using multiply-accumulate units.

Parallel computation: Supports parallel processing of multiple input values and convolution operations.

Pipelined datapath: Uses pipeline stages to improve throughput.

Fixed-point arithmetic: Supports quantized arithmetic to reduce hardware resource requirements.

Activation functions: Implements ReLU activation for nonlinear processing.

Pooling support: Provides a pooling stage for spatial feature-map reduction.

Python reference model: Provides a software model for functional comparison with the RTL implementation.

FPGA synthesis: Uses Vivado for synthesis, implementation, timing analysis, and resource utilization reports.

RTL verification: Supports testbench-based validation of arithmetic operations and CNN layer outputs.

## Architecture

The accelerator follows a modular processing pipeline:

```
Input Image / Feature Map
                   |
                   v
        +----------------------+
        | Input Buffer / BRAM  |
        +----------------------+
                   |
                   v
        +----------------------+
        | Convolution Engine   |
        | MAC Processing Units |
        +----------------------+
                   |
                   v
        +----------------------+
        | Bias Addition        |
        +----------------------+
                   |
                   v
        +----------------------+
        | ReLU Activation      |
        +----------------------+
                   |
                   v
        +----------------------+
        | Pooling Unit         |
        +----------------------+
                   |
                   v
        +----------------------+
        | Output Buffer        |
        +----------------------+
                   |
                   v
          CNN Feature Output
```
---
The convolution engine performs the dominant arithmetic operations. Input feature maps and weights are supplied to the processing datapath, where multiplication and accumulation produce the output feature maps.

The architecture can be extended with additional convolution layers, configurable kernel sizes, multiple MAC units, and a controller for sequencing CNN operations.

### Hardware Design

## 1. Convolution Engine

The convolution engine computes weighted sums over local regions of an input feature map.

For a single output element:

[
Y_{i,j}=\sum_{m=0}^{K-1}\sum_{n=0}^{K-1}
X_{i+m,j+n}W_{m,n}+b
]

Where:

(X) represents the input feature map.

(W) represents the convolution kernel.

(b) is the bias.

(K) is the kernel dimension.

(Y) is the output feature map.

## 2. Multiply-Accumulate Unit

The MAC unit performs multiplication and accumulation operations required by convolution layers. Multiple MAC units can operate in parallel to increase processing throughput.

## 3. Activation Unit

The ReLU activation function is defined as:

[
\operatorname{ReLU}(x)=\max(0,x)
]

This operation can be implemented using a sign check and a zero-selection datapath.

## 4. Pooling Unit

The pooling stage reduces the spatial dimensions of feature maps. A max-pooling implementation selects the maximum value within a local window.

## 5. Control Unit

A finite-state machine coordinates input loading, weight access, convolution execution, activation, pooling, and output storage.

