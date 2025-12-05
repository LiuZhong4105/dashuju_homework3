#!/bin/bash

# Script to compare storage sizes and query performance across different formats
# Run after run-queries.sh

set -e

RESULTS_DIR="../results"

echo "=========================================="
echo "Hive Storage Format Comparison Report"
echo "=========================================="
date
echo ""

# Function to get HDFS storage size
get_storage_size() {
    local database=$1
    local size=$(hdfs dfs -du -s -h /user/hive/warehouse/${database}.db 2>/dev/null | awk '{print $1" "$2}')
    echo "$size"
}

# Function to get detailed table sizes
get_table_sizes() {
    local database=$1
    hdfs dfs -du -h /user/hive/warehouse/${database}.db 2>/dev/null | awk '{printf "  %-20s %10s\n", $3, $1" "$2}'
}

echo "=========================================="
echo "1. STORAGE SIZE COMPARISON"
echo "=========================================="
echo ""

FORMATS=("text" "orc" "parquet" "rc")

# Print header
printf "%-15s %15s\n" "Format" "Total Size"
echo "----------------------------------------"

# Store sizes for comparison
declare -A sizes
for format in "${FORMATS[@]}"; do
    database="tpch_${format}"
    size=$(get_storage_size $database)
    sizes[$format]=$size
    printf "%-15s %15s\n" "$format" "$size"
done

echo ""
echo "Detailed table sizes for each format:"
echo ""

for format in "${FORMATS[@]}"; do
    database="tpch_${format}"
    echo "${format} format tables:"
    get_table_sizes $database
    echo ""
done

echo "=========================================="
echo "2. QUERY PERFORMANCE COMPARISON"
echo "=========================================="
echo ""

# Check if results exist
if [ ! -d "$RESULTS_DIR" ] || [ -z "$(ls -A $RESULTS_DIR 2>/dev/null)" ]; then
    echo "No query results found. Please run run-queries.sh first."
    exit 1
fi

# Print query performance for each query
QUERIES=(1 2 3 4 5)

for query in "${QUERIES[@]}"; do
    echo "Query ${query} execution time:"
    printf "  %-15s %15s\n" "Format" "Time (seconds)"
    echo "  ----------------------------------------"
    
    for format in "${FORMATS[@]}"; do
        time_file="${RESULTS_DIR}/${format}_query${query}_time.txt"
        if [ -f "$time_file" ]; then
            time=$(cat $time_file)
            printf "  %-15s %15.3f\n" "$format" "$time"
        else
            printf "  %-15s %15s\n" "$format" "N/A"
        fi
    done
    echo ""
done

echo "=========================================="
echo "3. AVERAGE QUERY PERFORMANCE"
echo "=========================================="
echo ""

printf "%-15s %15s\n" "Format" "Avg Time (sec)"
echo "----------------------------------------"

for format in "${FORMATS[@]}"; do
    total=0
    count=0
    for query in "${QUERIES[@]}"; do
        time_file="${RESULTS_DIR}/${format}_query${query}_time.txt"
        if [ -f "$time_file" ]; then
            time=$(cat $time_file)
            total=$(echo "$total + $time" | bc)
            count=$((count + 1))
        fi
    done
    
    if [ $count -gt 0 ]; then
        avg=$(echo "scale=3; $total / $count" | bc)
        printf "%-15s %15.3f\n" "$format" "$avg"
    else
        printf "%-15s %15s\n" "$format" "N/A"
    fi
done

echo ""
echo "=========================================="
echo "4. SUMMARY AND RECOMMENDATIONS"
echo "=========================================="
echo ""

cat << 'EOF'
Storage Format Characteristics:

TextFile:
  - Largest storage size (no compression)
  - Human-readable format
  - Slowest query performance
  - Good for: Data exchange, debugging
  
RCFile:
  - Medium storage size (row-columnar compression)
  - Medium query performance
  - Good for: Mixed workloads, append operations

ORC:
  - Smallest storage size (advanced compression)
  - Fastest query performance
  - Optimized for Hive
  - Good for: Analytics, large datasets, Hive-native workflows

Parquet:
  - Small storage size (columnar compression)
  - Fast query performance
  - Optimized for nested data
  - Good for: Cross-platform analytics, Spark integration

Recommendations:
  - Use ORC for Hive-centric analytics workflows
  - Use Parquet for cross-platform big data processing
  - Use TextFile only for temporary data or debugging
  - Avoid RCFile for new projects (legacy format)
EOF

echo ""
echo "=========================================="
echo "Report generation completed!"
echo "=========================================="
echo ""
echo "All results saved in: ${RESULTS_DIR}/"
