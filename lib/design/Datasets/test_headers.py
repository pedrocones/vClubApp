import csv
with open('lib/design/Datasets/subdivisions_translations_partial.csv', 'r', encoding='utf-8') as f:
    reader = csv.reader(f)
    print(next(reader)) # This will print the first row (the headers)
