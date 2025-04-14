## Football Data Engineering

This Python-based project crawls data from Wikipedia using Apache Airflow, cleans it and pushes it Azure Data Lake for processing.

## Project Overview:
This project builds an automated data engineering pipeline that scrapes, processes, stores, and analyzes structured football data for major leagues and tournaments around the world using Wikipedia as the primary source. The pipeline is implemented using Python 3.9, Apache Airflow 2.6 for orchestration, PostgreSQL for storage, and fully containerized with Docker to ensure portability and ease of deployment.

The final deliverable is a structured, queryable database of global football data, enriched with automated update pipelines and visual insights.

## Business Problem:
Football data exists in many places, but it is often siloed, inconsistently structured, or paywalled. Wikipedia offers extensive and publicly accessible football statistics, yet it lacks structured formatting for analytical use. This project addresses:

The need for centralized, structured football data.

Automation of data scraping, cleaning, and transformation.

A reproducible and extensible solution using open-source tools.

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Requirements](#requirements)
3. [Getting Started](#getting-started)
4. [Running the Code With Docker](#running-the-code-with-docker)
5. [How It Works](#how-it-works)
6. [Video](#video)

## System Architecture
![system_architecture.png](assets%2Fsystem_architecture.png)

## Requirements
- Python 3.9 (minimum)
- Docker
- PostgreSQL
- Apache Airflow 2.6 (minimum)

## Getting Started

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

## How It Works
1. Fetches data from Wikipedia.
2. Cleans the data.
3. Transforms the data.
4. Pushes the data to Azure Data Lake.
