#### Preamble ####
# Purpose: Cleans the raw US president rolls data by selecting columns.
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(dplyr)

clean_data <- function(input_file, output_file) {
  # Load data
  president_polls <- read.csv(input_file)
  
  # Custom function to handle two date formats
  parse_dates <- function(date_col) {
    date_col <- ifelse(grepl("^\\d{4}/\\d{1,2}/\\d{1,2}$", date_col),
                       as.Date(date_col, format = "%Y/%m/%d"),  # YYYY/MM/DD format
                       as.Date(date_col, format = "%m/%d/%y"))  # MM/DD/YY format
    return(date_col)
  }
  
  # Convert start_date and end_date columns
  president_polls$start_date <- parse_dates(president_polls$start_date)
  president_polls$end_date <- parse_dates(president_polls$end_date)
  
  # Calculate the duration column
  president_polls$duration <- as.numeric(president_polls$end_date - president_polls$start_date)
  
  # Replace blank values in the internal column with "true"
  president_polls$internal[president_polls$internal == ""] <- "true"
  
  # Replace NA values in pollscore and numeric_grade with 0
  president_polls$pollscore[is.na(president_polls$pollscore)] <- 0
  president_polls$numeric_grade[is.na(president_polls$numeric_grade)] <- 0
  
  # Select required columns, excluding "source"
  cleaned_data <- president_polls %>%
    select(pollscore, numeric_grade, duration, sample_size, population, party, 
           hypothetical, internal, pct)
  
  # Save the cleaned data to CSV
  write.csv(cleaned_data, file = output_file, row.names = FALSE)
  
  # Return the cleaned data
  return(cleaned_data)
}

# Usage example
input_file <- "data/01-raw_data/raw_data.csv"   
output_file <- "data/03-cleaned_data/cleaned_data.csv"  
cleaned_data <- clean_data(input_file, output_file)
