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
  
## Generate simulated data for candidate_1
simulated_candidate_1 <- tibble(
  poll_id = 1:500, 
  # Generate numeric_grade based on a normal distribution with mean 2 and standard deviation 1.2,
  # then ensure the values are within the range [0, 3] and round to two decimal places, then map to a range of 0 to 10
  numeric_grade = round((pmin(pmax(rnorm(500, mean = 2, sd = 1.2), 0), 3) / 3) * 10, 2),
  # Generate pollscore based on a normal distribution with mean -0.5 and standard deviation 0.3,
  # then ensure the values are within the range [-1, 1] and round to one decimal place, then map to a range of 0 to 10
  pollscore = round((pmin(pmax(rnorm(500, mean = -0.5, sd = 0.3), -1), 1) + 1) * 5, 1),
  # The methodology is divided into four levels: level 1 represents the least reliable type of methodology, while level 4 represents the most reliable.
  methodology = sample(c("level1", "level2", "level3", "level4"), 500, replace = TRUE),
  # Generate transparency_score based on a normal distribution with mean 6 and standard deviation 1.5,
  # then ensure the values are within the range [1, 10], round to the nearest 0.5, then map to a range of 0 to 10
  transparency_score = round((pmin(pmax(rnorm(500, mean = 6, sd = 1.5), 1), 10) / 10) * 10, 1),
  # The duration of this poll in days. Duration based on a normal distribution with mean 183 and standard deviation 100,
  duration = round(pmin(pmax(rnorm(500, mean = 183, sd = 100), 15), 365)),
  # Generate sample_size based on a normal distribution with mean 1200 and standard deviation 5000, then round to the nearest integer
  sample_size = round(pmin(pmax(rnorm(500, mean = 1200, sd = 5000), 100), 200000)),
  # Population types：Likely Voters，Registered Voters, Voters, Adult
  population = sample(c("a", "v", "lv", "rv"), 500, replace = TRUE),
  # Set TRUE/FALSE ratio to 0.9 for the hypothetical column
  ranked_choice_reallocated= sample(c(TRUE, FALSE), 500, replace = TRUE, prob = c(0.9, 0.1)),
  # Set TRUE/FALSE ratio to 0.3 for the hypothetical column
  hypothetical = sample(c(TRUE, FALSE), 500, replace = TRUE, prob = c(0.3, 0.7)),
  # Use NA as a placeholder for the score.
  score = rep(NA)
)

# Calculate the score based on other variables and the corresponding assumed weights.
simulated_candidate_1$score = 
  round(
  # Assume that numeric_grade, pollscore, and transparency_score are equally important, and their ranges are all from 0 to 10.
  simulated_candidate_1$numeric_grade + 
  (10 - simulated_candidate_1$pollscore) + # Because pollscore is the less the better
  simulated_candidate_1$transparency_score + 
  # When sample size > 800, the score + 10. When 300 <= sample size <= 800, the score +7. Other wise score +3
  ifelse(simulated_candidate_1$sample_size > 8000, 10, 
         ifelse((simulated_candidate_1$sample_size >= 3000) & (simulated_candidate_1$sample_size <= 8000), 7, 
                ifelse(simulated_candidate_1$sample_size < 3000, 3, 0
                       ))) +
  # When the poll is reallocated, it get 0 in this factor. Otherwise it will get 10.
  ifelse(simulated_candidate_1$ranked_choice_reallocated, 0, 10) +
  # When the poll is based on hypothtical, it get 0 in this factor. Otherwise it will get 10.
  ifelse(simulated_candidate_1$hypothetical, 0, 10) +
  # Assume likely voter is the best population, voter and registered voter are worse, and adult is the worst.
  ifelse(simulated_candidate_1$population %in% c("lv"), 10,
         ifelse(simulated_candidate_1$population %in% c("v", "rv"), 7, 4
         )) +
  # the duration is longer the better by assumption.
  simulated_candidate_1$duration/100 + 
  # If methodology is in level4 score +10, in level3 score +7, in level2 score +4, else +1
  ifelse(simulated_candidate_1$methodology %in% c("level4"), 10, 
         ifelse(simulated_candidate_1$methodology %in% c("level3"), 7, 
                ifelse(simulated_candidate_1$methodology %in% c("level2"), 4, 1
                )))
  , 2)

## Generate simulated data for candidate_2
simulated_candidate_2 <- tibble(
  poll_id = 1:500, 
  # Generate numeric_grade based on a normal distribution with mean 2 and standard deviation 1.2,
  # then ensure the values are within the range [0, 3] and round to two decimal places, then map to a range of 0 to 10
  numeric_grade = round((pmin(pmax(rnorm(500, mean = 2, sd = 1.2), 0), 3) / 3) * 10, 2),
  # Generate pollscore based on a normal distribution with mean -0.5 and standard deviation 0.3,
  # then ensure the values are within the range [-1, 1] and round to one decimal place, then map to a range of 0 to 10
  pollscore = round((pmin(pmax(rnorm(500, mean = -0.5, sd = 0.3), -1), 1) + 1) * 5, 1),
  # The methodology is divided into four levels: level 1 represents the least reliable type of methodology, while level 4 represents the most reliable.
  methodology = sample(c("level1", "level2", "level3", "level4"), 500, replace = TRUE),
  # Generate transparency_score based on a normal distribution with mean 6 and standard deviation 1.5,
  # then ensure the values are within the range [1, 10], round to the nearest 0.5, then map to a range of 0 to 10
  transparency_score = round((pmin(pmax(rnorm(500, mean = 6, sd = 1.5), 1), 10) / 10) * 10, 1),
  # The duration of this poll in days. Duration based on a normal distribution with mean 183 and standard deviation 100,
  duration = round(pmin(pmax(rnorm(500, mean = 183, sd = 100), 15), 365)),
  # Generate sample_size based on a normal distribution with mean 1200 and standard deviation 5000, then round to the nearest integer
  sample_size = round(pmin(pmax(rnorm(500, mean = 1200, sd = 5000), 100), 200000)),
  # Population types：Likely Voters，Registered Voters, Voters, Adult
  population = sample(c("a", "v", "lv", "rv"), 500, replace = TRUE),
  # Set TRUE/FALSE ratio to 0.9 for the hypothetical column
  ranked_choice_reallocated= sample(c(TRUE, FALSE), 500, replace = TRUE, prob = c(0.9, 0.1)),
  # Set TRUE/FALSE ratio to 0.3 for the hypothetical column
  hypothetical = sample(c(TRUE, FALSE), 500, replace = TRUE, prob = c(0.3, 0.7)),
  # Use NA as a placeholder for the score.
  score = rep(NA)
)

# Calculate the score based on other variables and the corresponding assumed weights.
simulated_candidate_2$score = 
  round(
    # Assume that numeric_grade, pollscore, and transparency_score are equally important, and their ranges are all from 0 to 10.
    simulated_candidate_2$numeric_grade + 
      (10 - simulated_candidate_2$pollscore) + # Because pollscore is the less the better
      simulated_candidate_2$transparency_score + 
      # When sample size > 800, the score + 10. When 300 <= sample size <= 800, the score +7. Other wise score +3
      ifelse(simulated_candidate_2$sample_size > 8000, 10, 
             ifelse((simulated_candidate_2$sample_size >= 3000) & (simulated_candidate_2$sample_size <= 8000), 7, 
                    ifelse(simulated_candidate_2$sample_size < 3000, 3, 0
                    ))) +
      # When the poll is reallocated, it get 0 in this factor. Otherwise it will get 10.
      ifelse(simulated_candidate_2$ranked_choice_reallocated, 0, 10) +
      # When the poll is based on hypothtical, it get 0 in this factor. Otherwise it will get 10.
      ifelse(simulated_candidate_2$hypothetical, 0, 10) +
      # Assume likely voter is the best population, voter and registered voter are worse, and adult is the worst.
      ifelse(simulated_candidate_2$population %in% c("lv"), 10,
             ifelse(simulated_candidate_2$population %in% c("v", "rv"), 7, 4
             )) +
      # the duration is longer the better by assumption.
      simulated_candidate_2$duration/100 + 
      # If methodology is in level4 score +10, in level3 score +7, in level2 score +4, else +1
      ifelse(simulated_candidate_2$methodology %in% c("level4"), 10, 
             ifelse(simulated_candidate_2$methodology %in% c("level3"), 7, 
                    ifelse(simulated_candidate_2$methodology %in% c("level2"), 4, 1
                    )))
    , 2)
## Generate simulated data for candidate_3
simulated_candidate_3 <- tibble(
  poll_id = 1:500, 
  # Generate numeric_grade based on a normal distribution with mean 2 and standard deviation 1.2,
  # then ensure the values are within the range [0, 3] and round to two decimal places, then map to a range of 0 to 10
  numeric_grade = round((pmin(pmax(rnorm(500, mean = 2, sd = 1.2), 0), 3) / 3) * 10, 2),
  # Generate pollscore based on a normal distribution with mean -0.5 and standard deviation 0.3,
  # then ensure the values are within the range [-1, 1] and round to one decimal place, then map to a range of 0 to 10
  pollscore = round((pmin(pmax(rnorm(500, mean = -0.5, sd = 0.3), -1), 1) + 1) * 5, 1),
  # The methodology is divided into four levels: level 1 represents the least reliable type of methodology, while level 4 represents the most reliable.
  methodology = sample(c("level1", "level2", "level3", "level4"), 500, replace = TRUE),
  # Generate transparency_score based on a normal distribution with mean 6 and standard deviation 1.5,
  # then ensure the values are within the range [1, 10], round to the nearest 0.5, then map to a range of 0 to 10
  transparency_score = round((pmin(pmax(rnorm(500, mean = 6, sd = 1.5), 1), 10) / 10) * 10, 1),
  # The duration of this poll in days. Duration based on a normal distribution with mean 183 and standard deviation 100,
  duration = round(pmin(pmax(rnorm(500, mean = 183, sd = 100), 15), 365)),
  # Generate sample_size based on a normal distribution with mean 1200 and standard deviation 5000, then round to the nearest integer
  sample_size = round(pmin(pmax(rnorm(500, mean = 1200, sd = 5000), 100), 200000)),
  # Population types：Likely Voters，Registered Voters, Voters, Adult
  population = sample(c("a", "v", "lv", "rv"), 500, replace = TRUE),
  # Set TRUE/FALSE ratio to 0.9 for the hypothetical column
  ranked_choice_reallocated = sample(c(TRUE, FALSE), 500, replace = TRUE, prob = c(0.9, 0.1)),
  # Set TRUE/FALSE ratio to 0.3 for the hypothetical column
  hypothetical = sample(c(TRUE, FALSE), 500, replace = TRUE, prob = c(0.3, 0.7)),
  # Use NA as a placeholder for the score.
  score = rep(NA)
)

# Calculate the score based on other variables and the corresponding assumed weights.
simulated_candidate_3$score = 
  round(
    # Assume that numeric_grade, pollscore, and transparency_score are equally important, and their ranges are all from 0 to 10.
    simulated_candidate_3$numeric_grade + 
      (10 - simulated_candidate_3$pollscore) + # Because pollscore is the less the better
      simulated_candidate_3$transparency_score + 
      # When sample size > 800, the score + 10. When 300 <= sample size <= 800, the score +7. Other wise score +3
      ifelse(simulated_candidate_3$sample_size > 8000, 10, 
             ifelse((simulated_candidate_3$sample_size >= 3000) & (simulated_candidate_3$sample_size <= 8000), 7, 
                    ifelse(simulated_candidate_3$sample_size < 3000, 3, 0
                    ))) +
      # When the poll is reallocated, it get 0 in this factor. Otherwise it will get 10.
      ifelse(simulated_candidate_3$ranked_choice_reallocated, 0, 10) +
      # When the poll is based on hypothtical, it get 0 in this factor. Otherwise it will get 10.
      ifelse(simulated_candidate_3$hypothetical, 0, 10) +
      # Assume likely voter is the best population, voter and registered voter are worse, and adult is the worst.
      ifelse(simulated_candidate_3$population %in% c("lv"), 10,
             ifelse(simulated_candidate_3$population %in% c("v", "rv"), 7, 4
             )) +
      # the duration is longer the better by assumption.
      simulated_candidate_3$duration/100 + 
      # If methodology is in level4 score +10, in level3 score +7, in level2 score +4, else +1
      ifelse(simulated_candidate_3$methodology %in% c("level4"), 10, 
             ifelse(simulated_candidate_3$methodology %in% c("level3"), 7, 
                    ifelse(simulated_candidate_3$methodology %in% c("level2"), 4, 1
                    )))
    , 2)
   
#### Save data ####
write_parquet(simulated_candidate_1, "data/00-simulated_data/simulated_candidate_1.parquet") 
write_parquet(simulated_candidate_2, "data/00-simulated_data/simulated_candidate_2.parquet") 
write_parquet(simulated_candidate_3, "data/00-simulated_data/simulated_candidate_3.parquet") 
