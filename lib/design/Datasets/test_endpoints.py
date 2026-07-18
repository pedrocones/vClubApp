import os
import csv
import ssl
import urllib.request

print("--- OPENING LIVE GITLAB TEXT STREAM TO INSPECT COLUMNS ---")

gitlab_url = "https://gitlab.com"

try:
    # Bypass local Windows SSL validation bugs completely
    bypass_ssl_context = ssl._create_unverified_context()
    
    req = urllib.request.Request(
        gitlab_url, 
        headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
    )
    
    with urllib.request.urlopen(req, timeout=15, context=bypass_ssl_context) as response:
        # Read the first two lines containing headers and a data sample
        line1 = response.readline().decode('utf-8').strip()
        line2 = response.readline().decode('utf-8').strip()
        
        print("\n" + "="*60)
        print("EXACT REMOTE CSV HEADERS:")
        print(line1)
        print("\nFIRST REMOTE DATA ROW SAMPLE:")
        print(line2)
        print("="*60)

except Exception as err:
    print(f"\n[Inspection Error]: Could not read source keys: {err}")
