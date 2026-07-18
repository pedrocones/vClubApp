import csv
import os
import iso3166_2

def enrich_iso_csv(file_path):
    if not os.path.exists(file_path):
        print(f"❌ Error: File not found at '{file_path}'")
        return

    iso_db = iso3166_2.Subdivisions()
    temp_file = "ISO3166_enriched.tmp"
    
    headers = [
        "country_code", "subdivision_name", "code", "subdivision_category", 
        "alternative_names", "flag_url"
    ]
    
    print("⏳ Final Enrichment: Mapping all attributes directly...")
    
    with open(file_path, mode='r', encoding='utf-8') as infile, \
         open(temp_file, mode='w', encoding='utf-8', newline='') as outfile:
         
        reader = csv.DictReader(infile)
        writer = csv.DictWriter(outfile, fieldnames=headers)
        writer.writeheader()
        
        for row in reader:
            country = row.get('country_code', '').strip().upper()
            code = row.get('code', '').strip().upper()
            
            alt_names = ""
            flag_url = f"https://flagcdn.com/w80/{country.lower()}.png"
            category = row.get('subdivision_category', 'Subdivision')
            
            if country and code:
                try:
                    sub_info = iso_db[country][code]
                    if sub_info:
                        # 🔍 Detects if the attribute is a single string or a list/complex object
                        # We try to extract from 'alt_names', 'aliases', or 'other_names'
                        raw_data = getattr(sub_info, 'alt_names', getattr(sub_info, 'aliases', getattr(sub_info, 'other_names', '')))
                        
                        if isinstance(raw_data, (list, tuple)):
                            alt_names = "; ".join([str(n) for n in raw_data if n])
                        else:
                            alt_names = str(raw_data)
                            
                        category = getattr(sub_info, 'type', category).title()
                except Exception:
                    pass
            
            writer.writerow({
                "country_code": country,
                "subdivision_name": row.get('subdivision_name', ''),
                "code": code,
                "subdivision_category": category,
                "alternative_names": alt_names,
                "flag_url": flag_url
            })

    os.replace(temp_file, file_path)
    print(f"✅ Master file '{file_path}' is now fully populated.")

if __name__ == "__main__":
    target_file = os.path.join("lib", "design", "Datasets", "ISO3166.csv")
    enrich_iso_csv(target_file)