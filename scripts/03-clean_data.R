#### Preamble ####
# Purpose: Cleans the raw US president polls data by selecting columns and scaling values.
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(janitor)  # For clean_names
library(tidyr)   # For drop_na

clean_data <- function(input_file, output_dir) {
  # Ensure output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Load data
  president_polls <- read.csv(input_file)
  
  # Clean column names
  president_polls <- janitor::clean_names(president_polls)
  
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
  president_polls$transparency_score[is.na(president_polls$transparency_score)] <- 1
  
  # Scale numeric_grade (0-3) to 0-10
  president_polls$numeric_grade <- round(president_polls$numeric_grade * (10 / 3), 1)
  
  # Scale pollscore (-1.5 to 1.7) to 0-10
  president_polls$pollscore <- round((president_polls$pollscore + 1.5) / 3.2 * 10, 1)
  
  # Scale transparency_score (1 to 10) to 0-10
  president_polls$transparency_score <- round((president_polls$transparency_score - 1) * (10 / 9), 1)
  
  # Group data by candidate_name
  candidates <- unique(president_polls$candidate_name)
  
  president_polls$Methodology <- case_when(
    president_polls$methodology %in% c(
      "Live Phone", "Live Phone/Online Panel", "Live Phone/Probability Panel", 
      "Online Panel/Probability Panel", "Probability Panel"
    ) ~ "level4",
    
    president_polls$methodology %in% c(
      "IVR/Live Phone/Online Panel", "IVR/Live Phone/Online Panel/Text-to-Web", 
      "IVR/Live Phone/Text", "IVR/Live Phone/Text-to-Web", "Live Phone/Online Panel/App Panel", 
      "Live Phone/Online Panel/Text", "Live Phone/Online Panel/Text-to-Web", 
      "Live Phone/Online Panel/Text-to-Web/Text", "Live Phone/Text", 
      "Live Phone/Text/Online Panel", "Live Phone/Text-to-Web", 
      "Live Phone/Text-to-Web/App Panel", "Online Panel", "Online Panel/Text", 
      "Online Panel/Text-to-Web", "Online Panel/Text-to-Web/Text", "Text", "Text-to-Web"
    ) ~ "level3",
    
    president_polls$methodology %in% c(
      "App Panel", "IVR", "IVR/Live Phone/Text/Online Panel/Email", "IVR/Online Panel", 
      "IVR/Online Panel/Email", "IVR/Online Panel/Text-to-Web", 
      "IVR/Online Panel/Text-to-Web/Email", "IVR/Text", "IVR/Text-to-Web", 
      "IVR/Text-to-Web/Email", "Live Phone/Email", "Live Phone/Online Panel/Mail-to-Web", 
      "Live Phone/Text/Online Ad", "Live Phone/Text-to-Web/Email", 
      "Live Phone/Text-to-Web/Email/Mail-to-Web", "Live Phone/Text-to-Web/Online Ad", 
      "Online Panel/Email", "Online Panel/Email/Text-to-Web", 
      "Online Panel/Online Ad", "Text-to-Web/Email", "Text-to-Web/Online Ad"
    ) ~ "level2",
    
    president_polls$methodology %in% c(
      "Email", "Email/Online Ad", 
      "Live Phone/Text-to-Web/Email/Mail-to-Web/Mail-to-Phone", 
      "Mail-to-Web/Mail-to-Phone", "Online Ad"
    ) ~ "level1",
  )
  
  for (candidate in candidates) {
    # Filter data for each candidate and remove rows with NA values
    candidate_data <- president_polls %>%
      filter(candidate_name == candidate) %>%
      select(poll_id, pollscore, numeric_grade, transparency_score, duration,
             sample_size, population, hypothetical, Methodology, pct) %>%
      tidyr::drop_na()  # Remove rows with any NA values
    
    # Define output file path for each candidate
    output_file <- file.path(output_dir, paste0(candidate, "_cleaned_data.csv"))
    
    # Save each candidate's cleaned data to a separate CSV
    write.csv(candidate_data, file = output_file, row.names = FALSE)
  }
  
  return(invisible())
}

# Usage example
input_file <- "data/01-raw_data/raw_data.csv"   
output_dir <- "data/03-cleaned_data/cleaned_data_by_candidate"  
cleaned_data <- clean_data(input_file, output_dir)

raw_data <- read_csv("data/01-raw_data/raw_data.csv")

candidate_ranking <- raw_data %>%
  group_by(candidate_name) %>%
  summarize(
    poll_count = n(),                    
    avg_weighted_pct = mean(poll_count * pct, na.rm = TRUE)  
  ) %>%
  arrange(desc(avg_weighted_pct)) %>%    
  slice_head(n = 3)                       

print("Top three candidates by average of poll count * pct:")
print(candidate_ranking)

# Load necessary library
library(arrow)

# Define file paths
source_folder <- "data/03-cleaned_data/cleaned_data_by_candidate/"
destination_folder <- "data/02-analysis_data/"

# Define filenames
files_to_convert <- c("Donald Trump_cleaned_data.csv", "Kamala Harris_cleaned_data.csv", "Joe Biden_cleaned_data.csv")

# Convert each cleaned data file from CSV to Parquet
for (file_name in files_to_convert) {
  csv_path <- file.path(source_folder, file_name)
  parquet_path <- file.path(destination_folder, sub(".csv$", ".parquet", file_name))  # Change .csv to .parquet
  
  # Read CSV and save as Parquet
  data <- read.csv(csv_path)
  write_parquet(data, parquet_path)
  
  message(paste("File converted to Parquet and saved to:", parquet_path))
}

# Define paths for each candidate's analysis data
candidate_data_files <- list(
  "Donald Trump" = "data/02-analysis_data/Donald Trump_cleaned_data.parquet",
  "Kamala Harris" = "data/02-analysis_data/Kamala Harris_cleaned_data.parquet",
  "Joe Biden" = "data/02-analysis_data/Joe Biden_cleaned_data.parquet"
)

# Function to split data into training (70%) and test (30%) sets
split_data <- function(data, train_ratio = 0.7) {
  set.seed(123)  # Set seed for reproducibility
  train_indices <- sample(seq_len(nrow(data)), size = floor(train_ratio * nrow(data)))
  train_data <- data[train_indices, ]
  test_data <- data[-train_indices, ]
  list(train = train_data, test = test_data)
}

# Process each candidate's data
for (candidate_name in names(candidate_data_files)) {
  # Load the data from Parquet files
  data <- read_parquet(candidate_data_files[[candidate_name]])
  
  # Split the data
  split <- split_data(data)
  
  # Define paths for saving the split data in Parquet format
  train_path <- paste0("data/02-analysis_data/", candidate_name, "_train.parquet")
  test_path <- paste0("data/02-analysis_data/", candidate_name, "_test.parquet")
  
  # Save the training and test datasets as Parquet files
  write_parquet(split$train, train_path)
  write_parquet(split$test, test_path)
  
  message(paste("Data for", candidate_name, "split into training and test sets."))
  message(paste("Training data saved to:", train_path))
  message(paste("Test data saved to:", test_path))
}
