#### Preamble ####
# Purpose: use train data to train linear model of Trump and Harris
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-analysis_data saved and loaded
# Any other information needed? None


#### Workspace setup ####
library(arrow)

# Define paths to each candidate's analysis data (training and testing data)
Trump <- read_parquet("data/02-analysis_data/01-training/train_Trump.parquet")
Harris <- read_parquet("data/02-analysis_data/01-training/train_Harris.parquet")

# Function to create and save a linear model for a candidate

Trump_model <- lm(
  score ~ pollscore + transparency_score + duration + sample_size + population + hypothetical , data = Trump)
Harris_model <- lm(
  score ~ pollscore + transparency_score + duration + sample_size + population + hypothetical , data = Harris)

# Save the model
saveRDS(Trump_model, file = "models/Trump_model.rds")
saveRDS(Harris_model, file = "models/Harris_model.rds")


