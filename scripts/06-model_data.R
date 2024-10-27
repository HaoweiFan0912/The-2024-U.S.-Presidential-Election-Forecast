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

# Define paths to each candidate's data
candidate_data_files <- list(
  "Donald Trump" = "data/02-analysis_data/Donald Trump_cleaned_data.csv",
  "Kamala Harris" = "data/02-analysis_data/Kamala Harris_cleaned_data.csv",
  "Joe Biden" = "data/02-analysis_data/Joe Biden_cleaned_data.csv"
)

# Ensure a 'models' folder exists for saving model files
if (!dir.exists("models")) {
  dir.create("models")
}

# Representative data for predictions (assuming representative_data_for_prediction is already created)

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

# Function to create and save a Bayesian model for a candidate, excluding constant variables and poll_id
create_and_save_bayesian_model <- function(data, candidate_name) {
  # Exclude constant variables and poll_id
  constant_vars <- names(data)[sapply(data, function(x) length(unique(x)) == 1)]
  formula <- as.formula(
    paste("pct ~", paste(setdiff(names(data), c("pct", "poll_id", constant_vars)), collapse = " + "))
  )
  
  # Fit a Bayesian model
  bayesian_model <- stan_glm(
    formula,
    data = data,
    family = gaussian(),
    prior = normal(0, 1),
    chains = 4,
    iter = 2000,
    seed = 123
  )
  
  # Save the model
  saveRDS(bayesian_model, file = paste0("models/", candidate_name, "_Bayesian_model.rds"))
  message(paste("Bayesian model saved as", paste0(candidate_name, "_Bayesian_model.rds")))
  
  return(bayesian_model)
}

# Function to predict using a model and representative values
predict_with_model <- function(model, representative_data, candidate_name) {
  prediction_input <- representative_data %>%
    filter(Candidate == candidate_name) %>%
    select(-Candidate)
  
  predicted_values <- predict(model, newdata = prediction_input)
  
  prediction_summary <- tibble(
    Candidate = candidate_name,
    Predicted_pct = mean(predicted_values)
  )
  
  return(prediction_summary)
}

# Function to predict using a Bayesian model with posterior prediction and summarize results
predict_with_bayesian_model <- function(bayesian_model, representative_data, candidate_name) {
  prediction_input <- representative_data %>%
    filter(Candidate == candidate_name) %>%
    select(-Candidate)
  
  predicted_values <- posterior_predict(bayesian_model, newdata = prediction_input)
  
  prediction_summary <- tibble(
    Candidate = candidate_name,
    Predicted_pct_mean = mean(predicted_values),
    Predicted_pct_lower = quantile(predicted_values, 0.025),
    Predicted_pct_upper = quantile(predicted_values, 0.975)
  )
  
  return(prediction_summary)
}

# Generate models, save them, and get predictions for each candidate
linear_predictions <- list()
bayesian_predictions <- list()

for (candidate_name in names(candidate_data_files)) {
  candidate_data <- read_csv(candidate_data_files[[candidate_name]])
  
  # Create, save, and predict with the linear model
  linear_model <- create_and_save_linear_model(candidate_data, candidate_name)
  linear_prediction <- predict_with_model(linear_model, representative_data_for_prediction, candidate_name)
  linear_predictions[[candidate_name]] <- linear_prediction
  
  # Create, save, and predict with the Bayesian model
  bayesian_model <- create_and_save_bayesian_model(candidate_data, candidate_name)
  bayesian_prediction <- predict_with_bayesian_model(bayesian_model, representative_data_for_prediction, candidate_name)
  bayesian_predictions[[candidate_name]] <- bayesian_prediction
}

# Combine predictions into data frames for printing
linear_predictions_df <- bind_rows(linear_predictions)
bayesian_predictions_df <- bind_rows(bayesian_predictions)

# Print linear model predictions
print("Linear Model Predictions:")
print(linear_predictions_df)

# Print Bayesian model predictions
print("Bayesian Model Predictions:")
print(bayesian_predictions_df)
