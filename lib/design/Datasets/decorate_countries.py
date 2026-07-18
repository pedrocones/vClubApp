import csv

BASE_PATH = "lib/design/Datasets"

def decorate_countries():
    # 1. Load translations into a map keyed by iso2
    translations = {}
    with open(f"{BASE_PATH}/country_translations.csv", 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Map iso2 to the translation fields
            translations[row['iso2']] = {
                'es': row['translation_es'],
                'fr': row['translation_fr'],
                'hi': row['translation_hi'],
                'ar': row['translation_ar'],
                'zn': row['translation_zn']
            }

    # 2. Open source countries and write decorated output
    with open(f"{BASE_PATH}/countries.csv", 'r', encoding='utf-8') as fin, \
         open(f"{BASE_PATH}/countries_decorated.csv", 'w', encoding='utf-8', newline='') as fout:
        
        reader = csv.DictReader(fin)
        
        # Define fields per your updated schema contract
        fieldnames = [
            'country_iso2', 'country_iso3', 'country_name_local', 'country_name_en',
            'country_name_es', 'country_name_fr', 'country_name_hi', 
            'country_name_ar', 'country_name_zn', 'isCountryOnboarded'
        ]
        
        writer = csv.DictWriter(fout, fieldnames=fieldnames)
        writer.writeheader()

        for row in reader:
            iso2 = row['country_iso2']
            trans = translations.get(iso2, {})
            
            # Populate the row with new values
            row['country_name_es'] = trans.get('es', row.get('country_name_es', ''))
            row['country_name_fr'] = trans.get('fr', row.get('country_name_fr', ''))
            row['country_name_hi'] = trans.get('hi', '')
            row['country_name_ar'] = trans.get('ar', '')
            row['country_name_zn'] = trans.get('zn', '')
            
            writer.writerow(row)

    print("SUCCESS: 'countries_decorated.csv' created.")

if __name__ == "__main__":
    decorate_countries()