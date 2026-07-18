import os
import csv
from google.cloud import firestore
from google.auth.credentials import AnonymousCredentials

#emulators should be runnig as firebase emulators:start --project demo-vicinumclub

# 1. Route network requests exclusively to your local machine loopback port
os.environ["FIRESTORE_EMULATOR_HOST"] = "127.0.0.1:8080"

# 2. Assign matching system variables to override potential terminal defaults
os.environ["GOOGLE_CLOUD_PROJECT"] = "demo-vicinumclub"

# 3. Instantiate the isolated local client

TARGET_PROJECT = "demo-vicinumclub"
TARGET_DATABASE = "(default)"    

db = firestore.Client(
    project=TARGET_PROJECT,
    database=TARGET_DATABASE,
    credentials=AnonymousCredentials()
)

#print(f"🛡️ Safe Sandbox Pipeline Engaged -> Project: {db.project} | Database: {db.database}")

print(f"📡 Script targeted cleanly to project: '{TARGET_PROJECT}' database instance: '{TARGET_DATABASE}'")

# Dictionary mapping to dynamically populate translations at the Country layer
COUNTRY_NAMES_MAP = {
    "US": {"en": "United States", "es": "Estados Unidos", "fr": "États-Unis"},
    "MX": {"en": "Mexico", "es": "México", "fr": "Mexique"},
    "VE": {"en": "Venezuela", "es": "Venezuela", "fr": "Venezuela"},
}

def seed_subcollection_drilldown_tree(csv_file_path):
    print("🚀 Initializing Extended Country Hierarchy Drill-Down Pipeline...")
    
    written_countries = set()
    written_states = set()
    
    towns_written = 0
    skipped_records = 0
    
    batch = db.batch()
    batch_counter = 0

    with open(csv_file_path, mode='r', encoding='utf-8-sig') as file:
        reader = csv.DictReader(file)
        
        for row in reader:
            country = (row.get('Country') or '').strip().upper()
            subdivision = (row.get('Subdivision') or '').strip().upper()

            # 🛠️ EXTENDED FILTER: Allow US (CA/FL), MX (All), and VE (All)
            is_valid_us = (country == 'US' and subdivision in ['CA', 'FL'])
            is_valid_intl = (country in ['MX', 'VE'])
            
            if not (is_valid_us or is_valid_intl):
                skipped_records += 1
                continue

            location_code = (row.get('Location') or '').strip().upper()
            if not location_code:
                continue

            # --- 🌍 LEVEL 3: COUNTRY DOCUMENT (EXPLICIT WRITE) ---
            if country not in written_countries:
                names = COUNTRY_NAMES_MAP.get(country, {"en": country, "es": country, "fr": ""})
                country_doc = {
                    "countryCode": country,
                    "nameEn": names["en"],
                    "translations": {
                        "es": names["es"],
                        "fr": names["fr"]
                    },
                    "lastUpdated": firestore.SERVER_TIMESTAMP
                }
                db.collection("un_locodes").document(country).set(country_doc, merge=True)
                written_countries.add(country)

            # --- 🏛️ LEVEL 2: STATE SUB-COLLECTION DOCUMENT (EXPLICIT WRITE) ---
            state_id = subdivision if subdivision else "UNASSIGNED"
            state_composite_track = f"{country}_{state_id}"
            
            if state_composite_track not in written_states:
                state_doc = {
                    "stateCode": state_id,
                    "nameEn": f"Region {state_id}" if country != 'US' else f"State of {state_id}",
                    "translations": {
                        "es": f"Región {state_id}" if country != 'US' else f"Estado de {state_id}",
                        "fr": f"Région {state_id}"
                    },
                    "lastUpdated": firestore.SERVER_TIMESTAMP
                }
                db.collection("un_locodes").document(country).collection("states").document(state_id).set(state_doc, merge=True)
                written_states.add(state_composite_track)

            # --- 🏙️ LEVEL 1: TOWN SUB-COLLECTION DOCUMENT (BATCHED) ---
            town_id = location_code
            change_indicator = (row.get('Ch') or '').strip()
            status = (row.get('Status') or '').strip()
            
            town_doc = {
                "unLocodeKey": f"{country}{state_id}{location_code}",
                "locationCode": location_code,
                "nameNative": (row.get('Name') or '').strip(),
                "nameEn": (row.get('NameWoDiacritics') or '').strip(),
                "functions": [char for char in (row.get('Function') or '').strip() if char.isdigit()],
                "status": status,
                "unCodeDate": (row.get('Date') or '').strip(),
                "iataCode": (row.get('IATA') or '').strip(),
                "rawCoordinates": (row.get('Coordinates') or '').strip(),
                "nativeChangeIndicator": change_indicator,
                "isRecordChanged": change_indicator in ['+', '#', 'X', '¦'],
                "isActive": change_indicator != 'X',
                "population": 0,
                "lastCensus": None,
                "translations": {
                    "es": "",  # To be dynamically augmented as needed
                    "fr": ""
                },
                "lastImportedAt": firestore.SERVER_TIMESTAMP
            }

            town_ref = db.collection("un_locodes").document(country)\
                         .collection("states").document(state_id)\
                         .collection("towns").document(town_id)
                         
            batch.set(town_ref, town_doc, merge=True)
            batch_counter += 1
            towns_written += 1

            if batch_counter >= 400:
                batch.commit()
                print(f"📦 Committed tree batch layer. Total entries stored: {towns_written}")
                batch = db.batch()
                batch_counter = 0

        if batch_counter > 0:
            batch.commit()
            print(f"📦 Final tree chunk committed.")

    print(f"\n✅ Extended Sandbox Drill-Down Seeding Complete!")
    print(f"🏙️ Total entries populated (US + MX + VE): {towns_written}")
    print(f"❌ Rows skipped outside targeted bounds: {skipped_records}")

if __name__ == "__main__":
    CSV_NAME = "lib/design/code-list.csv" 
    if os.path.exists(CSV_NAME):
        seed_subcollection_drilldown_tree(CSV_NAME)
    else:
        print(f"❌ Error: Cannot locate dataset file '{CSV_NAME}' in current execution path.")