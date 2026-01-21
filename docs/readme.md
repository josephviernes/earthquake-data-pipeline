# Data Engineering Project: Scalable and Cloud-Native Philippine Seismic Data Pipeline

## Brief Project Description/Problem Statement
This repository contains a fully automated data engineering pipeline that extracts, transforms, and loads (ETL) earthquake data from the PHIVOLCS Online Earthquake Bulletin. It is designed to collect and structure publicly available seismic data for analytics, monitoring, and visualization. An interactive Looker Studio dashboard is connected to the BigQuery dataset to present real-time insights on earthquake activity.

The project aims to provide analysts with processed and structured data that enables the efficient development of reports and dashboards, supported by a scalable, reliable, cloud-native, and fully automated data pipeline. Additionally, it seeks to inform the public through an interactive dashboard that visualizes near real-time earthquake data collected from the PHIVOLCS Earthquake Bulletin, which compiles events detected by its national seismic monitoring network. The dashboard integrates geospatial mapping to highlight earthquake magnitude, depth, and regional impact.


## Technologies and Tools

 - Infrastructure as a Service (IaaS): [Google Compute Engine](https://cloud.google.com/products/compute)
 - Infrastructure as Code (IaC): [Terraform](https://github.com/hashicorp/terraform)
 - Containerization: [Docker](https://www.docker.com/), [Docker Compose](https://docs.docker.com/compose/), [Google Artifact Registry](https://cloud.google.com/artifact-registry/docs)
 - Workflow Orchestration: [Airflow](https://airflow.apache.org/)
 - Data Lake: [Google Cloud Storage](https://cloud.google.com/storage)
 - Data Warehouse: [BigQuery](https://cloud.google.com/bigquery)
 - Transformations: [Apache Spark](https://spark.apache.org/), [BigQuery](https://cloud.google.com/bigquery)
 - Visualizations: [Google Looker Studio](https://lookerstudio.google.com/)

## Data Engineering/Data Pipeline

![Data Pipeline Architecture](https://github.com/josephviernes/earthquake-data-pipeline/blob/main/docs/images/earthquake_data_pipeline.jpg)

### Data Modelling

![Data Pipeline Architecture](https://github.com/josephviernes/earthquake-data-pipeline/blob/main/docs/images/data_modelling.png)

This project implements a lightweight dimensional data model in BigQuery with:
- A primary fact table for earthquake events (100,000+ rows and growing)
- A small province dimension table (83 provinces and 17 regions)
- Database and table schemas defined declaratively using Terraform to ensure
  consistency, reproducibility, and version control

#### Fact Table: phivolcs_earthquake
- Grain: one row per earthquake event
- Stores event attributes: datetime, depth, magnitude, latitude, longitude, relative location
- Includes a foreign key reference to province data
- Uses a deterministic unique identifier generated with BigQuery’s `FARM_FINGERPRINT`
  to recognize existing events and prevent duplicates

#### Dimension Table: dim_provinces
- Standardizes geographic attributes and avoids duplication
- Sourced from an official Philippine government open data dataset
- Processed and curated for consistency

#### Relationships
- `phivolcs_earthquake.province_id` → `dim_provinces.province_id`

#### Model Enforcement and Data Integrity
During ingestion in BigQuery, the pipeline enforces the data model by:
- Standardizing province values in the provinces dimension table from raw location csv file
- Standardizing and correcting province/location values of staged seismic events with the dimension table as reference
- Populating `province_id` column of the staged data with values from dimension table, preparing the data for merging
- Generating deterministic unique event identifiers
- Merging only new or previously unmatched earthquake events into the fact table

This approach produces a maintainable, analytics-ready schema optimized for
time-series and geographic analysis.


### Extraction and Staging

Seismic data is scraped from the official PHIVOLCS website and processed using Beautiful Soup, which structures and parses the raw HTML content. The extracted earthquake records are then cleaned and organized into CSV files, which are subsequently uploaded to a Google Cloud Storage (GCS) bucket. This step serves as the staging layer in the automated ETL workflow, enabling reliable downstream data transformations and analysis.

-- initial archived earthquake data from January 2020 to last month
-- daily updating of data

### Transformation

The main transformation process begins with Python automatically identifying the most recent earthquake data file stored in the Google Cloud Storage (GCS) bucket using the Google Cloud client library. Once the latest file is detected, a PySpark session is established to read the data directly from GCS and perform data transformations such as cleaning text fields, converting data types, standardizing date formats, and extracting province information.

Specifically, month abbreviations in the datetime column are expanded to full names and converted into proper timestamp formats; latitude, longitude, depth, and magnitude values are cast into precise numeric types; extraneous whitespace and special characters are removed from text fields; and the province field is derived from the relative location column using regular expressions. These transformations collectively ensure that the data is clean, consistent, and analysis-ready before being written to BigQuery as a temporary table.

### Post-load Transformation & Warehousing

In the final stage of the Airflow orchestration, Airflow executes a Docker container that runs a Python script. The Python script connects to BigQuery and triggers a stored procedure. The stored procedure performs the following steps: (1) simplifies and standardizes province values, (2) populates the province_id column by referencing the province dimension table, (3) generates a unique identifier for each entry using BigQuery-native hashing (FARM_FINGERPRINT) and (4) merges unmatched entries into the main table, thereby completing the ingestion and transformation of earthquake data in BigQuery.


### Orchestration


## Data Visualization

## Reproductivity (link)

## Credits/Special Mention