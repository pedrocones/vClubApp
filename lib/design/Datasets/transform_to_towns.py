import csv
import os

BASE_DIR = "lib/design/Datasets"

# 15-field Schema
FIELDS = [
    'subdivision_code', 'town_code', 'town_unicode', 'town_name_local', 
    'town_name_en', 'town_name_es', 'town_name_fr', 'town_population', 
    'town_last_census', 'town_latitude', 'town_longitude', 
    'sustainable_living_index', 'status_flag', 'isFieldChange', 'remarks'
]

def generate_town_code(town_name_en, existing_codes):
    letter = town_name_en[0].upper() if town_name_en else 'A'
    relevant = [c for c in existing_codes if c.startswith(letter)]
    if not relevant: return f"{letter}0010"
    
    max_num = max([int(code[1:]) for code in relevant])
    return f"{letter}{(max_num + 10):04d}"

def transform():
    existing_codes = []
    processed_count = 0
    
    print(f"🚀 Starting transformation of town-list.csv...")
    
    with open(f'{BASE_DIR}/town-list.csv', 'r', encoding='utf-8') as fin, \
         open(f'{BASE_DIR}/towns.csv', 'w', newline='', encoding='utf-8') as fout:
        
        reader = csv.DictReader(fin)
        writer = csv.DictWriter(fout, fieldnames=FIELDS)
        writer.writeheader()
        
        for row in reader:
            processed_count += 1
            
            # --- FALLBACK LOGIC ---
            sub_code = row.get('subdivision_code', '').strip()
            if not sub_code:
                country = row.get('Country', 'XX').strip()
                sub_code = f"{country}-XXX"
            
            # Name and Code generation
            name_en = row.get('NameWoDiacritics', '').strip()
            t_code = generate_town_code(name_en, existing_codes)
            existing_codes.append(t_code)
            
            # Construct town_unicode
            t_unicode = f"{sub_code}-{t_code}"
            
            writer.writerow({
                'subdivision_code': sub_code,
                'town_code': t_code,
                'town_unicode': t_unicode,
                'town_name_local': row.get('Name', ''),
                'town_name_en': name_en,
                'town_name_es': '',
                'town_name_fr': '',
                'town_population': 0,
                'town_last_census': '',
                'town_latitude': row.get('latitude', ''),
                'town_longitude': row.get('longitude', ''),
                'sustainable_living_index': 0.0,
                'status_flag': '',
                'isFieldChange': False,
                'remarks': ''
            })
            
            # --- PROGRESS DEBUGGING ---
            if processed_count % 100 == 0:
                print(f"✅ Processed {processed_count} rows... (Last code: {t_unicode})")

    print(f"🏁 Finished! Total towns processed: {processed_count}. File saved to {BASE_DIR}/towns.csv")

if __name__ == "__main__":
    transform()