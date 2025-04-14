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

Language	Python 3.9

Web Scraping	BeautifulSoup, Requests

Orchestration	Apache Airflow 2.6

Storage	PostgreSQL 14+

Containerization	Docker, Docker Compose

Data Processing	Pandas

EDA & Notebooks	JupyterLab, Streamlit (optional)

Deployment	GitHub, Docker Hub

Monitoring	Airflow UI, Logs

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

# How It Works
1. Fetches data from Wikipedia.
2. Cleans the data.
3. Transforms the data.
4. Pushes the data to Azure Data Lake.

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
