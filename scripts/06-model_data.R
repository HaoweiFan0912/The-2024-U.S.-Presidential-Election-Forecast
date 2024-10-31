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
candidate_data_files <- list(
  "Donald Trump" = "data/02-analysis_data/01-trianing/train_Trump.parquet",
  "Kamala Harris" = "data/02-analysis_data/01-trianing/train_Harris.parquet",
  "Ron DeSantis" = "data/02-analysis_data/01-trianing/train_DeSantis.parquet"
)

########################xiamian
