# Football Data Engineering

This Python-based project crawls data from Wikipedia using Apache Airflow, cleans it and pushes it Azure Data Lake for processing.

# Project Overview:
This project builds an automated data engineering pipeline that scrapes, processes, stores, and analyzes structured football data for major leagues and tournaments around the world using Wikipedia as the primary source. The pipeline is implemented using Python 3.9, Apache Airflow 2.6 for orchestration, PostgreSQL for storage, and fully containerized with Docker to ensure portability and ease of deployment.

The final deliverable is a structured, queryable database of global football data, enriched with automated update pipelines and visual insights.

# Business Problem:
Football data exists in many places, but it is often siloed, inconsistently structured, or paywalled. Wikipedia offers extensive and publicly accessible football statistics, yet it lacks structured formatting for analytical use. This project addresses:

The need for centralized, structured football data.

Automation of data scraping, cleaning, and transformation.

A reproducible and extensible solution using open-source tools.

# Project Objectives:
## 1.Data Ingestion:

   Use Python 3.9 to scrape structured football data (league tables, player stats, match results) from Wikipedia.

   Target the world’s top football competitions: EPL, La Liga, Serie A, Bundesliga, Ligue 1, UEFA Champions League, FIFA World Cup, etc.

## 2.Data Cleaning & Transformation:

   Parse and clean HTML tables into standardized pandas DataFrames.

   Normalize data formats (dates, scores, club names, etc.) for consistency.

   Perform feature engineering (e.g., goal differences, points per game).

## 3.Data Storage:

   Store processed data in a structured PostgreSQL relational database.

   Create normalized schema (e.g., tables for Teams, Matches, Players, Competitions).

## 4.Pipeline Orchestration:

    Build DAGs in Apache Airflow 2.6 to automate:
   Scraping data from Wikipedia on a schedule.
   
   Cleaning and transforming data.
   
   Loading data into PostgreSQL.
   
    Handle dependencies, retries, logging, and task monitoring.

## 5.Containerization:

    Use Docker to containerize:

   Python scraper and transformer.
   
   PostgreSQL instance.
   
   Apache Airflow environment.

    Define services using docker-compose.

## 6.Exploratory Data Analysis (EDA):

    Use Jupyter Notebooks or Streamlit to explore:

   Team performance trends.
   
   Historical league outcomes.
   
   Goal scoring patterns.

## 7.Documentation & Automation:

   Write clean, reusable Python code with comments.

   Automate local setup and deployment using Docker.

   Provide README with instructions and architecture overview.


# Tools and Technologies:
Component	Tools/Tech Stack

Language:   	Python 3.9

Web Scraping:   	BeautifulSoup, Requests

Orchestration:   	Apache Airflow 2.6

Raw Data Storage:   	PostgreSQL 14+

Containerization:   	Docker, Docker Compose

Data Processing:   	Pandas

Processed Data Storage:    Azure Data Lake Gen2

EDA & Notebooks:   	JupyterLab, Streamlit (optional)

Deployment:    	GitHub, Docker Hub

Monitoring:    	Airflow UI, Logs

# Expected Deliverables:
Cleaned and structured PostgreSQL database containing global football data.

Apache Airflow DAGs automating the ETL pipeline.

Docker Compose configuration for local or cloud-based deployment.

Modular Python scripts for scraping, cleaning, and loading.

README and technical documentation.

Optional Streamlit or Jupyter dashboard for insights and trends.

# Sample Use Cases:
Compare seasonal performance of top clubs across leagues.

Analyze top scorers across multiple competitions.

Identify underperforming teams by goal differential.

Generate stats for sports journalists or social media analysis.

# Table of Contents

1. [System Architecture](#system-architecture)
2. [Requirements](#requirements)
3. [Getting Started](#getting-started)
4. [Running the Code With Docker](#running-the-code-with-docker)
5. [How It Works](#how-it-works)
6. [Video](#video)

# System Architecture
![system_architecture.png](assets%2Fsystem_architecture.png)

# System Architecture Breakdown
### 1. Data Source: Wikipedia
You are scraping football club data from Wikipedia using Python + BeautifulSoup in an Airflow DAG.

Data is cleaned and pushed into a PostgreSQL database (containerized via Docker).

### 2. ETL Orchestration: Apache Airflow
Runs in Docker.

DAGs schedule web scraping and push data to PostgreSQL daily.

Airflow acts as the controller of the entire data pipeline.

### 3. Storage: Azure Data Lake Gen2
PostgreSQL acts as staging; final structured data is moved to Azure Data Lake Gen2 via:

   Azure Data Factory (ADF) pipeline, which connects to PostgreSQL and writes to ADLS in CSV/Parquet.

### 4. Processing Layer: Databricks
Connects to ADLS Gen2, reads raw files, cleans them using PySpark, aggregates, and writes back processed data.

### 5. BI Layer: Tableau / Power BI / Looker Studio
Directly connects to Azure Data Lake Gen2 or processed data output from Databricks.

Dashboards visualize:

   Number of clubs per country.

   Geographic distribution.

   Time-based trends if applicable.

# Requirements
- Python 3.9 (minimum)
- Docker
- PostgreSQL
- Apache Airflow 2.6 (minimum)

# Project Folder Structure
   ```bash

football_data_pipeline/
│
├── docker/
│   ├── airflow/                  # Airflow config & DAGs
│   │   ├── dags/
│   │   └── docker-compose.yml
│   └── postgres/                 # PostgreSQL config
│       └── init.sql
│
├── data_scraper/                # Python scraping scripts
│   ├── scrape_wikipedia.py
│   └── utils.py
│
├── notebooks/                   # Databricks notebooks
│   └── transform_football_data.py
│
├── adf/                         # Azure Data Factory config (JSON)
├── tableau/                     # Tableau workbook (.twbx)
└── README.md
   ```

# Getting Started

1. Clone the repository.
   ```bash
   git clone https://github.com/airscholar/FootballDataEngineering.git
   ```

2. Install Python dependencies.
   ```bash
   pip install -r requirements.txt
   ```
   
# Running the Code With Docker

1. Start your services on Docker with
   ```bash
   docker compose up -d
   ``` 
2. Trigger the DAG on the Airflow UI.


### 2. Dockerized Local Setup
A. PostgreSQL in Docker
docker/postgres/init.sql (create schema/tables)

   ``` sql
CREATE TABLE clubs (
    id SERIAL PRIMARY KEY,
    name TEXT,
    country TEXT,
    league TEXT
);
   ```

docker-compose.yml (PostgreSQL + Airflow)

   ``` yaml

version: '3.8'
services:
  postgres:
    image: postgres:13
    environment:
      POSTGRES_USER: football
      POSTGRES_PASSWORD: password
      POSTGRES_DB: football_db
    volumes:
      - ./postgres/init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"

  airflow:
    image: apache/airflow:2.6.0
    environment:
      - AIRFLOW__CORE__EXECUTOR=LocalExecutor
    volumes:
      - ./airflow/dags:/opt/airflow/dags
    ports:
      - "8080:8080"
    depends_on:
      - postgres
   ```

### 3. Python Web Scraper

data_scraper/scrape_wikipedia.py

   ``` python

import requests
from bs4 import BeautifulSoup
import psycopg2

   ```

### 4. Apache Airflow DAG

airflow/dags/football_dag.py

   ``` python

from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

   ```

### 5. Azure Data Lake Gen2 Setup
A. Create ADLS Gen2
   ``` bash

az storage account create --name <yourStorageAccount> --resource-group <yourRG> --sku Standard_LRS --kind StorageV2 --hierarchical-namespace true
   ``` 
B. Create Container
   ``` bash

az storage container create --name raw --account-name <yourStorageAccount>
   ``` 
### 6. Azure Data Factory
Create a pipeline that:

Connects to PostgreSQL

Pulls cleaned data

Writes it as CSV to Azure Data Lake Gen2

You’ll configure:

Linked Service (PostgreSQL)

Linked Service (ADLS)

Dataset (Postgres source)

Dataset (ADLS CSV sink)

Copy Activity

### 7. Databricks Setup
A. Upload Notebook
   ``` python

# Databricks PySpark
df = spark.read.option("header", "true").csv("abfss://raw@<storage>.dfs.core.windows.net/clubs.csv")
df_clean = df.dropna()
df_clean.write.mode("overwrite").parquet("abfss://cleaned@<storage>.dfs.core.windows.net/clubs_cleaned")
Configure your cluster with Azure Data Lake Storage credential passthrough
   ``` 

### 8. BI Layer
A. Tableau / Power BI
Connect to:

Azure Data Lake Gen2 using Azure Blob Connector

OR directly to processed data in Databricks

Use .twbx to create and publish dashboards

B. Sharing
Tableau Public: Upload .twbx

Tableau Server/Cloud: Publish securely

Power BI: Publish to Power BI Service

### 9. Optional: Monitoring & CI/CD

Monitor Airflow DAGs (alerts via Slack/Email)

Use GitHub Actions or Azure DevOps for:

DAG updates

Notebook deployment

Infra provisioning with Terraform


# How It Works
1. Fetches data from Wikipedia.
2. Cleans the data.
3. Transforms the data.
4. Pushes the data to Azure Data Lake.


#### Here’s a step-by-step breakdown of how to relaunch a .twbx file (Tableau Packaged Workbook) so a third party can view and interact with your dashboard:

### What is a .twbx file?
A .twbx file contains the Tableau workbook (.twb) along with the data sources, images, and custom calculations — all in one portable package. Perfect for sharing!

## Option 1: Share via Tableau Public (Free but Public)
### Step 1: Create a Tableau Public Account

   Go to https://public.tableau.com

   Sign up for a free account

### Step 2: Open .twbx in Tableau Desktop or Tableau Public

   Launch Tableau Public Desktop or Tableau Desktop

   Go to File > Open, select your football-dashboard.twbx file

### Step 3: Publish to Tableau Public

   Click File > Save to Tableau Public As...

   It will prompt login to your Tableau Public account

   Uploads your dashboard to the public gallery

### Step 4: Share the Link

   Once uploaded, you'll get a shareable link (or embed code)

   Anyone with the link can view the dashboard online



## Option 2: Share via Tableau Server or Tableau Cloud (Private/Enterprise)

### Step 1: Get Access to a Tableau Server or Tableau Cloud Site

   If your org uses Tableau Server or Cloud, ensure you're a licensed user

### Step 2: Open .twbx in Tableau Desktop

   Go to File > Open, select your football-dashboard.twbx

### Step 3: Sign In to Tableau Server/Cloud

   Click Server > Sign In

   Enter your organization's server URL and credentials

### Step 4: Publish Workbook

   Click Server > Publish Workbook

   Select the project (folder) on the server

   Configure:

   Data refresh options

   Permissions for 3rd-party viewers (Viewer role, access rights)

### Step 5: Share Access

   Send the generated dashboard URL

   The third-party will need either:

   Viewer credentials

   SAML/SSO login depending on your organization’s access rules

## Option 3: Local Sharing (Offline Viewing)

### Step 1: Send the .twbx File
   Send the file via Google Drive, Dropbox, etc.

### Step 2: Ask the Third Party to Install Tableau Reader
   Download from https://www.tableau.com/products/reader (free)

   They can open the .twbx locally without needing internet

   Limitation: Interactivity is limited compared to Tableau Server/Cloud, and no real-time collaboration.

   Best Practice Recommendation
   If you're working on a professional or client-facing data pipeline:

   Use Tableau Cloud for private dashboards and regular refreshes

   Or Tableau Public for quick public portfolio demos

# Future Enhancements:
Add scraping logic for non-Wikipedia sources (e.g., FBref, Transfermarkt).

Integrate additional data: injuries, transfers, referee data, match weather.

Deploy to AWS/GCP using ECS or Kubernetes.

Add Slack notifications on DAG failures.

# Success Criteria:
Successfully run Airflow DAG that scrapes and loads data end-to-end.

PostgreSQL contains structured and validated tables for all target leagues.

Dockerized project deploys in one command with Docker Compose.

Readable and documented code, ready for extension and scaling.
