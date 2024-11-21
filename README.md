# BSQLI_Automation

## Description
This repository contains a simple bash script to automate SQL injection testing on subdomains by injecting payloads into various HTTP headers.

## Usage
To run the script, use the following command:

```bash
./bsqli.sh -l <subdomain_list> -p <payload>
```
## Parameters
-l : Path to the file containing a list of subdomains, one per line.
-p : SQL injection payload to inject (e.g., "' OR SLEEP(5) --").
## Example
./bsqli.sh -l subs.txt -p "' OR SLEEP(5) --"
## Requirements
curl
## How It Works
The script:

1. Takes a list of subdomains and a SQL injection payload as input.
2. Iterates through each subdomain and injects the payload into specified HTTP headers.
3. Measures the response time to identify potential SQL injection vulnerabilities.

## Headers Tested
User-Agent
Referer
X-Forwarded-For
X-Client-IP
X-Real-IP

## Logging
If the response time is 5 seconds or more, the script logs the domain as potentially vulnerable.

## Notes
Make sure to have appropriate permissions and follow ethical guidelines when testing for vulnerabilities.

