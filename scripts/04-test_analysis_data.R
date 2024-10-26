#### Preamble ####
# Purpose: Tests the structure and contents of the analysis datasets for each candidate
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-analysis_data saved and loaded
# Any other information needed? None

library(tidyverse)
library(testthat)

# Set working directory to project root
setwd("..")  # Move up one level from the 'scripts' folder to the project root

# Define paths for each candidate's data
candidate_files <- list(
  "Donald Trump" = "data/02-analysis_data/Donald Trump_cleaned_data.csv",
  "Kamala Harris" = "data/02-analysis_data/Kamala Harris_cleaned_data.csv",
  "Joe Biden" = "data/02-analysis_data/Joe Biden_cleaned_data.csv"
)

# Define expected columns
expected_cols <- c("poll_id", "numeric_grade", "pollscore", "Methodology", 
                   "transparency_score", "duration", "sample_size", 
                   "population", "hypothetical", "pct")

# Function to run tests on a given dataset
test_candidate_data <- function(file_path, candidate_name) {
  data <- read_csv(file_path)
  
  test_that(paste("dataset for", candidate_name, "has correct number of columns"), {
    expect_equal(ncol(data), length(expected_cols))
  })
  
  test_that(paste("dataset for", candidate_name, "contains expected columns"), {
    present_cols <- intersect(expected_cols, colnames(data))
    missing_cols <- setdiff(expected_cols, present_cols)
    
    # Display missing columns if any
    if (length(missing_cols) > 0) {
      warning(paste("Missing columns for", candidate_name, ":", paste(missing_cols, collapse = ", ")))
    }
    
    # Test that all expected columns are present
    expect_setequal(colnames(data), expected_cols)
  })
  
  test_that(paste("column types are as expected for", candidate_name), {
    # Check types only if column exists
    if ("Methodology" %in% colnames(data)) expect_type(data$Methodology, "character")
    if ("population" %in% colnames(data)) expect_type(data$population, "character")
    if ("hypothetical" %in% colnames(data)) expect_type(data$hypothetical, "logical")
    if ("poll_id" %in% colnames(data)) expect_type(data$poll_id, "double")
    if ("numeric_grade" %in% colnames(data)) expect_type(data$numeric_grade, "double")
    if ("pollscore" %in% colnames(data)) expect_type(data$pollscore, "double")
    if ("transparency_score" %in% colnames(data)) expect_type(data$transparency_score, "double")
    if ("duration" %in% colnames(data)) expect_type(data$duration, "double")
    if ("sample_size" %in% colnames(data)) expect_type(data$sample_size, "double")
    if ("pct" %in% colnames(data)) expect_type(data$pct, "double")
  })
}

# Run tests for each candidate
for (candidate_name in names(candidate_files)) {
  test_candidate_data(candidate_files[[candidate_name]], candidate_name)
}
