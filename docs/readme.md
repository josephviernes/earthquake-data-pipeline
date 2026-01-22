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

### Extraction and Staging

Seismic data is scraped from the official PHIVOLCS website and processed using Beautiful Soup, which structures and parses the raw HTML content. The extracted earthquake records are then cleaned and organized into CSV files, which are subsequently uploaded to a Google Cloud Storage (GCS) bucket. This step serves as the staging layer in the automated ETL workflow, enabling reliable downstream data transformations and analysis.

The data pipeline operates in two modalities:
- A one-time historical extraction that retrieves archived earthquake data from the PHIVOLCS website, covering records from January 2020 up to the month preceding the DAG’s initial execution
- A recurring extraction that runs on a daily or hourly schedule (configurable within the DAG) to ingest newly published earthquake events


### Data Transformation (PySpark)

This stage performs schema normalization and data quality enforcement prior to loading
data into the analytical warehouse.

The transformation stage is implemented in Python using PySpark and operates on the
most recent earthquake data file stored in Google Cloud Storage (GCS).

#### Process Overview
- Automatically detects the latest earthquake CSV file in the GCS bucket using the
  Google Cloud client library
- Initializes a PySpark session to read the data directly from GCS
- Applies a series of transformations to clean, standardize, and enrich the dataset
- Writes the transformed data to BigQuery as a temporary staging table

#### Transformation Steps
- **Datetime normalization**
  - Expands month abbreviations to full names
  - Converts values into proper `TIMESTAMP` formats
- **Type casting**
  - Casts latitude, longitude, depth, and magnitude to precise numeric types
- **Text cleaning**
  - Removes extraneous whitespace and special characters from text fields
- **Feature extraction**
  - Derives the `province` field from the `relative_location` column using regular expressions

These transformations ensure the data is clean, consistent, and analytics-ready
before downstream modeling and ingestion into the fact table.


### Post-load Transformation & Warehousing

In the final stage of the Airflow orchestration, Airflow executes a Docker container that runs a Python script. The Python script connects to BigQuery and triggers a stored procedure. The stored procedure performs the following steps: (1) simplifies and standardizes province values, (2) populates the province_id column by referencing the province dimension table, (3) generates a unique identifier for each entry using BigQuery-native hashing (FARM_FINGERPRINT) and (4) merges unmatched entries into the main table, thereby completing the ingestion and transformation of earthquake data in BigQuery.

### Data Modelling

![Data Modelling](https://github.com/josephviernes/earthquake-data-pipeline/blob/main/docs/images/data_modelling.png)

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


### Orchestration


## Data Visualization

## Reproductivity (link)

## Credits/Special Mention