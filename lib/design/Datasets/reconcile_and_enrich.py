import csv
import os

BASE_DIR = "lib/design/Datasets"

def reconcile():
    # 1. Load ISO3166: Map {Country, SubdivisionName} -> {SubdivisionCode}
    # This is our reverse-lookup table for the "Best Guess"
    iso_name_to_code = {}
    # ISO3166.csv: country_code, subdivision_name, code, subdivision_category
    with open(f"{BASE_DIR}/ISO3166.csv", 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            key = (row['country_code'].strip().upper(), row['subdivision_name'].strip().upper())
            iso_name_to_code[key] = row['code'].strip().upper()

    # 2. Load WorldCities: Map (Country, City_ASCII) -> Admin_Name
    city_map = {}
    with open(f"{BASE_DIR}/worldcities.csv", 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            key = (row['iso2'].upper(), row['city_ascii'].upper())
            city_map[key] = row['admin_name'].strip().upper()

    # 3. Process Code-List and enrich
    enriched_rows = []
    total_processed = 0
    total_discrepancies = 0

    with open(f"{BASE_DIR}/code-list.csv", 'r', encoding='utf-8-sig') as f:
        reader = list(csv.DictReader(f))
        fieldnames = list(reader[0].keys()) + [
            'raw_iso_key_check', 'iso_name_match', 'worldcities_admin_name', 
            'best_guess_sub_code', 'discrepancy_found'
        ]
        
        for row in reader:
            total_processed += 1
            country = row['Country'].strip().upper()
            sub = row['Subdivision'].strip()
            city = row['Name'].strip().upper()
            
            # A. Current raw key check
            raw_iso_key = f"{country}-{sub}" if sub else ""
            
            # B. Check Source of Trust
            # Note: We need a map for code->name for this lookup
            iso_code_to_name = {k[1]: v for k, v in iso_name_to_code.items()} # Reversing map for display
            
            # C. Inference Logic
            best_guess_code = ""
            discrepancy = "NO"
            
            # If current code isn't in ISO, flag as discrepancy
            if raw_iso_key not in iso_name_to_code.values():
                discrepancy = "YES"
                total_discrepancies += 1
                
                # Secondary Guess: Use WorldCities admin_name to find ISO code
                admin_name = city_map.get((country, city), "").upper()
                if admin_name:
                    best_guess_code = iso_name_to_code.get((country, admin_name), "")

            # Populate row
            row['raw_iso_key_check'] = raw_iso_key
            row['iso_name_match'] = "OK" if raw_iso_key in iso_name_to_code.values() else "!!! NOT IN ISO !!!"
            row['worldcities_admin_name'] = city_map.get((country, city), "NOT FOUND")
            row['best_guess_sub_code'] = best_guess_code
            row['discrepancy_found'] = discrepancy
            
            enriched_rows.append(row)
            
            if total_processed % 500 == 0:
                print(f"Processed: {total_processed} | Discrepancies: {total_discrepancies}")

    # 4. Write output
    with open(f"{BASE_DIR}/code-list-discrepancies.csv", 'w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(enriched_rows)

    print(f"\n✅ Reconciliation complete: {total_discrepancies} discrepancies found.")

if __name__ == "__main__":
    reconcile()