import csv
import os

BASE_PATH = "lib/design/Datasets"

def decorate_subdivisions():
    # 1. Build authoritative ISO Map
    iso_map = {}
    with open(f"{BASE_PATH}/countries.csv", 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            iso_map[row['country_iso2']] = row['country_iso3']
    print(f"DEBUG: ISO Map built with {len(iso_map)} entries.")

    # 2. Decorate Subdivisions
    input_file = f"{BASE_PATH}/subdivisions.csv"
    output_file = f"{BASE_PATH}/subdivisions_decorated.csv"

    with open(input_file, 'r', encoding='utf-8') as fin, \
         open(output_file, 'w', encoding='utf-8', newline='') as fout:
        
        reader = csv.DictReader(fin)
        fieldnames = reader.fieldnames + ['country_iso3']
        
        writer = csv.DictWriter(fout, fieldnames=fieldnames)
        writer.writeheader()

        for row in reader:
            iso2 = row.get('country_iso2')
            iso3 = iso_map.get(iso2)
            
            if iso3:
                row['country_iso3'] = iso3
                writer.writerow(row)
            else:
                print(f"WARNING: No ISO3 match for ISO2 '{iso2}' in subdivision {row.get('subdivision_code')}")
    
    print(f"SUCCESS: Decorated file created at {output_file}")

if __name__ == "__main__":
    decorate_subdivisions()