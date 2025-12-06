#!/bin/bash

# Script to generate TPC-H benchmark data
# Usage: bash generate-data.sh [scale_factor]
# Example: bash generate-data.sh 1  (generates ~1GB data)

set -e

# Default scale factor is 1 (1GB)
SCALE_FACTOR=${1:-1}

echo "=========================================="
echo "Generating TPC-H Data (Scale Factor: ${SCALE_FACTOR})"
echo "=========================================="

# Check if tpch-dbgen exists
if [ ! -d "../tpch-dbgen" ] && [ ! -d "tpch-dbgen" ]; then
    echo "ERROR: tpch-dbgen directory not found."
    echo "Please run: cd .. && bash setup/04-setup-testbench.sh"
    exit 1
fi

# Navigate to tpch-dbgen directory
if [ -d "../tpch-dbgen" ]; then
    cd ../tpch-dbgen
elif [ -d "tpch-dbgen" ]; then
    cd tpch-dbgen
fi

# Clean up old data files
echo "Cleaning up old data files..."
rm -f *.tbl

# Generate data
echo "Generating TPC-H data with scale factor ${SCALE_FACTOR}..."
echo "This may take several minutes..."
./dbgen -s ${SCALE_FACTOR}

# Verify data was generated
if [ ! -f "lineitem.tbl" ]; then
    echo "ERROR: Data generation failed"
    exit 1
fi

# Show generated files
echo ""
echo "Data generation completed!"
echo "Generated files:"
ls -lh *.tbl

# Calculate total size
TOTAL_SIZE=$(du -sh *.tbl | awk '{sum+=$1} END {print sum}')
echo ""
echo "Total data size: $(du -ch *.tbl | grep total | awk '{print $1}')"

# Upload to HDFS
echo ""
echo "Uploading data to HDFS..."
hdfs dfs -mkdir -p /user/$USER/tpch/data
hdfs dfs -rm -r -f /user/$USER/tpch/data/*.tbl 2>/dev/null || true

for file in *.tbl; do
    echo "Uploading $file..."
    hdfs dfs -put -f $file /user/$USER/tpch/data/
done

echo ""
echo "=========================================="
echo "Data generation and upload completed!"
echo "=========================================="
echo ""
echo "Data location in HDFS: /user/$USER/tpch/data/"
echo ""
echo "Next step: Run bash create-tables.sh to create tables in different formats"
