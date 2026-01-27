# Pipeline Setup Guide

This document is divided into three parts:

1. Google Cloud resource setup
2. Hosting the pipeline on a local machine
3. Hosting the pipeline on Google Compute Engine (GCE)

---

## Part 1: Set up the Google Cloud Resources

* Configure **Google Cloud CLI** on your host machine to enable SSH access to the VM:

  * [https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)

* Authenticate your host machine using:

  ```bash
  gcloud auth login
  ```

* Clone the Git repository on your host machine.

* Install **Terraform**.

* Provision GCP resources (GCS Bucket and BigQuery datasets) using the `main.tf` file in the Git repository:

  * Update resource names as needed before running:

    ```bash
    terraform plan
    terraform apply
    ```

---

## Part 2: Hosting the Pipeline on a Local Machine

* Install **Docker**.

* Generate or copy the following Airflow keys for use in `docker-compose.yml`:

  * `AIRFLOW_WEBSERVER_SECRET_KEY`
  * `AIRFLOW__CORE__FERNET_KEY`

* Add these keys to the `.env` file inside the Airflow folder, along with:

  ```env
  AIRFLOW_UID=1000
  AIRFLOW_GID=0
  ```

* Add the Airflow container to the Docker group so it can control other containers via the mounted Docker socket:

  1. Determine the Docker group ID on the host machine:

     ```bash
     getent group docker
     ```

     Example output:

     ```text
     docker:x:986:
     ```

  2. Add the group ID to `docker-compose.yml`:

     ```yaml
     group_add:
       - 986
     ```

* Update variables in the Python DAGs:

  * Google credentials path
  * GCS bucket name
  * Other environment-specific variables

* Save and push the cloned repository to GitHub.

---

## Part 3: Hosting the Pipeline on Google Compute Engine (GCE)

Inside your GCE VM instance:

* Authenticate using:

  ```bash
  gcloud auth login
  ```

* Install **Docker**.

* Clone the Git repository onto the VM.

* Update VM instance settings:

  * **Networking**: Allow HTTP and HTTPS traffic
  * **Security**: Select the project’s service account

* In the Airflow UI, unpause the DAG before triggering.

* Manually trigger `initial_dag` from the terminal to perform the initial extraction, transformation, and loading based on the configured date range in the DAG variables.

* Copy the startup bash script from the `docs` folder into the VM instance **Startup Script** section:

  * This will automatically start Airflow using Docker and trigger the `earthquake_data_pipeline` DAG on VM startup.
