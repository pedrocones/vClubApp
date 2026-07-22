import os
import json
import firebase_admin
import google.auth.credentials  # Required for anonymous auth
from firebase_admin import firestore

def seed_firestore_mockups():
    # 1. Force the environment to use the local Emulator per your Registry [1]
    os.environ["FIRESTORE_EMULATOR_HOST"] = "localhost:8080"
    os.environ["GCLOUD_PROJECT"] = "demo-vicinum-project"

    # 2. Initialize with Anonymous Credentials to bypass PEM validation
    if not firebase_admin._apps:
        # This bypasses the need for a service account JSON or dummy PEM key
        cred = google.auth.credentials.AnonymousCredentials()
        firebase_admin.initialize_app(cred, {
            'projectId': 'demo-vicinum-project',
        })

    db = firestore.client()
    
    # ... rest of your parsing logic remains the same ...

    print("✅ Connected to Firestore Emulator successfully.")


    with open('lib/design/Datasets/firestore_registry.json', 'r') as f:
        registry = json.load(f)
    
    schema = registry['schema']

    def build_mock_data(fields_config):
        data = {}
        for name, info in fields_config.items():
            # Handle nested maps (reward_tree, member_profile) [3, 4]
            if info['type'] == 'map' and 'fields' in info:
                data[name] = build_mock_data(info['fields'])
                continue
            
            # Prioritize Mockup Value -> Default Value -> Type Zero-Value
            val = info.get('mockup_value', info.get('default'))
            if val is None and info.get('required'):
                zeros = {"string": "placeholder", "int": 0, "double": 0.0, "boolean": False, "timestamp": firestore.SERVER_TIMESTAMP}
                val = zeros.get(info['type'])
            
            if val is not None:
                data[name] = val
        return data

    # Populate shadow_checks and members
    for coll in ['shadow_checks', 'members']:
        config = schema[coll]
        fields = config.get('fields', config)
        mock_record = build_mock_data(fields)
        
        # Use primary_key for the document ID if available [3]
        doc_id = mock_record.get(config.get('primary_key', 'mock_id'), 'mock_id')
        db.collection(coll).document(str(doc_id)).set(mock_record)
        print(f"🚀 Seeded {coll} with ID: {doc_id}")

if __name__ == "__main__":
    seed_firestore_mockups()