# Test Results Directory

This directory stores the results of benchmark queries executed on different storage formats.

## File Structure

After running the tests, you will find files like:

```
results/
├── text_query1.txt          # Query 1 output for TextFile format
├── text_query1_time.txt     # Query 1 execution time for TextFile
├── text_query2.txt
├── text_query2_time.txt
├── ...
├── orc_query1.txt           # Query 1 output for ORC format
├── orc_query1_time.txt      # Query 1 execution time for ORC
├── ...
├── parquet_query1.txt       # Query 1 output for Parquet format
├── parquet_query1_time.txt
├── ...
└── rc_query1.txt            # Query 1 output for RCFile format
    rc_query1_time.txt
    ...
```

## File Naming Convention

- `{format}_query{number}.txt` - Contains query output and any error messages
- `{format}_query{number}_time.txt` - Contains execution time in seconds

Where:
- `{format}` is one of: text, orc, parquet, rc
- `{number}` is the query number: 1, 2, 3, 4, 5

## Analyzing Results

Use the `compare-results.sh` script to generate a comprehensive comparison report:

```bash
cd ../scripts
bash compare-results.sh
```

This will display:
1. Storage size comparison across formats
2. Query execution time for each query and format
3. Average query performance by format
4. Summary and recommendations

## Manual Analysis

You can also manually analyze individual results:

```bash
# View query output
cat text_query1.txt

# View execution time
cat text_query1_time.txt

# Compare times for a specific query across formats
echo "Query 1 execution times:"
echo -n "TextFile: " && cat text_query1_time.txt
echo -n "ORC: " && cat orc_query1_time.txt
echo -n "Parquet: " && cat parquet_query1_time.txt
echo -n "RCFile: " && cat rc_query1_time.txt
```

## Expected Results Pattern

Generally, you should observe:

**Storage Efficiency:**
1. ORC - Smallest size
2. Parquet - Small size
3. RCFile - Medium size
4. TextFile - Largest size

**Query Performance (fastest to slowest):**
1. ORC - Fastest
2. Parquet - Fast
3. RCFile - Medium
4. TextFile - Slowest

## Notes

- Results may vary based on data size, hardware, and Hadoop/Hive configuration
- First run of queries may be slower due to cold caches
- Multiple runs should be performed for more accurate averages
- The actual performance difference depends on query characteristics
