import csv
import pycountry
import os

BASE_DIR = "lib/design/Datasets"

def get_iso3(iso2):
    """Utility to lookup ISO3 for decoration."""
    country = pycountry.countries.get(alpha_2=iso2)
    return country.alpha_3 if country else "XXX"

def consolidate():
    print("🔄 Consolidating all audit files into a single master source...")

    # 1. Load Subdivisions metadata map
    sub_map = {}
    with open(f'{BASE_DIR}/subdivisions.csv', 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            sub_map[row['subdivision_code']] = row

    # 2. Process Towns and decorate with Country/Subdivision metadata
    output_path = f'{BASE_DIR}/vicinum_db_final.csv'
    
    with open(f'{BASE_DIR}/towns.csv', 'r', encoding='utf-8') as fin, \
         open(output_path, 'w', newline='', encoding='utf-8') as fout:
        
        # Define fields: CSV reader fields + Decorations
        reader = csv.DictReader(fin)
        fieldnames = reader.fieldnames + ['country_iso3', 'subdivision_name_local', 'subdivision_name_en']
        writer = csv.DictWriter(fout, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            iso2 = row['country_iso2']
            sub_code = row['subdivision_code']
            
            # Decorate ISO3
            row['country_iso3'] = get_iso3(iso2)
            
            # Decorate Subdivision Names
            sub_data = sub_map.get(sub_code, {})
            row['subdivision_name_local'] = sub_data.get('subdivision_name_local', 'UNKNOWN')
            row['subdivision_name_en'] = sub_data.get('subdivision_name_en', 'UNKNOWN')
            
            writer.writerow(row)

    print(f"🏁 Master source created at {output_path}")

if __name__ == "__main__":
    consolidate()