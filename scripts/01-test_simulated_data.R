#### Preamble ####
# Purpose: Tests the structure and validity of the simulated variables 
  #of U.S. election candidates
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 00-simulated_data saved and loaded
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(testthat)
library(arrow)

analysis_data_1 <- read_parquet(here::here("data", "00-simulated_data", "simulated_candidate_1.parquet"))
analysis_data_2 <- read_parquet(here::here("data", "00-simulated_data", "simulated_candidate_2.parquet"))
analysis_data_3 <- read_parquet(here::here("data", "00-simulated_data", "simulated_candidate_3.parquet"))

#### Test data ####

# Convert sample_size to integer if necessary
analysis_data_1$sample_size <- as.integer(analysis_data_1$sample_size)
analysis_data_2$sample_size <- as.integer(analysis_data_2$sample_size)
analysis_data_3$sample_size <- as.integer(analysis_data_3$sample_size)

# Define expected columns (updated to match actual columns in datasets)
expected_columns <- c("numeric_grade", "pollscore", "methodology", "transparency_score", 
                      "duration", "sample_size", "population", "ranked_choice_reallocated", 
                      "hypothetical", "score")

#### Test structure of datasets ####
test_that("Simulated datasets contain all expected columns", {
  for (data in list(analysis_data_1, analysis_data_2, analysis_data_3)) {
    expect_true(all(expected_columns %in% colnames(data)), 
                info = "Some expected columns are missing in one or more datasets.")
  }
})

#### Test data types of specific columns ####
test_that("Columns have correct data types", {
  for (data in list(analysis_data_1, analysis_data_2, analysis_data_3)) {
    if ("pollscore" %in% colnames(data)) {
      expect_true(is.numeric(data$pollscore), 
                  info = "pollscore should be numeric.")
    }
    if ("score" %in% colnames(data)) {
      expect_true(is.numeric(data$score), 
                  info = "score should be numeric.")
    }
    if ("sample_size" %in% colnames(data)) {
      expect_true(is.integer(data$sample_size), 
                  info = "sample_size should be integer.")
    }
  }
})

#### Test value ranges and logical checks ####
test_that("Value ranges for critical columns are within expected limits", {
  for (data in list(analysis_data_1, analysis_data_2, analysis_data_3)) {
    if ("score" %in% colnames(data)) {
      expect_true(all(data$score >= 0 & data$score <= 100), 
                  info = "score should be between 0 and 100.")
    }
    if ("sample_size" %in% colnames(data)) {
      expect_true(all(data$sample_size > 0), 
                  info = "sample_size should be positive.")
    }
  }
})

#### Test unique candidates ####
test_that("Each dataset contains unique poll IDs if available", {
  if ("poll_id" %in% colnames(analysis_data_3)) {
    expect_true(n_distinct(analysis_data_3$poll_id) == nrow(analysis_data_3), 
                info = "poll_id should be unique in analysis_data_3.")
  }
})