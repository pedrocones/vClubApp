import csv
import os

# Now targeting the full world registry
def compile_vicinum_database():
    base_path = os.path.join("lib", "design", "Datasets")
    iso_path = os.path.join(base_path, "ISO3166.csv")
    
    # 1. Load Master Source
    sub_cache = {}
    with open(iso_path, mode='r', encoding='utf-8') as f:
        for row in csv.DictReader(f):
            sub_cache[row['code']] = {"name": row['subdivision_name'], "cat": row['subdivision_category']}
            
    # 2. Main Compiler Loop
    # Simply match row['Country'] + '-' + row['Subdivision'] 
    # directly against sub_cache.keys(). No hacks needed.
    # If sub_cache.get(key) fails, then the UN-LOCODE row is truly invalid.
    
    print("🚀 Running clean compiler...")
    # ... (the rest of your logic remains the same, just point to the new files)