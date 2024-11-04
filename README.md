# The 2024 U.S. Presidential Election Forecast

## Overview

The United States holds a prominent position in the global technological and economic arena, with its political leadership exerting considerable influence on international technology partnerships and economic relationships. This project employs multiple linear regression to forecast the 2024 U.S. presidential election results by gathering and analyzing polling data from surveys featuring the same candidates. The insights generated aim to help stakeholders anticipate potential changes in U.S. policies. The model predicts Kamala Harris will receive 47.6% of the vote compared to Donald Trump's 43.5%. This straightforward yet effective regression model operates independently of time-series analysis or external events.

## Project Structure

### data

This directory contains all data files used in the project.

#### `00-simulated_data/`: Contains simulated data files in Parquet format for each candidate.

-   `simulated_candidate_1.parquet`: Simulated data for Candidate 1.

-   `simulated_candidate_2.parquet`: Simulated data for Candidate 2.

-   `simulated_candidate_3.parquet`: Simulated data for Candidate 3.

#### `01-raw_data/`: Contains the raw data collected for the analysis.

-   `raw_data.csv`: The raw dataset file.

#### `02-analysis_data/`: Contains data files prepared for model analysis, divided into training and testing sets.

-   `00-full/`: Full datasets for each candidate.

-   `train_Harris.parquet`: Full data for Harris.

-   `train_Trump.parquet`: Full data for Trump.

-   `01-training/`: Training datasets for each candidate.

-   `train_Harris.parquet`: Training data for Harris.

-   `train_Trump.parquet`: Training data for Trump.

-   `02-testing/`: Testing datasets for each candidate.

-   `test_Harris.parquet`: Testing data for Harris.

-   `test_Trump.parquet`: Testing data for Trump.

#### `03-cleaned_data/`: Contains cleaned data files.

-   `candidate_name_cleaned_data.parquet`: Multiple cleaned data for individual candidates.

### models

This directory contains the trained models for each candidate.

-   `Desantis_model.rds`: Trained model for DeSantis.
-   `Harris_model.rds`: Trained model for Harris.
-   `Trump_model.rds`: Trained model for Trump.

### other

Contains auxiliary files and documentation.

#### `llm_usage/`: Information on model usage, LaTeX formatting, and plotting.

-   `01-Model`: Resources related to model usage.
-   `02-Latex`: LaTeX resources for document preparation.
-   `03-Plots_and_tables`: Resources for plotting and tables.

#### `sketches/`: This folder contains preliminary drafts, diagrams, or conceptual sketches related to the project.

#### `variables_descriptions/`: This folder includes detailed descriptions of the variables used in the dataset.

### paper

This directory includes files related to the research paper.

#### `paper_files/`: Supporting files for the paper.

-   `paper.qmd`: Quarto document source file for the paper.
-   `paper.pdf`: Final version of the research paper in PDF format.

### scripts

R scripts used for data simulation, processing, model training, testing, and replication.

-   `00-simulate_data.R`: Script to simulate data for candidates.
-   `01-test_simulated_data.R`: Tests to validate the simulated data.
-   `02-download_data.R`: Script to download raw data from external sources.
-   `03-clean_data.R`: Cleans and preprocesses the raw data.
-   `04-test_analysis_data.R`: Tests to validate the processed analysis data.
-   `05-exploratory_data_analysis.qmd`: Quarto document for exploratory data analysis.
-   `06-model_data.R`: Script for model training and evaluation.
-   `07-replications.R`: Script to replicate key results in the analysis.

### Project File

`The-2024-U.S.-Presidential-Election-Forecast.Rproj`: R project file for setting up the project environment.

## Statement on LLM usage

This project utilized a Language Learning Model (LLM), specifically OpenAI's ChatGPT, to assist with various tasks, including data processing, code generation, troubleshooting, and documentation writing. The LLM was used to expedite the development process by providing structured guidance, generating sample code snippets, and suggesting improvements for code efficiency and readability. The entire chat history is available in other/llm_usage.
