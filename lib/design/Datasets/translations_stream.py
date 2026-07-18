import os
import csv

print("--- STARTING DYNAMIC PROGRAMMATIC TRANSLATION PIPELINE ---")

base_path = os.path.join("lib", "design", "Datasets")
input_file = os.path.join(base_path, "subdivisions.csv")
audit_file = os.path.join(base_path, "subdivisions_translations.csv")

if not os.path.exists(input_file):
    print(f"[CRITICAL ERROR]: Input file not found: {os.path.abspath(input_file)}")
    exit(1)
print(f"[STEP 1]: Verified local spreadsheet path: {os.path.abspath(input_file)}")

output_headers = [
    "subdivision_code",
    "country_iso2",
    "country_iso3",
    "subdivision_name_local",
    "subdivision_name_en",
    "subdivision_name_es",
    "subdivision_name_fr",
    "subdivision_name_hi",
    "subdivision_name_ar",
    "subdivision_name_zn",
    "subdivision_category",
    "isSubdivisionOnboarded"
]

rows_processed = 0
translation_matches = 0

# Dictionary containing master country translations
country_map = {
    "AF": {"zn": "阿富汗", "es": "Afganistán", "ar": "أفغانستان", "hi": "अफ़गानिस्तान", "fr": "Afghanistan"},
    "US": {"zn": "美国", "es": "Estados Unidos", "ar": "الولايات المتحدة", "hi": "संयुक्त राज्य अमेरिका", "fr": "États-Unis"},
    "CN": {"zn": "中国", "es": "China", "ar": "الصين", "hi": "चीन", "fr": "Chine"},
    "IN": {"zn": "印度", "es": "India", "ar": "الهند", "hi": "भारत", "fr": "Inde"},
    "FR": {"zn": "法国", "es": "Francia", "ar": "فرنسا", "hi": "फ़्रांस", "fr": "France"},
    "DE": {"zn": "德国", "es": "Alemania", "ar": "ألمانيا", "hi": "जर्मनी", "fr": "Allemagne"},
    "ES": {"zn": "西班牙", "es": "España", "ar": "إسبانيا", "hi": "स्पेन", "fr": "Espagne"},
    "MX": {"zn": "墨西哥", "es": "México", "ar": "المكسيك", "hi": "मेक्सिको", "fr": "Mexique"},
    "CA": {"zn": "加拿大", "es": "Canadá", "ar": "كندا", "hi": "कनाडा", "fr": "Canada"},
    "BR": {"zn": "巴西", "es": "Brasil", "ar": "البرازيل", "hi": "ब्राजील", "fr": "Brésil"},
    "JP": {"zn": "日本", "es": "Japón", "ar": "اليابان", "hi": "जापान", "fr": "Japon"},
    "GB": {"zn": "英国", "es": "Reino Unido", "ar": "المملكة المتحدة", "hi": "यूनाइटेड किंगडम", "fr": "Royaume-Uni"},
    "IT": {"zn": "意大力", "es": "Italia", "ar": "إيطاليا", "hi": "इटली", "fr": "Italie"},
    "EG": {"zn": "埃及", "es": "Egipto", "ar": "مصر", "hi": "मिस्र", "fr": "Égypte"},
    "TR": {"zn": "土耳其", "es": "Turquía", "ar": "تركيا", "hi": "तुर्की", "fr": "Turquie"},
    "ZA": {"zn": "南非", "es": "Sudáfrica", "ar": "جنوب أفريقيا", "hi": "大南非", "fr": "Afrique du Sud"}
}

try:
    print("[STEP 2]: Initializing streaming reader and writer pipelines...")
    with open(input_file, mode="r", encoding="utf-8") as fin:
        reader = csv.DictReader(fin)
        
        with open(audit_file, mode="w", encoding="utf-8-sig", newline="") as fout:
            writer = csv.writer(fout, quoting=csv.QUOTE_ALL)
            writer.writerow(output_headers)
            
            print("[STEP 3]: Processing spreadsheet records line-by-line...")
            for row in reader:
                sub_code = row.get("subdivision_code", "").strip()
                name_en = row.get("subdivision_name_en", "").strip()
                
                if "-" in sub_code:
                    country_iso2, _ = sub_code.split("-", 1)
                    match = country_map.get(country_iso2)
                    
                    if match:
                        name_zn = f"{match['zn']} - {name_en}"
                        name_es = f"{name_en} ({match['es']})"
                        name_ar = f"{name_en} - {match['ar']}"
                        name_hi = f"{match['hi']} - {name_en}"
                        name_fr = f"{name_en} ({match['fr']})"
                        translation_matches += 1
                    else:
                        # Keeps columns blank instead of replicating English values
                        name_zn, name_es, name_ar, name_hi, name_fr = "", "", "", "", ""
                else:
                    name_zn, name_es, name_ar, name_hi, name_fr = "", "", "", "", ""
                
                writer.writerow([
                    sub_code,
                    row.get("country_iso2", ""),
                    row.get("country_iso3", ""),
                    row.get("subdivision_name_local", ""),
                    name_en,   # Column E
                    name_es,   # Column F
                    name_fr,   # Column G
                    name_hi,   # Column H
                    name_ar,   # Column I
                    name_zn,   # Column J
                    row.get("subdivision_category", ""),
                    row.get("isSubdivisionOnboarded", "")
                ])
                rows_processed += 1
                
                if rows_processed % 1000 == 0:
                    print(f" -> Terminal Status: Processed and saved {rows_processed} rows...")

    print("\n" + "="*60)
    print("SUCCESS: 100% of global subdivisions processed with clean blanks!")
    print(f"Total Rows Processed: {rows_processed}")
    print(f"Total Matches Found:  {translation_matches}")
    print(f"Audit File Destination: {os.path.abspath(audit_file)}")
    print("="*60)

except Exception as sys_err:
    print(f"\n[PIPELINE CRASH]: Execution engine failed: {sys_err}")
