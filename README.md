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

  * Parse and clean HTML tables into standardized pandas DataFrames.

  * Normalize data formats (dates, scores, club names, etc.) for consistency.

  * Perform feature engineering (e.g., goal differences, points per game).

## 3.Data Storage:

   Store processed data in a structured PostgreSQL relational database.

   Create normalized schema (e.g., tables for Teams, Matches, Players, Competitions).

## 4.Pipeline Orchestration:

Build DAGs in Apache Airflow 2.6 to automate:
  * Scraping data from Wikipedia on a schedule.
   
  * Cleaning and transforming data.
   
  * Loading data into PostgreSQL.
   
    Handle dependencies, retries, logging, and task monitoring.

## 5.Containerization:

Use Docker to containerize:

  * Python scraper and transformer.
   
  * PostgreSQL instance.
   
  * Apache Airflow environment.

    Define services using docker-compose.

## 6.Exploratory Data Analysis (EDA):

Use Jupyter Notebooks or Streamlit to explore:

  * Team performance trends.
   
  * Historical league outcomes.
   
  * Goal scoring patterns.

## 7.Documentation & Automation:

   Write clean, reusable Python code with comments.

   Automate local setup and deployment using Docker.

   Provide README with instructions and architecture overview.


# Tools and Technologies:
Component	Tools/Tech Stack

**Language:**   	Python 3.9

**Web Scraping:**   	BeautifulSoup, Requests

**Orchestration:**   Apache Airflow 2.6

**Raw Data Storage:**   	PostgreSQL 14+

**Containerization:**   	Docker, Docker Compose

**Data Processing:**   	Pandas

**Processed Data Storage:**    Azure Data Lake Gen2

**Terraform**

**EDA & Notebooks:**   	JupyterLab, Streamlit (optional)

**Deployment:**    	GitHub, Docker Hub

**Monitoring:**    	Airflow UI, Logs

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
2. [Project Folder Structure](#project-folder-structure)
3. [Environment Setup](#environment-setup)
4. [Infrastructure Deployment (Terraform)](#infrastructure-deployment-terraform)
5. [Data Pipeline Setup (Airflow)](#data-pipeline-setup-airflow)
6. [ETL Flow](#etl-flow)
7. [Analytics & Dashboard](#analytics--dashboard)
8. [Running the Code With Docker](#running-the-code-with-docker)
9. [How It Works](#how-it-works)


# System Architecture
![system_architecture.png](assets%2Fsystem_architecture.png)

## System Architecture Breakdown
### 1. Data Ingestion Layer – Web Scraping (Python 3.9)

**Tool:** Python 3.9

**Process:** A custom script scrapes structured football club data from Wikipedia.

**Output:** JSON or CSV files

**Reasoning:** Wikipedia provides semi-structured and regularly updated data, ideal for scraping.

### 2. Orchestration & Workflow Management – Apache Airflow (Dockerized)

**Tool:** Apache Airflow 2.6 (running inside Docker)

**Scheduler:** Executes DAGs to:

* Run the scraper daily

* Save data to Azure Data Lake

* Trigger Data Factory pipelines
  
**Docker Use:** Containers isolate Postgres (metadata DB), Airflow scheduler, webserver, and workers.

**Logging:** Logs are written to mounted local volume for monitoring.

### 3. Intermediate Storage – Azure Data Lake Gen2 (Raw Layer)
* **Storage:** Raw files from scraping land here.

* **Naming Convention:** Timestamped folders and file paths for version control.

* **Access Control:** Managed via Azure RBAC & Storage Account Access Keys.

### 4. Data Processing & Transformation – Azure Data Factory (ADF)

**Tool:** Azure Data Factory pipeline

**Tasks:**

   * Cleans and normalizes scraped football data

   * Converts semi-structured to structured format (e.g., Parquet)

   * Moves transformed data to the curated layer

**Trigger:** Initiated via Airflow after raw data is uploaded

### 5. Processed Storage – Azure Data Lake Gen2 (Curated Layer)
* **Storage:** Cleaned and structured datasets stored for analytics

* **Purpose:** This serves as the trusted source for BI tools and Databricks

* **File Format:** Partitioned Parquet for optimized querying

### 6. Analytics & Advanced Transformations – Azure Databricks

**Tool:** Databricks notebook or pipeline

**Operations:**

   * Aggregations (e.g., Top clubs by revenue, trophies, attendance)

   * Trend analysis across continents or leagues

   * Feature engineering if ML models are added in future

**Connection:** Reads from curated Data Lake

### 7. Business Intelligence Layer – Tableau, Power BI, Looker Studio

**Integration Options:**

   * Direct connection to Azure Data Lake using ODBC drivers or Synapse views

   * Alternatively connect to Databricks SQL endpoints

**Goal:** Build interactive dashboards showcasing:

   * Club rankings

   * Year-over-year growth

   * Revenue vs. trophies correlation

   * League comparisons (Africa, Europe, etc.)

### 8. Infrastructure as Code – Terraform

**Tool:** Terraform

**Purpose:** Automate deployment of Azure services:

   * Resource Group

   * Data Lake Gen2 Storage Accounts

   * Azure Data Factory instance

   * Azure Databricks workspace

   * Networking & IAM policies

**Location in Architecture:** Terraform acts **outside** the data pipeline — it’s used at the **infrastructure provisioning stage, before** deploying the actual data logic (Airflow, scripts, ADF).

### 9. Local Development & Testing

**Tools:**

   * Jupyter notebooks (in /notebooks) for early-stage transformation testing

   * env and .env.example files to manage secrets locally

**Data:** Sample .csv or .json test files can be placed in /data for local DAG and script validation.


# Project Folder Structure
   ```bash

football-stadiums-of-world/
├── assets/                        # Images or Tableau dashboards if exported as static
├── dags/                          # Airflow DAGs
├── data/                          # Local storage of scraped/raw datasets
├── pipelines/                     # ETL logic, scripts for transformations
├── script/                        # SQL scripts, helper functions
│
├── terraform/                     # Terraform IaC for provisioning Azure resources
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── terraform.tfvars
│
├── docker-compose.yml             # For local containerized dev (Airflow, Postgres, etc.)
├── requirements.txt               # Python dependencies
├── script.sql                     # DB schema setup
├── README.md                      # Project description and usage
│
├── FootballDataEngineering Dashboard.twb      # Tableau workbook
├── football dashboard.twbx                     # Tableau packaged workbook (includes data)
└── --FootballDataEngineering Dashboard_63799... # Likely a temp/autosave file (can clean up)

   ```

# Environment Setup

> Required: Docker, Azure CLI, Terraform, Python 3.9

### 1. Clone the repo

```bash

git clone https://github.com/yourusername/football_data_engineering_project.git
cd football_data_engineering_project
```
2. Setup Python virtual environment

```bash
python3.9 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```
# Infrastructure Deployment (Terraform)

### 1. Authenticate Azure CLI

```bash
az login
az ad sp create-for-rbac --name terraform-sp --role Contributor --scopes /subscriptions/YOUR_SUB_ID
```
### 2. Deploy Azure Infrastructure

```bash

cd terraform/
terraform init
terraform plan
terraform apply
```
Terraform will deploy:

* Resource Group

* Data Lakes (raw + curated)

* Data Factory

* Databricks Workspace

* Role assignments and IAM

# Data Pipeline Setup (Airflow)

### 1. Launch Docker-based Airflow

```bash

cd docker/
docker-compose up airflow-init
docker-compose up
```

Airflow will:

* Run the DAGs from dags/

* Use scripts/ to scrape Wikipedia and insert data into Data Lake

# ETL Flow

1. web_scraper.py scrapes latest football club stats from Wikipedia.

2. Airflow DAG schedules scrape every 24 hours.

3. Raw data saved into Azure Data Lake Gen2.

4. ADF pipeline processes and stages the data.

5. Curated datasets are created and written to second Data Lake.

6. Databricks notebook performs advanced transformations (ranking, comparisons).

7. Dashboards connect to curated output.

# Analytics & Dashboard
Connect Power BI, Tableau, or Looker Studio to:

* Curated storage layer

* Or Databricks SQL Endpoint

Use assets/ for logos or visual templates.

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



# Extra info incase you get lost (only use if the first setup goes wrong and need a second method)
> This is for a more direct set up/ step-by-step up instructions

1. Clone the repository.
   ```bash
   git clone https://github.com/airscholar/FootballDataEngineering.git
   ```

2. Install Python dependencies.
   ```bash
   pip install -r requirements.txt
   ```
   
## Running the Code With Docker

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
