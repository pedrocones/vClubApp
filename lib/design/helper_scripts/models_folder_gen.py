import json
import os

def scaffold_with_existence_check():
    # 1. Define paths based on your established structure
    registry_path = 'lib/design/Datasets/firestore_registry.json'
    lib_base = 'lib/models'
    test_base = 'test/models'
    
    if not os.path.exists(registry_path):
        print(f"❌ Error: Registry not found at {registry_path}")
        return

    try:
        with open(registry_path, 'r') as f:
            registry = json.load(f)

        schema = registry.get('schema', {})
        
        print("🚀 Starting Directory Scaffolding...")
        print(f"Source: {registry_path}\n")

        # 2. Iterate through top-level collections (shadow_checks, countries, members, etc.)
        for collection_name, config in schema.items():
            
            # Paths to check
            paths_to_verify = [
                f"{lib_base}/{collection_name}",
                f"{test_base}/{collection_name}"
            ]
            
            # 3. Add nested sub-collections (e.g., members/vcoin_ledger, members/bank_accounts)
            if 'subcollections' in config:
                for sub_name in config['subcollections'].keys():
                    paths_to_verify.append(f"{lib_base}/{collection_name}/{sub_name}")
                    paths_to_verify.append(f"{test_base}/{collection_name}/{sub_name}")

            # 4. Execute the "Generate if missing, skip if present" logic
            for path in paths_to_verify:
                if os.path.exists(path):
                    print(f"  [SKIP] Exists: {path}")
                else:
                    os.makedirs(path, exist_ok=True)
                    print(f"  [GEN ] Created: {path}")

        print("\n✅ Scaffolding check complete.")

    except Exception as e:
        print(f"❌ Failed to parse registry: {e}")

if __name__ == "__main__":
    scaffold_with_existence_check()