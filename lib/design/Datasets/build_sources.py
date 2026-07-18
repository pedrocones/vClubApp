import pycountry
import csv
import os
from unidecode import unidecode

BASE_DIR = "lib/design/Datasets"

def build_all_sources():
    if not os.path.exists(BASE_DIR):
        os.makedirs(BASE_DIR)

    # Helper: Decorator logic (only if _en is missing, generate ASCII from local)
    def get_en_name(local_name, existing_en=None):
        if existing_en and existing_en.strip():
            return existing_en
        return unidecode(local_name)

    # 1. Generate countries.csv
    with open(f'{BASE_DIR}/countries.csv', 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['country_iso2', 'country_iso3', 'country_name_en', 'country_name_local', 'isCountryOnboarded'])
        for c in pycountry.countries:
            # name_local = audited library name
            # name_en = generated via decorator to ensure no blanks
            writer.writerow([c.alpha_2, c.alpha_3, get_en_name(c.name), c.name, False])

    # 2. Generate subdivisions.csv
    with open(f'{BASE_DIR}/subdivisions.csv', 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['subdivision_code', 'country_iso2', 'subdivision_name_en', 'subdivision_name_local', 'subdivision_category', 'isSubdivisionOnboarded'])
        
        for country in pycountry.countries:
            try:
                subs = pycountry.subdivisions.get(country_code=country.alpha_2)
                for sub in subs:
                    # name_local = audited library name
                    # name_en = decorated via unidecode to guarantee sortable/searchable key
                    writer.writerow([
                        sub.code, 
                        country.alpha_2, 
                        get_en_name(sub.name), 
                        sub.name, 
                        sub.type, 
                        False
                    ])
            except Exception:
                continue

    print(f"✅ Audit-ready sources generated in '{BASE_DIR}/' with automatic ASCII decoration for search.")

if __name__ == "__main__":
    build_all_sources()