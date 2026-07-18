import csv

BASE_DIR = "lib/design/Datasets"

def consolidate():
    # 1. Load ISO3166 Metadata (Name & Category)
    iso_map = {}
    with open(f"{BASE_DIR}/ISO3166.csv", 'r', encoding='utf-8') as f:
        # Assumes ISO3166.csv has: 'code', 'subdivision_name', 'subdivision_category'
        for row in csv.DictReader(f):
            iso_map[row['code'].strip().upper()] = {
                'subdivision_name': row.get('subdivision_name', ''),
                'subdivision_category': row.get('subdivision_category', '')
            }

    # 2. Consolidate town-list.csv to vicinum_db.csv
    # We maintain all towns, adding metadata + future maintenance fields
    with open(f"{BASE_DIR}/town-list.csv", 'r', encoding='utf-8') as fin, \
         open(f"{BASE_DIR}/vicinum_db.csv", 'w', encoding='utf-8', newline='') as fout:
        
        reader = csv.DictReader(fin)
        
        # Schema definition matching your requested fields
        fieldnames = [
            'country_iso2', 'country_iso3', 'country_name_ASCII', 
            'subdivision_code', 'subdivision_name', 'subdivision_category',
            'town_code', 'town_name', 'town_name_ASCII', 
            'town_population', 'latitude', 'longitude'
        ]
        
        writer = csv.DictWriter(fout, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            # Drop discrepancy rows? NO. We want the full town list.
            # We map from town-list.csv headers
            sub = row.get('subdivision_code', '').strip().upper()
            iso_data = iso_map.get(sub, {'subdivision_name': 'N/A', 'subdivision_category': 'N/A'})
            
            writer.writerow({
                'country_iso2': row.get('country', '').strip().upper(),
                'country_iso3': '', # Empty for future manual filling
                'country_name_ASCII': '', # Empty for future manual filling
                'subdivision_code': sub,
                'subdivision_name': iso_data['subdivision_name'],
                'subdivision_category': iso_data['subdivision_category'],
                'town_code': row.get('town_code', ''),
                'town_name': row.get('town_name', ''),
                'town_name_ASCII': row.get('town_name', ''), # Populated if needed
                'town_population': '', # Empty for future manual filling
                'latitude': row.get('latitude', ''),
                'longitude': row.get('longitude', '')
            })

    print("✅ 'vicinum_db.csv' generated. All towns included. Metadata enriched from ISO3166.")

if __name__ == "__main__":
    consolidate()