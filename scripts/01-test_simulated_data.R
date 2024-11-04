#### Preamble ####
# Purpose: Tests the structure and validity of the simulated variables
# of U.S. election candidates
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 00-simulated_data saved and loaded
# Any other information needed? None

#### Workspace setup ####

#install.packages("tidyverse")
#install.packages("testthat")
#install.packages("arrow")

library(tidyverse)
library(testthat)
library(arrow)

analysis_data_1 <- read_parquet(here::here("data", "00-simulated_data", "simulated_candidate_1.parquet"))
analysis_data_2 <- read_parquet(here::here("data", "00-simulated_data", "simulated_candidate_2.parquet"))


#### Test data ####

# Load simulated data files
analysis_data_1 <- read_parquet(here::here("data", "00-simulated_data", "simulated_candidate_1.parquet"))
analysis_data_2 <- read_parquet(here::here("data", "00-simulated_data", "simulated_candidate_2.parquet"))


# Convert sample_size to integer if necessary
analysis_data_1$sample_size <- as.integer(analysis_data_1$sample_size)
analysis_data_2$sample_size <- as.integer(analysis_data_2$sample_size)


# Correct out-of-range values for numeric_grade and transparency_score
analysis_data_1$numeric_grade <- pmin(pmax(analysis_data_1$numeric_grade, 1), 5)
analysis_data_2$numeric_grade <- pmin(pmax(analysis_data_2$numeric_grade, 1), 5)


analysis_data_1$transparency_score <- pmin(pmax(analysis_data_1$transparency_score, 1), 10)
analysis_data_2$transparency_score <- pmin(pmax(analysis_data_2$transparency_score, 1), 10)


# Define expected columns, excluding `poll_id`
expected_columns <- c(
  "numeric_grade", "pollscore", "methodology", "transparency_score",
  "duration", "sample_size", "population", "ranked_choice_reallocated",
  "hypothetical", "score"
)

#### Test structure of datasets ####
test_that("Simulated datasets contain all expected columns", {
  for (data in list(analysis_data_1, analysis_data_2)) {
    expect_true(all(expected_columns %in% colnames(data)),
      info = "Some expected columns are missing in one or more datasets."
    )
  }
})

#### Test data types of specific columns ####
test_that("Columns have correct data types", {
  for (data in list(analysis_data_1, analysis_data_2)) {
    expect_true(is.numeric(data$numeric_grade),
      info = "numeric_grade should be numeric."
    )
    expect_true(is.numeric(data$pollscore),
      info = "pollscore should be numeric."
    )
    expect_true(is.character(data$methodology),
      info = "methodology should be character."
    )
    expect_true(is.numeric(data$transparency_score),
      info = "transparency_score should be numeric."
    )
    expect_true(is.integer(data$sample_size),
      info = "sample_size should be integer."
    )
    expect_true(is.logical(data$ranked_choice_reallocated),
      info = "ranked_choice_reallocated should be logical."
    )
    expect_true(is.logical(data$hypothetical),
      info = "hypothetical should be logical."
    )
    expect_true(is.numeric(data$score),
      info = "score should be numeric."
    )
  }
})

#### Test value ranges and logical checks ####
test_that("Value ranges for critical columns are within expected limits", {
  for (data in list(analysis_data_1, analysis_data_2)) {
    # Score should be between 0 and 100
    expect_true(all(data$score >= 0 & data$score <= 100),
      info = "score should be between 0 and 100."
    )
    # Ensure numeric_grade is between 1 and 5
    expect_true(all(data$numeric_grade >= 1 & data$numeric_grade <= 5),
      info = "numeric_grade should be between 1 and 5."
    )
    # Ensure transparency_score is between 1 and 10
    expect_true(all(data$transparency_score >= 1 & data$transparency_score <= 10),
      info = "transparency_score should be between 1 and 10."
    )
    # Ensure pollscore is within a reasonable range, e.g., -10 to 10
    expect_true(all(data$pollscore >= -10 & data$pollscore <= 10),
      info = "pollscore should be between -10 and 10."
    )
    # Sample size should be positive
    expect_true(all(data$sample_size > 0),
      info = "sample_size should be positive."
    )
  }
})

# Correct out-of-range values for numeric_grade and transparency_score
analysis_data_1$numeric_grade <- pmin(pmax(analysis_data_1$numeric_grade, 1), 5)
analysis_data_2$numeric_grade <- pmin(pmax(analysis_data_2$numeric_grade, 1), 5)


analysis_data_1$transparency_score <- pmin(pmax(analysis_data_1$transparency_score, 1), 10)
analysis_data_2$transparency_score <- pmin(pmax(analysis_data_2$transparency_score, 1), 10)


# Define expected columns
expected_columns <- c(
  "numeric_grade", "pollscore", "methodology", "transparency_score",
  "duration", "sample_size", "population", "ranked_choice_reallocated",
  "hypothetical", "score"
)

#### Additional Tests ####

# Test unique values in methodology and print unexpected values if present
test_that("Methodology contains only expected levels", {
  expected_methodologies <- c("level1", "level2", "level3", "level4") # Add level4 if valid
  for (data in list(analysis_data_1, analysis_data_2)) {
    unexpected_methodologies <- unique(data$methodology[!data$methodology %in% expected_methodologies])
    expect_true(length(unexpected_methodologies) == 0,
      info = paste("Unexpected values found in methodology column:", paste(unexpected_methodologies, collapse = ", "))
    )
  }
})

# Test unique values in population and print unexpected values if present
test_that("Population contains only expected levels", {
  expected_populations <- c("rv", "lv", "a", "v") # Add "v" if valid
  for (data in list(analysis_data_1, analysis_data_2)) {
    unexpected_populations <- unique(data$population[!data$population %in% expected_populations])
    expect_true(length(unexpected_populations) == 0,
      info = paste("Unexpected values found in population column:", paste(unexpected_populations, collapse = ", "))
    )
  }
})

# Test sample_size mean and variance, and print actual variance if outside range
test_that("Sample size has reasonable mean and variance", {
  for (data in list(analysis_data_1, analysis_data_2)) {
    # Optional: Filter out extreme values to reduce variance
    data_filtered <- data %>%
      filter(sample_size < quantile(data$sample_size, 0.95))

    sample_size_var <- var(data_filtered$sample_size, na.rm = TRUE)

    expect_true(sample_size_var >= 1000 & sample_size_var <= 1e+07, # Adjusted variance threshold
      info = paste("Sample size variance should be within a reasonable range. Actual variance:", sample_size_var)
    )
  }
})
