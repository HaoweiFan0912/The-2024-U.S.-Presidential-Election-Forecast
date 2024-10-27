# The 2024 U.S. Presidential Election Forecast

## Overview

This project contains a series of scripts and data folders for a comprehensive data analysis workflow. Each folder and file is organized to support tasks from data simulation to model building and replication. Below is an overview of the project’s folder structure and the purpose of each file.

## Directory Structure
The repo is structured as:

### `data/`

This folder contains various stages of data used in the project.

-   **00-simulated_data/**: Contains the initial simulated datasets for testing the analysis process.
-   **01-raw_data/**: Stores raw data files that are directly imported or downloaded before any processing.
-   **02-analysis_data/**: Holds data files that have been processed and structured for analysis.
-   **03-cleaned_data/**: Contains the final cleaned datasets used in modeling and analysis.

### `models/`

This folder is used to store the RDS files of the models generated in the analysis. Files are saved in the format `{Candidate}_{Method}_model.rds`, for example: - `Trump_linear_model.rds` - `Biden_Bayesian_model.rds`

### `other/`

Supporting documents and reference materials.

-   **datasheet/**: Contains metadata and additional documentation.
-   **literature/**: Stores literature references or related papers.
-   **llm_usage/**: Documentation on how large language models (LLMs) were used in the project.
-   **sketches/**: Visuals, sketches, or other representations related to the data and model insights.

### `paper/`

Contains the final research paper along with supplementary materials like figures or tables used in the publication.

### `scripts/`

Contains all the R scripts necessary for data processing, analysis, and modeling.

-   **00-simulate_data.R**: Generates simulated data for initial testing.
-   **01-test_simulated_data.R**: Tests the simulated data to ensure quality and integrity.
-   **02-download_data.R**: Downloads the raw data from specified sources.
-   **03-clean_data.R**: Cleans and preprocesses the raw data for analysis.
-   **04-test_analysis_data.R**: Tests the cleaned data to ensure it's ready for analysis.
-   **05-exploratory_data_analysis.R**: Conducts exploratory data analysis and creates visualizations.
-   **06-model_data.R**: Builds linear and Bayesian models for each candidate and saves the results.
-   **07-replications.R**: Script to replicate analyses and generate predictions for the models.

## Statement on LLM usage

Aspects of the code were written with the help of the auto-complete tool, Codriver. The abstract and introduction were written with the help of ChatHorse and the entire chat history is available in inputs/llms/usage.txt.
