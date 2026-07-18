import csv

BASE_DIR = "lib/design/Datasets"

def generate_town_list():
    geo_map = {}
    with open(f"{BASE_DIR}/worldcities.csv", 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            geo_map[(row['iso2'].upper(), row['city_ascii'].upper())] = {'lat': row['lat'], 'lng': row['lng']}

    input_file = f"{BASE_DIR}/code-list-discrepancies.csv"
    output_file = f"{BASE_DIR}/town-list.csv"
    
    with open(input_file, 'r', encoding='utf-8') as fin, \
         open(output_file, 'w', encoding='utf-8', newline='') as fout:
        
        reader = csv.DictReader(fin)
        fieldnames = list(reader.fieldnames) + ['subdivision_code', 'promoted', 'town_code', 'latitude', 'longitude']
        writer = csv.DictWriter(fout, fieldnames=fieldnames)
        writer.writeheader()
        
        count = 0
        for row in reader:
            # Debugging: Print first 10 rows to see what is actually in the columns
            if count < 10:
                print(f"Row {count} | Disc: '{row.get('discrepancy_found')}' | Guess: '{row.get('best_guess_code')}'")
                count += 1
            
            # --- Logic ---
            discrepancy = row.get('discrepancy_found', '').strip().upper()
            best_guess = row.get('best_guess_code', '').strip()
            raw_key = row.get('raw_iso_key_check', '').strip()

          # --- RIGOROUS PROMOTION LOGIC ---
            best_guess = row.get('best_guess_sub_code', '').strip()
 #           print(f" best guess {best_guess}" )

            # Use 'None' string literal check as per your diagnostic output
            is_guess_valid = best_guess and best_guess.upper() != 'NONE' and best_guess != ''
            
            if discrepancy == 'YES' and is_guess_valid:
                row['subdivision_code'] = best_guess
                row['promoted'] = 'YES'
                row['discrepancy_found'] = 'NO'
            elif discrepancy == 'NO':
                row['subdivision_code'] = raw_key
                row['promoted'] = 'NO'
            else:
                row['subdivision_code'] = raw_key if raw_key else ""
                row['promoted'] = 'NO'

            # Save Town Code & Geo
            country = row.get('Country', '').strip().upper()
            town_name = row.get('Name', '').strip()
            row['town_code'] = f"{row['subdivision_code'] or (country + '-XXX')}-{row.get('Location', 'XXX')}"
            
            geo = geo_map.get((country, town_name.upper()), {'lat': '', 'lng': ''})
            row['latitude'] = geo['lat']
            row['longitude'] = geo['lng']
            
            writer.writerow(row)

    print(f"✅ Finished. Check terminal output for the first 10 rows.")

if __name__ == "__main__":
    generate_town_list()