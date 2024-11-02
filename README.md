# The 2024 U.S. Presidential Election Forecast

## Overview

This project contains a series of scripts and data folders for a comprehensive data analysis workflow. Each folder and file is organized to support tasks from data simulation to model building and replication. Below is an overview of the project’s folder structure and the purpose of each file.

## Directory Structure

The repo is structured as:

```{kotlin}
├── data/
│   ├── 00-simulated_data/
│   │   ├── simulated_candidate_1.parquet
│   │   ├── simulated_candidate_2.parquet
│   │   └── simulated_candidate_3.parquet
│   ├── 01-raw_data/
│   │   └── raw_data.csv
│   ├── 02-analysis_data/
│   │   ├── 01-training/
│   │   │   ├── train_DeSantis.parquet
│   │   │   ├── train_Harris.parquet
│   │   │   └── train_Trump.parquet
│   │   └── 02-testing/
│   │       ├── test_DeSantis.parquet
│   │       ├── test_Harris.parquet
│   │       └── test_Trump.parquet
│   └── 03-cleaned_data/
│           └── candidate_name_cleaned_data.parquet
├── models/
│   ├── Desantis_model.rds
│   ├── Harris_model.rds
│   └── Trump_model.rds
├── other/
│   ├── llm_usage/
│   │   ├── 01-Model
│   │   ├── 02-Latex
│   │   └── 03-Plots_and_tables
│   ├── sketches/
│   └── variables_descriptions/
├── paper/
│   ├── paper_files/
│   ├── paper.qmd
│   └──paper.pdf
├── scripts/
│   ├── 00-simulate_data.R
│   ├── 01-test_simulated_data.R
│   ├── 02-download_data.R
│   ├── 03-clean_data.R
│   ├── 04-test_analysis_data.R
│   ├── 05-exploratory_data_analysis.qmd
│   ├── 06-model_data.R
│   └── 07-replications.R
├── README.md
└── The-2024-U.S.-Presidential-Election-Forecast.Rproj

```

## Contents

### 1.data

This directory contains all data files used in the project.

-   `00-simulated_data`: Contains simulated data files in Parquet format for each candidate.

-   `simulated_candidate_1.parquet`: Simulated data for Candidate 1.

-   `simulated_candidate_2.parquet`: Simulated data for Candidate 2.

-   `simulated_candidate_3.parquet`: Simulated data for Candidate 3.

-   `01-raw_data/`: Contains the raw data collected for the analysis.

-   `raw_data.csv`: The raw dataset file.

-   `02-analysis_data/`: Contains data files prepared for model analysis, divided into training and testing sets.

-   `01-training/`: Training datasets for each candidate.

-   `train_DeSantis.parquet`: Training data for DeSantis.

-   `train_Harris.parquet`: Training data for Harris.

-   `train_Trump.parquet`: Training data for Trump.

-   `02-testing/`: Testing datasets for each candidate.

-   `test_DeSantis.parquet`: Testing data for DeSantis.

-   `test_Harris.parquet`: Testing data for Harris.

-   `test_Trump.parquet`: Testing data for Trump.

-   `03-cleaned_data/`: Contains cleaned data files.

-   `candidate_name_cleaned_data.parquet`: Cleaned data for individual candidates.

### 2. models

This directory contains the trained models for each candidate.

-   `Desantis_model.rds`: Trained model for DeSantis.
-   `Harris_model.rds`: Trained model for Harris.
-   `Trump_model.rds`: Trained model for Trump.

### 3. other

Contains auxiliary files and documentation.

-   `llm_usage/`: Information on model usage, LaTeX formatting, and plotting.
-   `01-Model`: Resources related to model usage.
-   `02-Latex`: LaTeX resources for document preparation.
-   `03-Plots_and_tables`: Resources for plotting and tables.
-   `sketches/`: Visual or conceptual sketches related to the project.
-   `variables_descriptions/`: Detailed descriptions of the variables used in the dataset.

### 4. paper

This directory includes files related to the research paper.

-   `paper_files/`: Supporting files for the paper.
-   `paper.qmd`: Quarto document source file for the paper.
-   `paper.pdf`: Final version of the research paper in PDF format.

### 5. scripts

R scripts used for data simulation, processing, model training, testing, and replication.

-   `00-simulate_data.R`: Script to simulate data for candidates.
-   `01-test_simulated_data.R`: Tests to validate the simulated data.
-   `02-download_data.R`: Script to download raw data from external sources.
-   `03-clean_data.R`: Cleans and preprocesses the raw data.
-   `04-test_analysis_data.R`: Tests to validate the processed analysis data.
-   `05-exploratory_data_analysis.qmd`: Quarto document for exploratory data analysis.
-   `06-model_data.R`: Script for model training and evaluation.
-   `07-replications.R`: Script to replicate key results in the analysis.

### 6.Project File

`The-2024-U.S.-Presidential-Election-Forecast.Rproj`: R project file for setting up the project environment.

## Statement on LLM usage

Aspects of the code were written with the help of the auto-complete tool, Codriver. The abstract and introduction were written with the help of ChatHorse and the entire chat history is available in inputs/llms/usage.txt.
