#!/bin/bash

set -e

echo "Updating package lists..."
sudo apt update

echo "Installing essential build tools..."
sudo apt install -y build-essential

echo "Installing C and C++ compilers and tools..."
sudo apt install -y gcc g++ gdb

echo "Installing assembly tools (NASM, Binutils)..."
sudo apt install -y nasm binutils

echo "Installing Make utility..."
sudo apt install -y make

echo "Installing Python and development headers..."
sudo apt install -y python3 python3-pip python3-venv python3-dev

echo "Installing some common useful utilities..."
sudo apt install -y git cmake pkg-config

echo "All done! Basic C, C++, ASM, Makefile and Python dev environment installed."
