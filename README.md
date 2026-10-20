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
