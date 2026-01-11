import json
import csv

# load json file
with open("municities.json", "r", encoding="utf-8") as f:
    data = json.load(f)

rows = []

# traverse through the nested structure
for region, provinces in data.items():
    if isinstance(provinces, dict):
        for province in provinces.keys():
            rows.append({
                "region": region,
                "province": province
            })          


# write and save as CSV
with open("provinces.csv", "w", newline="", encoding="utf-8") as csvfile:
    fieldnames = ["region", "province"]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)

print("Conversion complete! File saved as provinces.csv")
