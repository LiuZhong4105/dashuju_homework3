#!/bin/bash

# Script to setup TPC-H data generator for Hive testing
# Run as regular user: bash 04-setup-testbench.sh

set -e

echo "=========================================="
echo "Setting up TPC-H Data Generator"
echo "=========================================="

# Check if Hive is installed
if [ ! -d "/usr/local/hive" ]; then
    echo "ERROR: Hive not found. Please run 03-install-hive.sh first."
    exit 1
fi

# Clone TPC-H data generator if not already present
if [ ! -d "tpch-dbgen" ]; then
    echo "Cloning TPC-H data generator..."
    git clone https://github.com/electrum/tpch-dbgen.git
else
    echo "TPC-H data generator already cloned"
fi

# Build the data generator
echo "Building TPC-H data generator..."
cd tpch-dbgen

# Create makefile.suite if it doesn't exist
if [ ! -f "makefile.suite" ]; then
    cp makefile.suite.sample makefile.suite 2>/dev/null || true
fi

# Compile
make clean 2>/dev/null || true
make

# Verify dbgen was built
if [ ! -f "dbgen" ]; then
    echo "ERROR: Failed to build dbgen"
    exit 1
fi

cd ..

echo "=========================================="
echo "TPC-H data generator setup completed!"
echo "=========================================="
echo ""
echo "To generate TPC-H data:"
echo "1. cd tpch-dbgen"
echo "2. ./dbgen -s 1  # Generate 1GB dataset (scale factor 1)"
echo ""
echo "Scale factor options:"
echo "  -s 1   = ~1GB data"
echo "  -s 10  = ~10GB data"
echo "  -s 100 = ~100GB data"
echo ""
echo "Generated files will be: customer.tbl, lineitem.tbl, nation.tbl,"
echo "                        orders.tbl, part.tbl, partsupp.tbl,"
echo "                        region.tbl, supplier.tbl"
echo ""
echo "Next: Use scripts in the scripts/ directory to load data into Hive"
