# Configurable Ring Oscillator Physically Unclonable Function (CRO PUF)

## Overview
A **Configurable Ring Oscillator Physically Unclonable Function (CRO PUF)** is a hardware-based security primitive that leverages the unique frequency variations of ring oscillators (ROs) in integrated circuits to generate device-specific responses. This repository provides a **Verilog implementation** of a CRO PUF, along with simulation, synthesis, and testing scripts.

The CRO PUF is **highly configurable**, allowing users to adjust:
- The number of ring oscillators
- Challenge length
- Response length

It is suitable for **FPGA and ASIC** implementations.

## Features
- **Configurable RO PUF design** with added functionality of reconfigurability based on the input challenge bits c1,c2,c3.
- **Verilog-based implementation**
- **Acquires very less space in Basys 3 FPGA**
- **UART communication has been performed**
- **Python scripts for and analysis**
- **Integration support for hardware security applications**

## CRO-PUf-Diagram

![image](https://github.com/user-attachments/assets/667f333b-12a0-4097-9fe3-6628a784c7c5)

![image](https://github.com/user-attachments/assets/7cad7387-c1c5-4c3a-a5ca-e34e0d6e06d3)
