import json
import os
import re

# Configuration based on your registry and folder structure sources
REGISTRY_PATH = 'lib/design/Datasets/firestore_registry.json'
MODELS_BASE = 'lib/models'

def to_pascal_case(snake_str):
    return "".join(x.capitalize() for x in snake_str.split('_'))

def get_dart_type(field_name, info):
    """
    Determines Dart type. Strictly follows the 'nullable' attribute from Registry v2.
    If 'nullable' is omitted, it defaults to the inverse of 'required'.
    """
    r_type = info.get('type')
    # Sound Null Safety Logic: Default to non-nullable only if explicitly required
    is_nullable = info.get('nullable', not info.get('required', False))
    null_suffix = "?" if is_nullable else ""
    
    if info.get('options'):
        return f"{to_pascal_case(field_name)}{null_suffix}"
    
    type_map = {
        "string": "String", "int": "int", "double": "double",
        "boolean": "bool", "timestamp": "DateTime", "map": "Map<String, dynamic>",
        "List": "String" 
    }
    base_type = type_map.get(r_type, "dynamic")
    return f"{base_type}{null_suffix}" if base_type != "dynamic" else "dynamic"

def get_nested_default_literal(nested_fields):
    """Builds a Dart map literal from registry defaults for maps like reward_tree."""
    entries = []
    for f_name, f_info in nested_fields.items():
        d_val = f_info.get('default')
        f_type = f_info.get('type')
        if d_val is not None:
            if f_type == 'string': entries.append(f"'{f_name}': '{d_val}'")
            elif f_type == 'boolean': entries.append(f"'{f_name}': {str(d_val).lower()}")
            else: entries.append(f"'{f_name}': {d_val}")
    return "{" + ", ".join(entries) + "}"

def generate_blocks(class_name, fields):
    print(f"    ├─ 🧩 Fixing Null Safety for {class_name}...")
    f_lines, c_lines, fact_lines = ["  // <REGISTRY_FIELDS_START>"], ["    // <REGISTRY_CONSTRUCTOR_START>"], ["    // <REGISTRY_FACTORY_START>"]

    for f_name, f_info in fields.items():
        # ARCHITECTURAL FIX: Any non-nullable field MUST be 'required' in the constructor [User Query]
        is_nullable = f_info.get('nullable', not f_info.get('required', False))
        d_type = get_dart_type(f_name, f_info)
        
        f_lines.append(f"  final {d_type} {f_name};")
        
        # If the type is non-nullable (no '?'), we MUST add 'required' keyword
        req_keyword = "required " if not is_nullable else ""
        c_lines.append(f"    {req_keyword}this.{f_name},")
        
        f_type, d_val = f_info.get('type'), f_info.get('default')
        
        # Factory Logic: Strict casting to avoid 'silent' errors [User Query]

    # FACTORY LOGIC: Strict Enum Handling
        if f_info.get('options'):
            enum_name = to_pascal_case(f_name)
            d_val = f_info.get('default') # Check for Registry Default
            
            if d_val:
                # 1. Default-Aware: Use registry default as fallback (e.g., MemberStatus.rookie)
                fb = f"{enum_name}.{str(d_val).lower()}"
                val = f"{enum_name}.values.firstWhere((e) => e.name == json['{f_name}'].toString().toLowerCase(), orElse: () => {fb})"
            elif not is_nullable:
                # 2. STRICT: No default in registry. Throws StateError if value is invalid.
                # This fixes the 'TransactionType.rookie' error [User Query]
                val = f"{enum_name}.values.firstWhere((e) => e.name == json['{f_name}'].toString().toLowerCase())"
            else:
                # 3. Nullable: Return null if the value is missing or invalid
                val = f"json['{f_name}'] != null ? {enum_name}.values.firstWhere((e) => e.name == json['{f_name}'].toString().toLowerCase(), orElse: () => null) : null"

        elif f_type == 'map':
            nested_fields = f_info.get('fields', {})
            default_map = get_nested_default_literal(nested_fields)
            if not is_nullable:
                val = f"(json['{f_name}'] as Map<String, dynamic>?) ?? {default_map}"
            else:
                val = f"json['{f_name}'] as Map<String, dynamic>?"

        elif f_type == 'timestamp':
            val = f"(json['{f_name}'] as Timestamp).toDate()" if not is_nullable else f"json['{f_name}'] != null ? (json['{f_name}'] as Timestamp).toDate() : null"
        
        elif f_type == 'double':
            val = f"(json['{f_name}'] as num).toDouble()" if not is_nullable else f"(json['{f_name}'] as num?)?.toDouble()"
            
        elif f_type == 'int':
            val = f"json['{f_name}'] as int" if not is_nullable else f"json['{f_name}'] as int?"
            
        elif f_type == 'boolean':
            if not is_nullable:
                val = f"json['{f_name}'] as bool" if d_val is None else f"json['{f_name}'] as bool? ?? {str(d_val).lower()}"
            else:
                val = f"json['{f_name}'] as bool?"
            
        else: # Strings
            if not is_nullable:
                val = f"json['{f_name}'] as String" if d_val is None else f"json['{f_name}']?.toString() ?? '{d_val}'"
            else:
                val = f"json['{f_name}'] as String?"
        
        fact_lines.append(f"      {f_name}: {val},")

    return "\n".join(f_lines + ["  // <REGISTRY_FIELDS_END>"]), \
           "\n".join(c_lines + ["    // <REGISTRY_CONSTRUCTOR_END>"]), \
           "\n".join(fact_lines + ["    // <REGISTRY_FACTORY_END>"])

def sync_models():
    print("\n🚀 VICINUM CONSTRUCTOR FIX SYNC START")
    if not os.path.exists(REGISTRY_PATH): return
    with open(REGISTRY_PATH, 'r') as f: registry = json.load(f)
    schema = registry.get('schema', {})

    for coll, config in schema.items():
        process_unit(coll, config)
        if 'subcollections' in config:
            for sub_coll, sub_config in config['subcollections'].items():
                process_unit(sub_coll, sub_config, parent=coll)
    print("\n🏁 SYNC FINISHED")

def process_unit(name, config, parent=None):
    fields, class_name = config.get('fields', config), to_pascal_case(name).rstrip('s') + "Model"
    folder_path = os.path.join(MODELS_BASE, parent, name) if parent else os.path.join(MODELS_BASE, name)
    file_path = os.path.join(folder_path, f"{name.rstrip('s')}_model.dart")

    # Enums
    enum_code = "// <REGISTRY_ENUMS_START>\n"
    for f_name, f_info in fields.items():
        if f_info.get('options'):
            enum_name = to_pascal_case(f_name)
            opts = [o.strip() for o in f_info['options'].split(',')]
            enum_code += f"enum {enum_name} {{ " + ", ".join([o.lower().replace(" ", "") for o in opts]) + " }\n"
    enum_code += "// <REGISTRY_ENUMS_END>"
    
    f_b, c_b, fact_b = generate_blocks(class_name, fields)

    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as f: content = f.read()
        content = re.sub(r"// <REGISTRY_ENUMS_START>.*?// <REGISTRY_ENUMS_END>", enum_code, content, flags=re.DOTALL)
        content = re.sub(r"  // <REGISTRY_FIELDS_START>.*?  // <REGISTRY_FIELDS_END>", f_b, content, flags=re.DOTALL)
        content = re.sub(r"    // <REGISTRY_CONSTRUCTOR_START>.*?    // <REGISTRY_CONSTRUCTOR_END>", c_b, content, flags=re.DOTALL)
        content = re.sub(r"    // <REGISTRY_FACTORY_START>.*?    // <REGISTRY_FACTORY_END>", fact_b, content, flags=re.DOTALL)
        with open(file_path, 'w', encoding='utf-8') as f: f.write(content)
    else:
        os.makedirs(folder_path, exist_ok=True)
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(f"import 'package:cloud_firestore/cloud_firestore.dart';\n\n{enum_code}\n\nclass {class_name} {{\n{f_b}\n\n  {class_name}({{\n{c_b}\n  }});\n\n  factory {class_name}.fromJson(Map<String, dynamic> json) => {class_name}(\n{fact_b}\n  );\n}}")

if __name__ == "__main__":
    sync_models()