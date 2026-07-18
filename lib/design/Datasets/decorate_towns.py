import csv
from collections import defaultdict

BASE_PATH = "lib/design/Datasets"

def decorate_towns():
    input_file = f"{BASE_PATH}/towns.csv"
    output_file = f"{BASE_PATH}/towns_decorated.csv"

    # We store the current counter for every (subdivision + starting_letter)
    # Map structure: counter_map[(subdivision, first_letter)] = current_count
    counter_map = defaultdict(lambda: 0)

    # Read, process, and write
    with open(input_file, 'r', encoding='utf-8') as fin, \
         open(output_file, 'w', encoding='utf-8', newline='') as fout:
        
        reader = csv.DictReader(fin)
        fieldnames = reader.fieldnames
        writer = csv.DictWriter(fout, fieldnames=fieldnames)
        writer.writeheader()

        # Sort the rows first to ensure the counter increments alphabetically
        # Sort by subdivision_code, then town_name_en
        rows = sorted(list(reader), key=lambda x: (x['subdivision_code'], x['town_name_en']))

        for row in rows:
            sub = row['subdivision_code']
            name = row['town_name_en'].strip()
            
            if not name:
                continue
                
            first_letter = name[0].upper()
            key = (sub, first_letter)
            
            # Increment by 10 (as per your example: 0010, 0020)
            counter_map[key] += 10
            counter = counter_map[key]
            
            # Format: {subdivision}-{Letter}{4-digit-padded-counter}
            new_unicode = f"{sub}-{first_letter}{counter:04d}"
            
            row['town_unicode'] = new_unicode
            # Optional: update town_code if you want it to match
            row['town_code'] = f"{first_letter}{counter:04d}"
            
            writer.writerow(row)

    print(f"SUCCESS: Decorated file created at {output_file}")

if __name__ == "__main__":
    decorate_towns()