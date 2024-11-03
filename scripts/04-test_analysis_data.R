#### Preamble ####
# Purpose: test on the analysis data for validation
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-analysis_data saved and loaded
# Any other information needed? None



#### Workspace setup ####

# Load necessary libraries
library(tidyverse)
library(testthat)
library(arrow)  # For reading Parquet files
library(here)

data <- read_csv("data/02-analysis_data/analysis_data.csv")


#### Test data ####

