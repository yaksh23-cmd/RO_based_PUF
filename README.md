# Configurable Ring Oscillator Physically Unclonable Function (CRO PUF)

## Overview
A **Configurable Ring Oscillator Physically Unclonable Function (CRO PUF)** is a hardware-based security primitive that leverages the unique frequency variations of ring oscillators (ROs) in integrated circuits to generate device-specific responses. This repository provides a **Verilog implementation** of a CRO PUF, along with simulation, synthesis, and testing scripts.

The CRO PUF is **highly configurable**, allowing users to adjust:
- The number of ring oscillators
- Challenge length
- Response length

It is suitable for **FPGA and ASIC** implementations.

## Features
- **Configurable RO PUF design** with adjustable parameters
- **Verilog-based implementation**
- **Supports FPGA and ASIC synthesis**
- **Testbench for functional verification**
- **Python scripts for evaluation and analysis**
- **Integration support for hardware security applications**

## CRO-PUf-Diagram

![image](https://github.com/user-attachments/assets/9c1ef8c5-8085-450d-897c-3400158e1459)

### In the above diagram ring oscillator unit is replaced with the feed-forward ring oscillator given below:
![image](https://github.com/user-attachments/assets/c18747b8-6136-4374-be72-a7e43041a36d)
