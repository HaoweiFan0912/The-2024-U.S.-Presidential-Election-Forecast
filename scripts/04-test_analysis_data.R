#### Preamble ####
# Purpose: Tests the structure and contents of the analysis datasets for each candidate
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-analysis_data saved and loaded
# Any other information needed? None

# Load necessary libraries
library(tidyverse)
library(testthat)
library(arrow)  # For reading Parquet files
library(here)

# Define directory path for analysis data files
analysis_data_dir <- here("data/02-analysis_data")

# Get a list of all Parquet files in the directory
candidate_files <- list.files(analysis_data_dir, pattern = "\\.parquet$", full.names = TRUE)

# Define expected columns and data types (allowing both integer and double for numeric columns)
expected_columns <- c("poll_id", "numeric_grade", "pollscore", "Methodology", 
                      "transparency_score", "duration", "sample_size", 
                      "population", "hypothetical", "pct")
expected_types <- list(
  poll_id = c("double", "integer"),
  numeric_grade = c("double", "integer"),
  pollscore = c("double", "integer"),
  Methodology = "character",
  transparency_score = c("double", "integer"),
  duration = c("double", "integer"),
  sample_size = c("double", "integer"),
  population = "character",
  hypothetical = c("logical", "character"),
  pct = c("double", "integer")
)

# Function to test each candidate's data
test_candidate_data <- function(file_path) {
  data <- read_parquet(file_path)
  candidate_name <- tools::file_path_sans_ext(basename(file_path))
  
  test_that(paste("Dataset for", candidate_name, "has correct columns"), {
    expect_equal(sort(names(data)), sort(expected_columns))
  })
  
  test_that(paste("Dataset for", candidate_name, "has correct data types"), {
    for (col_name in names(expected_types)) {
      # Check if the column type is among the accepted types
      actual_type <- typeof(data[[col_name]])
      expect_true(actual_type %in% expected_types[[col_name]], 
                  info = paste("Expected", col_name, "to be one of", toString(expected_types[[col_name]]), 
                               "but got", actual_type))
    }
  })
  
  test_that(paste("Dataset for", candidate_name, "has no missing values in key columns"), {
    expect_true(all(!is.na(data$pct)))
    expect_true(all(!is.na(data$poll_id)))
  })
}

# Run tests for each Parquet file
for (file_path in candidate_files) {
  test_candidate_data(file_path)
}
