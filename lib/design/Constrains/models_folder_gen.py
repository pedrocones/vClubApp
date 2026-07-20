import json
import os

def audit_folder_scaffolding():
    # 1. Define paths based on established project structure
    registry_path = 'lib/design/Datasets/firestore_registry.json'
    lib_base = 'lib/models'
    test_base = 'test/models'
    
    # 2. Safety check for the Source of Truth
    if not os.path.exists(registry_path):
        print(f"CRITICAL ERROR: Registry not found at {registry_path}")
        return

    try:
        with open(registry_path, 'r') as f:
            registry = json.load(f)

        schema = registry.get('schema', {})
        planned_paths = []

        print("🚀 Analyzing Registry for Scaffolding Audit...\n")

        # 3. Iterate through top-level collections (e.g., countries, members)
        for collection_name, config in schema.items():
            # Add top-level model and test paths
            planned_paths.append(f"{lib_base}/{collection_name}")
            planned_paths.append(f"{test_base}/{collection_name}")
            
            # 4. Detect nested sub-collections (e.g., members/vcoin_ledger)
            if 'subcollections' in config:
                for sub_name in config['subcollections'].keys():
                    planned_paths.append(f"{lib_base}/{collection_name}/{sub_name}")
                    planned_paths.append(f"{test_base}/{collection_name}/{sub_name}")

        # 5. Output audit results for review
        print("--- PLANNED DIRECTORY STRUCTURE (Python Audit) ---")
        # Use sorted set to remove duplicates and keep output clean
        for path in sorted(set(planned_paths)):
            print(f"  [ ] {path}")
            os.makedirs(f"{path}")

        print(f"\n✅ Audit complete. Total directories identified: {len(set(planned_paths))}")
        print("Review these paths. If correct, you can swap print() for os.makedirs() to commit.")

    except Exception as e:
        print(f"ERROR: Failed to parse registry JSON. Details: {e}")

if __name__ == "__main__":
    audit_folder_scaffolding()