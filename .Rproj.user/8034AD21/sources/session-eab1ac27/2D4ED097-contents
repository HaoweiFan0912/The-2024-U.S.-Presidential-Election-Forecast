#### Preamble ####
# Purpose: Illustrate and save model data
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-analysis_data saved and loaded
# Any other information needed? None


library(tidyverse)
library(rstanarm)  # For Bayesian modeling

# Define paths to each candidate's analysis data (training and testing data)
candidate_train_files <- list(
  "Donald Trump" = "data/02-analysis_data/Donald Trump_train.csv",
  "Kamala Harris" = "data/02-analysis_data/Kamala Harris_train.csv",
  "Joe Biden" = "data/02-analysis_data/Joe Biden_train.csv"
)

candidate_test_files <- list(
  "Donald Trump" = "data/02-analysis_data/Donald Trump_test.csv",
  "Kamala Harris" = "data/02-analysis_data/Kamala Harris_test.csv",
  "Joe Biden" = "data/02-analysis_data/Joe Biden_test.csv"
)

# Ensure a 'models' folder exists for saving model files
if (!dir.exists("models")) {
  dir.create("models")
}

# Function to create and save a linear model for a candidate
create_and_save_linear_model <- function(data, candidate_name) {
  # Fit a linear model
  linear_model <- lm(
    pct ~ pollscore + numeric_grade + transparency_score + duration + sample_size + population + hypothetical + Methodology,
    data = data
  )
  
  # Save the model
  saveRDS(linear_model, file = paste0("models/", candidate_name, "_linear_model.rds"))
  message(paste("Linear model saved as", paste0(candidate_name, "_linear_model.rds")))
  
  return(linear_model)
}

# Function to create and save a Bayesian model for a candidate, excluding constant variables
create_and_save_bayesian_model <- function(data, candidate_name) {
  constant_vars <- names(data)[sapply(data, function(x) length(unique(x)) == 1)]
  formula <- as.formula(
    paste("pct ~", paste(setdiff(names(data), c("pct", "poll_id", constant_vars)), collapse = " + "))
  )
  
  bayesian_model <- stan_glm(
    formula,
    data = data,
    family = gaussian(),
    prior = normal(0, 1),
    chains = 4,
    iter = 2000,
    seed = 123
  )
  
  saveRDS(bayesian_model, file = paste0("models/", candidate_name, "_Bayesian_model.rds"))
  message(paste("Bayesian model saved as", paste0(candidate_name, "_Bayesian_model.rds")))
  
  return(bayesian_model)
}

# Function to evaluate models on RMSE, R-squared, and Adjusted R-squared
evaluate_model <- function(model, test_data, candidate_name, model_type) {
  # Predict on test data
  predicted_values <- predict(model, newdata = test_data)
  actual_values <- test_data$pct
  
  # Calculate RMSE
  rmse <- sqrt(mean((predicted_values - actual_values)^2))
  
  # Calculate R-squared
  ss_total <- sum((actual_values - mean(actual_values))^2)
  ss_residual <- sum((actual_values - predicted_values)^2)
  r_squared <- 1 - (ss_residual / ss_total)
  
  # Calculate Adjusted R-squared
  n <- nrow(test_data)
  p <- length(coef(model)) - 1  # Number of predictors
  adj_r_squared <- 1 - ((1 - r_squared) * (n - 1) / (n - p - 1))
  
  # Return a summary
  tibble(
    Candidate = candidate_name,
    Model_Type = model_type,
    RMSE = rmse,
    R_squared = r_squared,
    Adjusted_R_squared = adj_r_squared,
    Mean_Predicted_pct = mean(predicted_values)  # Calculate mean prediction
  )
}

# Store evaluation results
evaluation_results <- list()

# Process each candidate
for (candidate_name in names(candidate_train_files)) {
  # Load training and test data
  train_data <- read_csv(candidate_train_files[[candidate_name]])
  test_data <- read_csv(candidate_test_files[[candidate_name]])
  
  # Create, save, and evaluate the linear model
  linear_model <- create_and_save_linear_model(train_data, candidate_name)
  linear_evaluation <- evaluate_model(linear_model, test_data, candidate_name, "Linear")
  evaluation_results[[paste(candidate_name, "Linear")]] <- linear_evaluation
  
  # Create, save, and evaluate the Bayesian model
  bayesian_model <- create_and_save_bayesian_model(train_data, candidate_name)
  bayesian_prediction <- posterior_predict(bayesian_model, newdata = test_data)
  bayesian_prediction_mean <- apply(bayesian_prediction, 2, mean)
  
  # Create evaluation tibble with mean prediction for Bayesian model
  bayesian_evaluation <- tibble(
    Candidate = candidate_name,
    Model_Type = "Bayesian",
    RMSE = sqrt(mean((bayesian_prediction_mean - test_data$pct)^2)),
    R_squared = cor(test_data$pct, bayesian_prediction_mean)^2,  # Simplified R-squared calculation
    Adjusted_R_squared = 1 - (1 - cor(test_data$pct, bayesian_prediction_mean)^2) * ((nrow(test_data) - 1) / (nrow(test_data) - length(coef(bayesian_model)) - 1)),
    Mean_Predicted_pct = mean(bayesian_prediction_mean)
  )
  evaluation_results[[paste(candidate_name, "Bayesian")]] <- bayesian_evaluation
}

# Combine evaluation results into a data frame
evaluation_results_df <- bind_rows(evaluation_results)

# Print expanded evaluation results
print("Expanded Model Evaluation on Test Data (with R-squared, Adjusted R-squared, and Mean Predicted pct):")
print(evaluation_results_df)