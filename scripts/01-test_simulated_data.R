#### Preamble ####
# Purpose: Tests the structure and validity of the simulated_data 
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

library(tidyverse)

test_simulated_data <- function(data) {
  # Test if the data was successfully loaded
  if (exists("data")) {
    message("Test Passed: The dataset was successfully loaded.")
  } else {
    stop("Test Failed: The dataset could not be loaded.")
  }
  
  # Check if the dataset has 100 rows (adjust if needed)
  if (nrow(data) == 100) {
    message("Test Passed: The dataset has 100 rows.")
  } else {
    stop("Test Failed: The dataset does not have 100 rows.")
  }
  
  # Check if the dataset has 9 columns (based on your simulated data)
  if (ncol(data) == 9) {
    message("Test Passed: The dataset has 9 columns.")
  } else {
    stop("Test Failed: The dataset does not have 9 columns.")
  }
  
  # Check if all values in the 'internal' column are valid (true or false)
  if (all(data$internal %in% c("TRUE", "FALSE"))) {
    message("Test Passed: All values in 'internal' are valid (true or false).")
  } else {
    stop("Test Failed: The 'internal' column contains invalid values.")
  }
  
  # Check if the 'party' column contains only valid party names
  valid_parties <- c("DEM", "REP")
  
  if (all(data$party %in% valid_parties)) {
    message("Test Passed: The 'party' column contains only valid party names.")
  } else {
    stop("Test Failed: The 'party' column contains invalid party names.")
  }
  
  # Check if there are any missing values in the dataset
  if (all(!is.na(data))) {
    message("Test Passed: The dataset contains no missing values.")
  } else {
    stop("Test Failed: The dataset contains missing values.")
  }
  
  # Check if there are no empty strings in 'pollscore', 'numeric_grade', and 'party' columns
  if (all(data$pollscore != "" & data$numeric_grade != "" & data$party != "")) {
    message("Test Passed: There are no empty strings in 'pollscore', 'numeric_grade', or 'party'.")
  } else {
    stop("Test Failed: There are empty strings in one or more columns.")
  }
  
  # Check if the 'party' column has at least two unique values
  if (n_distinct(data$party) >= 2) {
    message("Test Passed: The 'party' column contains at least two unique values.")
  } else {
    stop("Test Failed: The 'party' column contains less than two unique values.")
  }
}

# Load the simulated data for testing
analysis_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Run the test on the loaded data
test_simulated_data(analysis_data)
