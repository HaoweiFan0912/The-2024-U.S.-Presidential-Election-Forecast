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


# Set a random seed for reproducibility
set.seed(123)
  
# Generate simulated data
simulated_candidate_1 <- tibble(
  poll_id = 1:500, 
  # Generate numeric_grade based on a normal distribution with mean 2 and standard deviation 1.2,
  # then ensure the values are within the range [0, 3] and round to two decimal places, then map to a range of 0 to 10
  numeric_grade = round((pmin(pmax(rnorm(500, mean = 2, sd = 1.2), 0), 3) / 3) * 10, 2),
  
  # Generate pollscore based on a normal distribution with mean -0.5 and variance 0.3,
  # then ensure the values are within the range [-1, 1] and round to one decimal place, then map to a range of 0 to 10
  pollscore = round((pmin(pmax(rnorm(500, mean = -0.5, sd = sqrt(0.3)), -1), 1) + 1) * 5, 1),
  
  methodology = sample(c("level1", "level2", "level3", "level4"), 500, replace = TRUE),
  
  # Generate transparency_score based on a normal distribution with mean 6 and variance 1.5,
  # then ensure the values are within the range [1, 10], round to the nearest 0.5, then map to a range of 0 to 10
  transparency_score = round((pmin(pmax(rnorm(500, mean = 6, sd = sqrt(1.5)), 1), 10) / 10) * 10, 1),
  
  duration = round(pmin(pmax(rnorm(500, mean = 183, sd = 100), 15), 365)),
  
  # Generate sample_size based on a normal distribution with mean 1200 and variance 5000, then round to the nearest integer
  sample_size = round(pmin(pmax(rnorm(500, mean = 1200, sd = 5000), 100), 200000)),
  
  population = sample(c("a", "v", "lv", "rv"), 500, replace = TRUE),
  
  # Set TRUE/FALSE ratio to 0.3 for the hypothetical column
  hypothetical = sample(c(TRUE, FALSE), 500, replace = TRUE, prob = c(0.3, 0.7)),
  
  score = rep(NA)
)

simulated_candidate_1$score = 
  
  simulated_candidate_1$numeric_grade + 
  
  simulated_candidate_1$pollscore + 
  
  simulated_candidate_1$transparency_score + 
  
  ifelse(simulated_candidate_1$sample_size > 8000, 10, 
         ifelse((simulated_candidate_1$sample_size >= 3000) & (simulated_candidate_1$sample_size <= 8000), 7, 
                ifelse(simulated_candidate_1$sample_size < 3000, 3, 0
                       ))) +
  
  ifelse(simulated_candidate_1$hypothetical, 0, 10) +
  
  ifelse(simulated_candidate_1$population %in% c("lv"), 10,
         ifelse(simulated_candidate_1$population %in% c("v", "rv"), 7, 4
         )) +
  
  simulated_candidate_1$duration/100 + 
  
  ifelse(simulated_candidate_1$methodology %in% c("Online Panel", "App Panel", "IVR/Text", "Online Ad"), 10, 7)

    
    
  
    
