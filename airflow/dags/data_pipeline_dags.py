import os
from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from datetime import datetime, timedelta
from docker.types import Mount


#set-up your google storage bucket and if neeeded, the folder inside the bucket
bucket = "earthquake-etl-bucket"
folder = "dailies"
project = "earthquake-etl"
dataset = "earthquake_etl_dataset"


default_args = {
    'owner': 'jnv',
    'retries': 1,
    'retry_delay': timedelta(minutes=2),
}


with DAG(
    default_args=default_args,
    dag_id="earthquake_data_pipeline_v2",
    tags=["earthquake"],
    catchup=False,
    schedule_interval=None,
    start_date=datetime(2025, 6, 10),
) as dag:

    t1 = DockerOperator(
        task_id="scraper",
        image='asia-southeast1-docker.pkg.dev/earthquake-etl/etl-docker-repo/earthquake_data_web_scraper:v2.1',
        docker_url='unix://var/run/docker.sock',
        network_mode='bridge',
        mount_tmp_dir=False,
        environment={"bucket": bucket, "folder": folder, "project": project, "dataset": dataset},
        command='python3 scraper.py',
        auto_remove=True,
    )

    t2 = DockerOperator(
        task_id="processor",
        image='asia-southeast1-docker.pkg.dev/earthquake-etl/etl-docker-repo/earthquake_data_processor:v2.0',
        docker_url='unix://var/run/docker.sock',
        network_mode='bridge',
        mount_tmp_dir=False,
        environment={"bucket": bucket, "folder": folder, "project": project, "dataset": dataset},
        command='python3 processor.py',
        auto_remove=True,
    )

    t3 = DockerOperator(
        task_id="merger",
        image='asia-southeast1-docker.pkg.dev/earthquake-etl/etl-docker-repo/earthquake_data_merger:v2.0',
        docker_url='unix://var/run/docker.sock',
        network_mode='bridge',
        mount_tmp_dir=False,
        environment={"bucket": bucket, "folder": folder, "project": project, "dataset": dataset},
        command='python3 merger.py',
        auto_remove=True,
    )

    t1 >> t2 >> t3
