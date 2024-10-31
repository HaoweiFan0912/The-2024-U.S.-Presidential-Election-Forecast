#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 26 September 2024 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

<<<<<<< HEAD

#### Workspace setup ####
=======
# Load necessary libraries
>>>>>>> 15d932b68ef20c88ef288ebba19468b185b47d9c
library(tidyverse)
library(testthat)
library(arrow)  # For reading Parquet files
library(here)

<<<<<<< HEAD
data <- read_csv("data/02-analysis_data/analysis_data.csv")


#### Test data ####
# Test that the dataset has 151 rows - there are 151 divisions in Australia
test_that("dataset has 151 rows", {
  expect_equal(nrow(analysis_data), 151)
})

# Test that the dataset has 3 columns
test_that("dataset has 3 columns", {
  expect_equal(ncol(analysis_data), 3)
})

# Test that the 'division' column is character type
test_that("'division' is character", {
  expect_type(analysis_data$division, "character")
})

# Test that the 'party' column is character type
test_that("'party' is character", {
  expect_type(analysis_data$party, "character")
})

# Test that the 'state' column is character type
test_that("'state' is character", {
  expect_type(analysis_data$state, "character")
})

# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(analysis_data)))
})

# Test that 'division' contains unique values (no duplicates)
test_that("'division' column contains unique values", {
  expect_equal(length(unique(analysis_data$division)), 151)
})

# Test that 'state' contains only valid Australian state or territory names
valid_states <- c("New South Wales", "Victoria", "Queensland", "South Australia", "Western Australia", 
                  "Tasmania", "Northern Territory", "Australian Capital Territory")
test_that("'state' contains valid Australian state names", {
  expect_true(all(analysis_data$state %in% valid_states))
})

# Test that there are no empty strings in 'division', 'party', or 'state' columns
test_that("no empty strings in 'division', 'party', or 'state' columns", {
  expect_false(any(analysis_data$division == "" | analysis_data$party == "" | analysis_data$state == ""))
})

# Test that the 'party' column contains at least 2 unique values
test_that("'party' column contains at least 2 unique values", {
  expect_true(length(unique(analysis_data$party)) >= 2)
})
=======
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
>>>>>>> 15d932b68ef20c88ef288ebba19468b185b47d9c
