import pycountry
import iso3166
from pprint import pprint

def explore():
    print("--- 1. Testing PyCountry ---")
    # ISO 3166-1 (Country)
    us = pycountry.countries.get(alpha_2='US')
    print(f"PyCountry Country Attributes: {dir(us)}\n\n")
    print(f"US: name = local {us.name}\n")
    print(f"US: official {us.official_name}\n")

    # ISO 3166-2 (Subdivision)
    us_ca = pycountry.subdivisions.get(code='US-CA')
    if us_ca:
        print(f"PyCountry Subdivision Attributes: {dir(us_ca)}\n\n")
        print(f"US-CA Name: {us_ca.name}")
        print(f"US-CA Type: {us_ca.type}")
    else:
        print("US-CA not found in PyCountry.")

    print("\n--- 2. Testing ISO3166 Library ---")
    # ISO 3166-1
    from iso3166 import countries_by_alpha2
    us_iso = countries_by_alpha2.get('US')
    print(f"ISO3166 Country Attributes: {dir(us_iso)}")
    print(f"US: {us_iso.name}")

if __name__ == "__main__":
    explore()