#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)

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


