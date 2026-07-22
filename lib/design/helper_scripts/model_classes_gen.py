import json
import os

def generate_dart_classes():
    registry_path = 'lib/design/Datasets/firestore_registry.json'
    with open(registry_path, 'r') as f:
        registry = json.load(f)
    
    schema = registry['schema']
    targets = {
        "shadow_checks": "lib/models/shadow_checks/shadow_check_model.dart",
        "members": "lib/models/members/member_model.dart"
    }

    type_map = {"string": "String", "boolean": "bool", "int": "int", "double": "double", "timestamp": "DateTime", "map": "Map<String, dynamic>"}

    for key in targets:
        fields = schema[key].get('fields', schema[key])
        class_name = "".join(x.capitalize() for x in key.split('_'))[:-1] + "Model" if key.endswith('s') else "".join(x.capitalize() for x in key.split('_')) + "Model"
        
        lines = [f"class {class_name} {{"]
        
        # Build Fields
        for f_name, f_info in fields.items():
            d_type = type_map.get(f_info['type'], "dynamic")
            lines.append(f"  final {d_type} {f_name};")
        
        # Build Constructor
        lines.append(f"\n  {class_name}({{")
        for f_name, f_info in fields.items():
            req = "required " if f_info.get('required') else ""
            lines.append(f"    {req}this.{f_name},")
        lines.append("  });")

        # Build fromJson Factory
        lines.append(f"\n  factory {class_name}.fromJson(Map<String, dynamic> json) => {class_name}(")
        for f_name, f_info in fields.items():
            val = f"json['{f_name}']"
            if f_info['type'] == 'timestamp':
                val = f"(json['{f_name}'] as Timestamp).toDate()"
            lines.append(f"    {f_name}: {val},")
        lines.append("  );")
        lines.append("}")

        os.makedirs(os.path.dirname(targets[key]), exist_ok=True)
        with open(targets[key], 'w') as f:
            f.write("\n".join(lines))
        print(f"✅ Generated: {targets[key]}")

if __name__ == "__main__":
    generate_dart_classes()