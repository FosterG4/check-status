#!/bin/bash

# Define the file containing the list of URLs
url_file="urls.txt"

# Define the output file to store the results
output_file="status.txt"

# Check if the file exists
if [ ! -f "$url_file" ]; then
  echo "URL file '$url_file' not found."
  exit 1
fi

# Clear the existing output file
> "$output_file"

# Define the UTC+7 timezone offset in hours (7 hours ahead of UTC)
timezone_offset=7

# Loop through each URL in the file
while read -r url; do
  # Use date to get the current date and time in UTC+7 timezone
  current_datetime=$(TZ="Etc/GMT-7" date "+%Y-%m-%d %H:%M:%S %Z")

  # Use curl to make the HTTP request and store the full response header in a variable
  response_header=$(curl -sI "$url")

  # Extract the HTTP status line from the response header
  http_status_line=$(echo "$response_header" | grep -i "HTTP/1\.[01]")

  # Extract the status code and status message
  status_code=$(echo "$http_status_line" | awk '{print $2}')
  status_message=$(echo "$http_status_line" | awk '{$1=""; $2=""; print $0}' | sed -e 's/^[ \t]*//')

  # Format the output
  result="URL: $url - Date/Time (UTC+7): $current_datetime - HTTP Status: $status_code $status_message"

  # Append the result to the output file
  echo "$result" >> "$output_file"

  # Print the result to the terminal as well if needed
  echo "$result"
done < "$url_file"

echo "Results have been saved to '$output_file'"
