#### Preamble ####
# Purpose: test on the analysis data for validation
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-analysis_data saved and loaded
# Any other information needed? None



#### Workspace setup ####
# Install required packages
install.packages("tidyverse")
install.packages("testthat")
install.packages("arrow")
install.packages("here")

# Load necessary libraries
library(tidyverse)
library(testthat)
library(arrow) # For reading Parquet files
library(here)

Trump_test <- read_parquet(here::here("data/02-analysis_data/02-testing/test_Trump.parquet"))
Harris_test <- read_parquet(here::here("data/02-analysis_data/02-testing/test_Harris.parquet"))
Trump_train <- read_parquet(here::here("data/02-analysis_data/01-training/train_Trump.parquet"))
Harris_train <- read_parquet(here::here("data/02-analysis_data/01-training/train_Harris.parquet"))

#### Test data ####

# Ensure testthat setup
context("Data validation tests for Trump and Harris datasets")

# Test 1: Check if the datasets have the expected columns
test_that("Expected columns are present in Trump and Harris test and train datasets", {
  expected_columns <- c(
    "numeric_grade", "pollscore", "methodology", "transparency_score",
    "sample_size", "population", "ranked_choice_reallocated",
    "hypothetical", "score", "duration"
  )

  # Check columns in each dataset
  expect_true(all(expected_columns %in% colnames(Trump_test)))
  expect_true(all(expected_columns %in% colnames(Harris_test)))
  expect_true(all(expected_columns %in% colnames(Trump_train)))
  expect_true(all(expected_columns %in% colnames(Harris_train)))
})

# Test 2: Check for missing values
test_that("No missing values in critical columns of test and train datasets", {
  # List critical columns
  critical_columns <- c("numeric_grade", "pollscore", "score", "sample_size", "population")

  # Check for missing values
  for (col in critical_columns) {
    expect_true(all(!is.na(Trump_test[[col]])), info = paste("Missing values in Trump_test:", col))
    expect_true(all(!is.na(Harris_test[[col]])), info = paste("Missing values in Harris_test:", col))
    expect_true(all(!is.na(Trump_train[[col]])), info = paste("Missing values in Trump_train:", col))
    expect_true(all(!is.na(Harris_train[[col]])), info = paste("Missing values in Harris_train:", col))
  }
})

# Test 3: Check data types of columns
test_that("Columns have the correct data types", {
  # Numeric columns
  numeric_columns <- c("numeric_grade", "pollscore", "transparency_score", "sample_size", "score", "duration")

  # Logical columns
  logical_columns <- c("ranked_choice_reallocated", "hypothetical")

  # Check data types in each dataset
  for (col in numeric_columns) {
    expect_true(is.numeric(Trump_test[[col]]), info = paste("Column not numeric in Trump_test:", col))
    expect_true(is.numeric(Harris_test[[col]]), info = paste("Column not numeric in Harris_test:", col))
    expect_true(is.numeric(Trump_train[[col]]), info = paste("Column not numeric in Trump_train:", col))
    expect_true(is.numeric(Harris_train[[col]]), info = paste("Column not numeric in Harris_train:", col))
  }

  for (col in logical_columns) {
    expect_true(is.logical(Trump_test[[col]]), info = paste("Column not logical in Trump_test:", col))
    expect_true(is.logical(Harris_test[[col]]), info = paste("Column not logical in Harris_test:", col))
    expect_true(is.logical(Trump_train[[col]]), info = paste("Column not logical in Trump_train:", col))
    expect_true(is.logical(Harris_train[[col]]), info = paste("Column not logical in Harris_train:", col))
  }
})

# Test 4: Check ranges of certain columns
test_that("Sample size and scores fall within reasonable ranges", {
  # Reasonable ranges for `sample_size` and `score`
  expect_true(all(Trump_test$sample_size > 0), info = "Sample size should be positive in Trump_test")
  expect_true(all(Harris_test$sample_size > 0), info = "Sample size should be positive in Harris_test")
  expect_true(all(Trump_train$sample_size > 0), info = "Sample size should be positive in Trump_train")
  expect_true(all(Harris_train$sample_size > 0), info = "Sample size should be positive in Harris_train")

  expect_true(all(Trump_test$score >= 0 & Trump_test$score <= 100), info = "Score out of range in Trump_test")
  expect_true(all(Harris_test$score >= 0 & Harris_test$score <= 100), info = "Score out of range in Harris_test")
  expect_true(all(Trump_train$score >= 0 & Trump_train$score <= 100), info = "Score out of range in Trump_train")
  expect_true(all(Harris_train$score >= 0 & Harris_train$score <= 100), info = "Score out of range in Harris_train")
})

# Test 5: Check if population column contains only expected values
test_that("Population column contains only expected values", {
  # Define expected population levels
  expected_population_levels <- c("rv", "lv", "a", "v", NA)

  # Check levels in each dataset
  expect_true(all(Trump_test$population %in% expected_population_levels), info = "Unexpected values in Trump_test population")
  expect_true(all(Harris_test$population %in% expected_population_levels), info = "Unexpected values in Harris_test population")
  expect_true(all(Trump_train$population %in% expected_population_levels), info = "Unexpected values in Trump_train population")
  expect_true(all(Harris_train$population %in% expected_population_levels), info = "Unexpected values in Harris_train population")
})
