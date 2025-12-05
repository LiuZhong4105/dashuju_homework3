#!/bin/bash

# Script to run TPC-H queries on different storage formats and measure performance
# Run after create-tables.sh

set -e

RESULTS_DIR="../results"
QUERIES_DIR="../queries"

# Create results directory if it doesn't exist
mkdir -p $RESULTS_DIR

echo "=========================================="
echo "Running TPC-H Queries on Different Formats"
echo "=========================================="

# Array of storage formats
FORMATS=("text" "orc" "parquet" "rc")

# Array of queries
QUERIES=(1 2 3 4 5)

# Function to run a query and measure time
run_query() {
    local format=$1
    local query_num=$2
    local database="tpch_${format}"
    local query_file="${QUERIES_DIR}/query${query_num}.sql"
    local output_file="${RESULTS_DIR}/${format}_query${query_num}.txt"
    
    echo ""
    echo "Running Query ${query_num} on ${format} format..."
    
    # Create a temporary SQL file with USE database statement
    local temp_sql="/tmp/query_${format}_${query_num}.sql"
    echo "USE ${database};" > $temp_sql
    cat $query_file >> $temp_sql
    
    # Record start time
    local start_time=$(date +%s.%N)
    
    # Run the query
    hive -f $temp_sql > $output_file 2>&1
    
    # Record end time
    local end_time=$(date +%s.%N)
    
    # Calculate duration
    local duration=$(echo "$end_time - $start_time" | bc)
    
    echo "  Completed in ${duration} seconds"
    echo "${duration}" > "${RESULTS_DIR}/${format}_query${query_num}_time.txt"
    
    # Clean up
    rm -f $temp_sql
}

# Run all queries for all formats
for format in "${FORMATS[@]}"; do
    echo ""
    echo "=========================================="
    echo "Testing ${format} format"
    echo "=========================================="
    
    for query in "${QUERIES[@]}"; do
        run_query $format $query
    done
done

echo ""
echo "=========================================="
echo "All queries completed!"
echo "=========================================="
echo ""
echo "Results saved in: ${RESULTS_DIR}/"
echo ""
echo "Next step: Run bash compare-results.sh to see performance comparison"
