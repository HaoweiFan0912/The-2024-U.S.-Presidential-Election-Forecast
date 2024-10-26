#### Preamble ####
# Purpose: Illustrate and save model data
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-analysis_data saved and loaded
# Any other information needed? None


library(tidyverse)
library(patchwork) # For combining plots

# Create models directory if it doesn't exist
if (!dir.exists("models")) {
  dir.create("models")
}

# Load data for each candidate
donald_trump_data <- read_csv("data/02-analysis_data/Donald Trump_cleaned_data.csv") 
joe_biden_data <- read_csv("data/02-analysis_data/Joe Biden_cleaned_data.csv") 
kamala_harris_data <- read_csv("data/02-analysis_data/Kamala Harris_cleaned_data.csv") 

# Define a function to build, summarize, and save the model for a given dataset
build_and_save_model <- function(data, candidate_name, file_path) {
  # Fit the linear model with pct as the dependent variable
  model <- lm(pct ~ pollscore + numeric_grade + transparency_score + duration 
              + sample_size + population + hypothetical + Methodology, data = data)
  message(paste("Model summary for", candidate_name))
  print(summary(model))
  
  # Save the model as an .rds file
  saveRDS(model, file = file_path)
  message(paste("Model saved to", file_path))
  
  return(model)
}

# Function to plot actual vs. predicted values and residuals for a given model
plot_model <- function(model, data, candidate_name) {
  # Add predictions and residuals to the data
  data <- data %>%
    mutate(predicted_pct = predict(model, data),  # Predicted pct
           residuals = pct - predicted_pct)       # Residuals
  
  # Plot 1: Actual vs Predicted values
  p1 <- ggplot(data, aes(x = predicted_pct, y = pct)) +
    geom_point(color = "blue", alpha = 0.5) +
    geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
    labs(title = paste("Actual vs Predicted for", candidate_name),
         x = "Predicted pct", y = "Actual pct") +
    theme_minimal()
  
  # Plot 2: Residuals vs Predicted values
  p2 <- ggplot(data, aes(x = predicted_pct, y = residuals)) +
    geom_point(color = "purple", alpha = 0.5) +
    geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
    labs(title = paste("Residuals vs Predicted for", candidate_name),
         x = "Predicted pct", y = "Residuals") +
    theme_minimal()
  
  # Combine and display the plots
  combined_plot <- p1 / p2
  print(combined_plot)
}

# Build, visualize, and save models for each candidate
trump_model <- build_and_save_model(donald_trump_data, "Donald Trump", "models/Trump_model.rds")
plot_model(trump_model, donald_trump_data, "Donald Trump")

biden_model <- build_and_save_model(joe_biden_data, "Joe Biden", "models/Biden_model.rds")
plot_model(biden_model, joe_biden_data, "Joe Biden")

harris_model <- build_and_save_model(kamala_harris_data, "Kamala Harris", "models/Harris_model.rds")
plot_model(harris_model, kamala_harris_data, "Kamala Harris")
