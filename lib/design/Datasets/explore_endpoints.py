import socket
import urllib.request

print("Starting explicit socket & endpoint stream exploration...")

# List of endpoints to verify raw data streams
test_endpoints = {
    "unpkg_direct_data": "https://unpkg.com",
    "gitlab_raw_mirror": "https://gitlab.com",
    "github_datasets": "https://githubusercontent.com"
}

# 1. Manual low-level socket diagnostic check to investigate IP routing
domains_to_test = ["unpkg.com", "gitlab.com", "raw.githubusercontent.com"]
print("\n--- [Step 1: Low-Level Socket Connection Test] ---")
for domain in domains_to_test:
    try:
        print(f"Opening manual stream to {domain}:443...")
        # Explicitly open a raw socket stream connection
        s = socket.create_connection((domain, 443), timeout=5)
        print(f" -> SUCCESS: Stream socket established with {domain}")
        s.close()
    except Exception as e:
        print(f" -> SOCKET FAILED for {domain}: {e}")

# 2. HTTP response inspection to check format and data types
print("\n--- [Step 2: Stream Header & Content Exploration] ---")
for name, url in test_endpoints.items():
    print(f"\nExploring stream properties for [{name}]...")
    try:
        req = urllib.request.Request(
            url, 
            headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
        )
        with urllib.request.urlopen(req, timeout=10) as response:
            headers = response.info()
            content_type = headers.get('Content-Type', 'Unknown')
            # Read only the first 250 bytes to preview structure safely
            sample_bytes = response.read(250)
            
            print(f" -> Connected! Status Code: {response.getcode()}")
            print(f" -> Content-Type Reported: {content_type}")
            print(f" -> Stream Preview:\n{sample_bytes.decode('utf-8', errors='replace')}")
    except Exception as e:
        print(f" -> HTTP STREAM ERROR for [{name}]: {e}")

print("\nExploration completed.")
