#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 26 September 2024 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]



#### Workspace setup ####

# Load necessary libraries
library(tidyverse)
library(testthat)
library(arrow)  # For reading Parquet files
library(here)

data <- read_csv("data/02-analysis_data/analysis_data.csv")


#### Test data ####

