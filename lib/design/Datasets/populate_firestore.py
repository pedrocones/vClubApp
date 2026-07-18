import os
import csv
import firebase_admin
from firebase_admin import firestore
from google.auth.credentials import AnonymousCredentials

# Setup
os.environ["FIRESTORE_EMULATOR_HOST"] = "localhost:8080"
BASE_PATH = "lib/design/Datasets"

# Initialize
firebase_admin.initialize_app(AnonymousCredentials(), options={'projectId': 'demo-vicinum-project'})
db = firestore.client()

def is_onboarded(row, key):
    """Case-insensitive onboarding check."""
    return row.get(key, '').strip().lower() == 'true'

def populate_firestore():
    print("DEBUG: Starting population...")

    # Pass 1: Countries
    with open(f"{BASE_PATH}/countries.csv", 'r', encoding='utf-8') as f:
        for row in csv.DictReader(f):
            if is_onboarded(row, 'isCountryOnboarded'):
                clean_row = {k: v for k, v in row.items() if k and k.strip()}
                db.collection('countries').document(row['country_iso3']).set(clean_row)
                print(f"DEBUG: Country {row['country_iso3']} written.")

    # Pass 2: Subdivisions & Build Map
    sub_to_iso3 = {}
    with open(f"{BASE_PATH}/subdivisions.csv", 'r', encoding='utf-8') as f:
        for row in csv.DictReader(f):
            if is_onboarded(row, 'isSubdivisionOnboarded'):
                clean_row = {k: v for k, v in row.items() if k and k.strip()}
                sub_to_iso3[row['subdivision_code']] = row['country_iso3']
                db.collection('countries').document(row['country_iso3'])\
                  .collection('subdivisions').document(row['subdivision_code']).set(clean_row)
                print(f"DEBUG: Subdivision {row['subdivision_code']} written.")

    # Pass 3: Towns (Filtering excluded -XXX- towns)
    with open(f"{BASE_PATH}/towns.csv", 'r', encoding='utf-8') as f:
        for row in csv.DictReader(f):
            sub_code = row.get('subdivision_code', '').strip()
            unicode = row.get('town_unicode', '').strip()
            
            # Filter-in logic: exclude if contains -XXX-
            if "-XXX-" in unicode:
                continue
            
            # Map lookup ensures we only write towns whose subdivision was onboarded
            parent_iso3 = sub_to_iso3.get(sub_code)
            if parent_iso3:
                clean_row = {k: v for k, v in row.items() if k and k.strip()}
                db.collection('countries').document(parent_iso3)\
                  .collection('subdivisions').document(sub_code)\
                  .collection('towns').document(unicode).set(clean_row)
                print(f"DEBUG: Town {unicode} written.")

if __name__ == "__main__":
    populate_firestore()
    print("DEBUG: Ingestion finished.")