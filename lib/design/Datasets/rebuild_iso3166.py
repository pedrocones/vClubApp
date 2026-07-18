import csv
import iso3166_2
import os

def rebuild_master_iso3166():
    output_path = os.path.join("lib", "design", "Datasets", "ISO3166.csv")
    
    # Instantiate the library
    subdivisions = iso3166_2.Subdivisions()
    headers = ["country_code", "subdivision_name", "code", "subdivision_category"]
    
    print(f"🌍 Rebuilding master file: {output_path}")
    
    try:
        with open(output_path, mode='w', encoding='utf-8', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=headers)
            writer.writeheader()
            
            count = 0
            # FIX: Iterate directly over the library object (subdivisions)
            # Depending on the library version, iterating over it yields the country code
            for country_code in subdivisions:
                # Access the subdivisions for this specific country
                country_subs = subdivisions[country_code]
                
                # Iterate through the dictionary of subdivisions for that country
                for sub_code, sub_info in country_subs.items():
                    writer.writerow({
                        "country_code": country_code,
                        "subdivision_name": sub_info.get('name', 'Unknown'),
                        "code": sub_code, 
                        "subdivision_category": sub_info.get('type', 'Subdivision').title()
                    })
                    count += 1
        print(f"✅ Success! Created '{output_path}' with {count} official entries.")
    except PermissionError:
        print(f"❌ ERROR: File '{output_path}' is locked by another program (e.g., Excel). Please close it.")
    except Exception as e:
        print(f"❌ An unexpected error occurred: {e}")

if __name__ == "__main__":
    rebuild_master_iso3166()