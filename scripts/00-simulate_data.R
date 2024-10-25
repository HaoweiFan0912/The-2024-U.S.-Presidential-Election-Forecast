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
  # then ensure the values are within the range [0, 3] and round to one decimal places
  numeric_grade = round(pmin(pmax(rnorm(500, mean = 2, sd = 1.2), 0), 3), 1),
  
  # Generate pollscore based on a normal distribution with mean -0.5 and variance 0.3,
  # then ensure the values are within the range [-1, 1] and round to one decimal place
  pollscore = round(pmin(pmax(rnorm(500, mean = -0.5, sd = sqrt(0.3)), -1), 1), 1),
  
  methodology = sample(c(
    "Online Panel", "App Panel", "IVR/Text", "Online Ad", "IVR/Online Panel/Text-to-Web",
    "IVR", "IVR/Online Panel", "Live Phone/Text-to-Web", "Live Phone", "IVR/Text-to-Web", "Probability Panel",
    "IVR/Live Phone/Text/Online Panel/Email", "Online Panel/Text-to-Web", "IVR/Live Phone/Text-to-Web", "Text",
    "Text-to-Web", "Live Phone/Online Panel/Text-to-Web", "Text-to-Web/Online Ad", "Email",
    "Live Phone/Online Panel", "Live Phone/Text-to-Web/Email/Mail-to-Web/Mail-to-Phone", "Live Phone/Online Panel/App Panel",
    "Text-to-Web/Email", "Mail-to-Web/Mail-to-Phone", "Live Phone/Online Panel/Text", "Live Phone/Email", "Live Phone/Probability Panel", "Online Panel/Probability Panel", "IVR/Live Phone/Online Panel/Text-to-Web",
    "Online Panel/Online Ad", "Live Phone/Text-to-Web/Online Ad", "Live Phone/Text/Online Panel", "IVR/Live Phone/Text",
    "IVR/Online Panel/Email", "Live Phone/Online Panel/Text-to-Web/Text", "Live Phone/Text/Online Ad",
    "IVR/Online Panel/Text-to-Web/Email", "Online Panel/Email/Text-to-Web", "Online Panel/Text",
    "Online Panel/Text-to-Web/Text", "Live Phone/Text-to-Web/Email", "Live Phone/Text", "Live Phone/Text-to-Web/App Panel",
    "Live Phone/Text-to-Web/Email/Mail-to-Web", "Email/Online Ad", "Online Panel/Email", "IVR/Live Phone/Online Panel",
    "Live Phone/Online Panel/Mail-to-Web", "IVR/Text-to-Web/Email"), 500, replace = TRUE),
  
  # Generate transparency_score based on a normal distribution with mean 6 and variance 1.5,
  # then ensure the values are within the range [1, 10], round to the nearest 0.5
  transparency_score = round(pmin(pmax(rnorm(500, mean = 6, sd = sqrt(1.5)), 1), 10) * 2) / 2,
  
  state = sample(state.abb, 500, replace = TRUE),
  
  duration = round(pmin(pmax(rnorm(500, mean = 183, sd = 100), 15), 365)),
  
  # Set start_date to be between 2023-01-01 and ensure at least 15 days interval with end_date, and end_date not later than 2024-09-09
  # start_date = as.Date("2023-01-01") + sample(0:365, 500, replace = TRUE),
  # end_date = pmin(start_date + sample(15:365, 500, replace = TRUE), as.Date("2024-09-09")),
  
  # Generate sample_size based on a normal distribution with mean 1200 and variance 5000, then round to the nearest integer
  sample_size = round(pmin(pmax(rnorm(500, mean = 1200, sd = 5000), 100), 200000)),
  
  population = sample(c("a", "v", "lv", "rv"), 500, replace = TRUE),
  
  # Partisan should be NA, otherwise the poll will be biased.
  partisan = sample(c(NA), 500, replace = TRUE),
  
  
  race_id = sample(c(8914,8765,8866,8905,8902,8869,8778,8759,8781,8820,8857,8839,
                     8872,8880,8889,8886,8811,8814,8863,8762,8823,8854,8848,8826,
                     8749,8833,8845,8892,8794,8895,8851,8842,8860,8797,8788,8837,
                     8775,8877,8768,8817,8809,8810,8755,8908,8899,8883,8806,8785,
                     8752,8791,8800,8803,8830,8911), 500, replace = TRUE),
  
  hypothetical = sample(c(TRUE, FALSE), 500, replace = TRUE),
  
  party = rep(sample(c("DEM", "REP", "GRE", "LIB", "IND", "CON", "PSL", "UNK", "OTH"), 1), 500),
  
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
  
  ifelse(simulated_candidate_1$party %in% c("DEM", "REP"), 10, 3) +
  
  ifelse(simulated_candidate_1$hypothetical, 0, 3) +
  
  simulated_candidate_1$race_id/1000 + 
  
  ifelse(simulated_candidate_1$population %in% c("a"), 7,
         ifelse(simulated_candidate_1$population %in% c("lv"), 5, 3
         )) +
  
  simulated_candidate_1$duration/100 + 
  
  ifelse(simulated_candidate_1$state %in% c("MA", "MD", "NJ", "HI", "CA", "CT", "WA", "NH", "AK", "MN"), 10, 0) +
  
  ifelse(simulated_candidate_1$methodology %in% c("Online Panel", "App Panel", "IVR/Text", "Online Ad"), 10, 7)

    
    
  
    
