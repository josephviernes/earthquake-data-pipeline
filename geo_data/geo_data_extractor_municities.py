import json
import csv

# load json file
with open("municities.json", "r", encoding="utf-8") as f:
    data = json.load(f)

rows = []

# traverse through the nested structure
for region, provinces in data.items():
    for province, municipalities in provinces.items():
        if isinstance(municipalities, dict):
            for municipality in municipalities.keys():
                rows.append({
                    "region": region,
                    "province": province,
                    "municipality": municipality
                })

        elif isinstance(municipalities, list):
            rows.append({
                "region": region,
                "province": province,
                "municipality": municipality
            })            


# write and save as CSV
with open("municities.csv", "w", newline="", encoding="utf-8") as csvfile:
    fieldnames = ["region", "province", "municipality"]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)

print("Conversion complete! File saved as municities.csv")
