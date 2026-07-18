import iso3166_2
import time

def inspect_metadata():
    # Instantiate the library
    try:
        subdivisions = iso3166_2.Subdivisions()
    except Exception as e:
        print(f"❌ Error instantiating iso3166_2: {e}")
        return

    print("🔍 Starting inspection of ISO metadata...")
    print("Format: Country | Code | Attributes found\n")

    counter = 0
    # Iterate through countries
    for country_code in subdivisions:
        country_subs = subdivisions[country_code]
        
        # Iterate through subdivisions for that country
        for sub_code, sub_info in country_subs.items():
            counter += 1
            
            # Print attributes found in the object
            # vars() returns the __dict__ of an object if it exists
            attrs = vars(sub_info) if hasattr(sub_info, '__dict__') else dir(sub_info)
            print(f"[{counter}] {country_code} | {sub_code} | Attributes: {attrs}")
            
            # Pause every 10 records
            if counter % 10 == 0:
                print("\n--- Pausing for 2 seconds (Press Ctrl+C to stop) ---\n")
                time.sleep(2)

    print("\n✅ Inspection complete.")

if __name__ == "__main__":
    inspect_metadata()