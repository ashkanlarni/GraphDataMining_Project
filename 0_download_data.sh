#!/bin/bash

# Set variables
SYMBOL="LTCUSDT"
INTERVAL="1m"
START_DATE="2018-01-01"
END_DATE=$(date +"%Y-%m-%d")  # Today's date by default
OUTPUT_DIR="data"
COMBINED_CSV="${OUTPUT_DIR}/${SYMBOL}_${INTERVAL}_combined.csv"

# Create output directory
mkdir -p "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}/csv/${SYMBOL}"

# Function to check if a date is before another date -- used in the loop to decide when to stop.
date_before() {
    local dt1=$(date -d "$1" +%s)
    local dt2=$(date -d "$2" +%s)
    [ "$dt1" -lt "$dt2" ]
}

# Function to download and extract data for a specific date
download_data() {
    local date=$1
    local filename="${SYMBOL}-${INTERVAL}-${date}.zip"
    local url="https://data.binance.vision/data/spot/daily/klines/${SYMBOL}/${INTERVAL}/${filename}"
    local csv_filename="${SYMBOL}-${INTERVAL}-${date}.csv"
    
    echo "Processing ${date}..."
    
    # Download the zip file
    if curl -s --head --fail "${url}" > /dev/null; then
        echo "Downloading ${url}"
        curl -s -o "${OUTPUT_DIR}/${filename}" "${url}"
        
        # Extract the zip file
        unzip -q -o "${OUTPUT_DIR}/${filename}" -d "${OUTPUT_DIR}/csv/${SYMBOL}"
        
        # Optionally, remove the zip file to save space
        rm "${OUTPUT_DIR}/${filename}"
        
        echo "Successfully processed ${date}"
    else
        echo "No data available for ${date}"
    fi
}

# Iterate through dates
current_date="${START_DATE}"
while date_before "${current_date}" "${END_DATE}"; do
    download_data "${current_date}"
    
    # Move to next day
    current_date=$(date -d "${current_date} + 1 day" +"%Y-%m-%d")
    
    # Add a small delay to avoid hitting rate limits
    sleep 0.2
done

# Optionally, combine all CSV files into one
# echo "Combining CSV files..."
# # Add header first (adjust columns based on actual data format)
# echo "Open time,Open,High,Low,Close,Volume,Close time,Quote asset volume,Number of trades,Taker buy base asset volume,Taker buy quote asset volume,Ignore" > "${COMBINED_CSV}"

# # Append data from each CSV file
# for csv_file in "${OUTPUT_DIR}"/csv/*.csv; do
#     # Skip header and append data
#     tail -n +2 "${csv_file}" >> "${COMBINED_CSV}"
# done

echo "Done!"