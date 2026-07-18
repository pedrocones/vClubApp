import csv

BASE_PATH = "lib/design/Datasets"

def decorate_subdivisions():
    translations = {}
    
    # 1. Load translations (using utf-8-sig to handle BOM, delimiter=',' based on your trace)
    with open(f"{BASE_PATH}/subdivisions_translations_partial.csv", 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f, delimiter=',')
        for row in reader:
            code = row['subdivision_code']
            translations[code] = {
                'zn': row['translation_name_zn'],
                'es': row['translation_name_es'],
                'ar': row['translation_name_ar'],
                'hi': row['translation_name_hi'],
                'fr': row['translation_name_fr']
            }

    # 2. Decorate subdivisions.csv
    input_file = f"{BASE_PATH}/subdivisions.csv"
    output_file = f"{BASE_PATH}/subdivisions_decorated.csv"

    fieldnames = [
        'subdivision_code', 'country_iso2', 'country_iso3', 'subdivision_name_local', 
        'subdivision_name_en', 'subdivision_name_es', 'subdivision_name_fr', 
        'subdivision_name_hi', 'subdivision_name_ar', 'subdivision_name_zn', 
        'subdivision_category', 'isSubdivisionOnboarded'
    ]

    with open(input_file, 'r', encoding='utf-8') as fin, \
         open(output_file, 'w', encoding='utf-8', newline='') as fout:
        
        reader = csv.DictReader(fin)
        writer = csv.DictWriter(fout, fieldnames=fieldnames)
        writer.writeheader()

        for row in reader:
            code = row['subdivision_code']
            trans = translations.get(code, {})
            
            # Apply translations
            row['subdivision_name_es'] = trans.get('es') or row.get('subdivision_name_es') or ''
            row['subdivision_name_fr'] = trans.get('fr') or row.get('subdivision_name_fr') or ''
            row['subdivision_name_hi'] = trans.get('hi') or row.get('subdivision_name_hi') or ''
            row['subdivision_name_ar'] = trans.get('ar') or row.get('subdivision_name_ar') or ''
            row['subdivision_name_zn'] = trans.get('zn') or row.get('subdivision_name_zn') or ''
            
            # Write only schema fields
            writer.writerow({k: row.get(k, '') for k in fieldnames})

    print(f"SUCCESS: 'subdivisions_decorated.csv' created.")

if __name__ == "__main__":
    decorate_subdivisions()