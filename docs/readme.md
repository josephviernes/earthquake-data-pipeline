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

This data pipeline uses a lightweight dimensional model in BigQuery, with a main fact table for earthquake events (100,000+ rows and counting) and a small province dimension table (83 provinces, 17 regions). The fact table records key attributes such as datetime, location, depth, magnitude, latitude, longitude, and other event-specific fields, along with a deterministic unique ID generated with FARM_FINGERPRINT. The province dimension table standardizes province names and provides province_id references for referential integrity. The pipeline enforces this model on staged new entries by standardizing province values, populating province_id, generating unique IDs, and merging only new or unmatched events into the fact table, producing a maintainable, analytics-ready schema that balances correctness and simplicity. 

Terraform provisions Google Cloud resources and defines the fact table schema, while the simpler province dimension is added manually.

### Extraction and Staging

Seismic data is scraped from the official PHIVOLCS website and processed using Beautiful Soup, which structures and parses the raw HTML content. The extracted earthquake records are then cleaned and organized into CSV files, which are subsequently uploaded to a Google Cloud Storage (GCS) bucket. This step serves as the staging layer in the automated ETL workflow, enabling reliable downstream data transformations and analysis.

### Transformation

The main transformation process begins with Python automatically identifying the most recent earthquake data file stored in the Google Cloud Storage (GCS) bucket using the Google Cloud client library. Once the latest file is detected, a PySpark session is established to read the data directly from GCS and perform data transformations such as cleaning text fields, converting data types, standardizing date formats, and extracting province information.

Specifically, month abbreviations in the datetime column are expanded to full names and converted into proper timestamp formats; latitude, longitude, depth, and magnitude values are cast into precise numeric types; extraneous whitespace and special characters are removed from text fields; and the province field is derived from the relative location column using regular expressions. These transformations collectively ensure that the data is clean, consistent, and analysis-ready before being written to BigQuery as a temporary table.

### Post-load Transformation & Warehousing

In the final stage of the Airflow orchestration, Airflow executes a Docker container that runs a Python script. The Python script connects to BigQuery and triggers a stored procedure. The stored procedure performs the following steps: (1) simplifies and standardizes province values, (2) populates the province_id column by referencing the province dimension table, (3) generates a unique identifier for each entry using BigQuery-native hashing (FARM_FINGERPRINT) and (4) merges unmatched entries into the main table, thereby completing the ingestion and transformation of earthquake data in BigQuery.


### Orchestration


## Data Visualization

## Reproductivity (link)

## Credits/Special Mention