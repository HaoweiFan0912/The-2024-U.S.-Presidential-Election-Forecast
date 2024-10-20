#### Preamble ####
# Purpose: Simulates a dataset of US president rolls
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Setup ####
# Load required libraries
library(tidyverse)

simulate_data <- function(n) {
  # Set a random seed for reproducibility
  set.seed(123)
  
  # Generate simulated data
  simulated_data <- data.frame(
    pollscore = round(rnorm(n, mean = 0, sd = 0.5), 1),  # Normal distribution around 0, rounded to 1 decimal
    numeric_grade = round(rnorm(n, mean = 2, sd = 1), 1),  # Normal distribution around 2, rounded to 1 decimal
    duration = sample(2:35, n, replace = TRUE),  # Random duration between 2 and 35 days
    sample_size = sample(400:1250, n, replace = TRUE),  # Random sample size between 400 and 1250
    population = sample(c("lv", "rv"), n, replace = TRUE),  # Randomly choosing "lv" or "rv"
    party = sample(c("DEM", "REP"), n, replace = TRUE),  # Randomly choosing party
    hypothetical = sample(c("false", "true"), n, replace = TRUE),  # Randomly choosing hypothetical status
    internal = sample(c("false", "true"), n, replace = TRUE),  # Randomly choosing internal status
    pct = round(runif(n, min = 30, max = 70), 1)  # Uniform distribution for pct between 30 and 70, rounded to 1 decimal
  )
  
  # Return the simulated data
  return(simulated_data)
}

# Usage example to simulate 100 rows of data
simulated_data <- simulate_data(100)

# Save the simulated data to CSV
output_simulated_file <- "data/00-simulated_data/simulated_data.csv"
write.csv(simulated_data, file = output_simulated_file, row.names = FALSE)


