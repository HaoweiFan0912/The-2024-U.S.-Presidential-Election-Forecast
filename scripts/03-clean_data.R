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
library(lubridate)
library(arrow)

set.seed(123)  # Set seed for reproducibility
raw_data <- read_csv("data/01-raw_data/raw_data.csv")

# Step 1: Remove variables with more than 40% NA values
threshold <- 0.4 * nrow(raw_data)
raw_data_cleaned <- raw_data %>%
  select_if(~sum(is.na(.)) <= threshold)

# Step 2: Remove variables with all identical values
raw_data_cleaned <- raw_data_cleaned %>%
  select_if(~is.numeric(.) || n_distinct(.) > 1)

# Step 3: Remove duplicated, unrelated variables
raw_data_cleaned <- raw_data_cleaned %>%
  dplyr::select(-any_of(c("pollster_id", "pollster", "display_name", "pollster_rating_id", "pollster_rating_name", 
                          "question_id", "population_full", "created_at", "url", "url_article", "race_id", 
                          "candidate_id", "candidate_name", "party", "seat_number", "cycle"))) 
  
# Step 4: Create a new variable called 'duration' (days difference between start_date and end_date) and remove 'start_date' and 'end_date'
raw_data_cleaned$duration <- as.numeric(mdy(raw_data_cleaned$end_date)-mdy(raw_data_cleaned$start_date))
raw_data_cleaned <- raw_data_cleaned %>%
  dplyr::select(-start_date, -end_date)

# Step 5: Group methodology by level
raw_data_cleaned$methodology <- case_when(
  raw_data_cleaned$methodology %in% c(
    "Live Phone", "Live Phone/Online Panel", "Live Phone/Probability Panel", 
    "Online Panel/Probability Panel", "Probability Panel"
  ) ~ "level4",
  
  raw_data_cleaned$methodology %in% c(
    "IVR/Live Phone/Online Panel", "IVR/Live Phone/Online Panel/Text-to-Web", 
    "IVR/Live Phone/Text", "IVR/Live Phone/Text-to-Web", "Live Phone/Online Panel/App Panel", 
    "Live Phone/Online Panel/Text", "Live Phone/Online Panel/Text-to-Web", 
    "Live Phone/Online Panel/Text-to-Web/Text", "Live Phone/Text", 
    "Live Phone/Text/Online Panel", "Live Phone/Text-to-Web", 
    "Live Phone/Text-to-Web/App Panel", "Online Panel", "Online Panel/Text", 
    "Online Panel/Text-to-Web", "Online Panel/Text-to-Web/Text", "Text", "Text-to-Web"
  ) ~ "level3",
  
  raw_data_cleaned$methodology %in% c(
    "App Panel", "IVR", "IVR/Live Phone/Text/Online Panel/Email", "IVR/Online Panel", 
    "IVR/Online Panel/Email", "IVR/Online Panel/Text-to-Web", 
    "IVR/Online Panel/Text-to-Web/Email", "IVR/Text", "IVR/Text-to-Web", 
    "IVR/Text-to-Web/Email", "Live Phone/Email", "Live Phone/Online Panel/Mail-to-Web", 
    "Live Phone/Text/Online Ad", "Live Phone/Text-to-Web/Email", 
    "Live Phone/Text-to-Web/Email/Mail-to-Web", "Live Phone/Text-to-Web/Online Ad", 
    "Online Panel/Email", "Online Panel/Email/Text-to-Web", 
    "Online Panel/Online Ad", "Text-to-Web/Email", "Text-to-Web/Online Ad"
  ) ~ "level2",
  
  raw_data_cleaned$methodology %in% c(
    "Email", "Email/Online Ad", 
    "Live Phone/Text-to-Web/Email/Mail-to-Web/Mail-to-Phone", 
    "Mail-to-Web/Mail-to-Phone", "Online Ad"
  ) ~ "level1")

# Step 6: Replace NA values - numerical variables with mean, categorical variables with mode
raw_data_cleaned <- raw_data_cleaned %>%
  mutate(across(where(is.numeric), ~ifelse(is.na(.), round(mean(., na.rm = TRUE), 1), .))) %>%
  mutate(across(where(is.character), ~ifelse(is.na(.), names(which.max(table(.))), .)))

# Step 7: Rename pct
names(raw_data_cleaned)[names(raw_data_cleaned) == "pct"] <- "score"


# Step 8: Filter data set by unique answer
candidates <- unique(raw_data_cleaned$answer)
for (candidate in candidates) {
  # Filter data for each candidate and remove rows with NA values
  candidate_data <- raw_data_cleaned %>%
    filter(answer == candidate) %>% 
    dplyr::select(-answer)%>% 
    dplyr::select(-poll_id)%>%
    janitor::clean_names()
  # Define output file path for each candidate
  output_file <- file.path("data/03-cleaned_data", paste0(candidate, "_cleaned_data.parquet"))
  # Save each candidate's cleaned data to a separate Parquet file
  write_parquet(candidate_data, output_file)
}

# Step 9: find analysis data
# Split the top 2 files into 3:7 ratio and save them
for (file in c("Trump_cleaned_data.parquet", "Harris_cleaned_data.parquet")) {
  # Read the Parquet file into a data frame
  df <- read_parquet(file.path("data/03-cleaned_data/", file))
  # Split the data into 3:7 ratio
  sample_indices <- sample(seq_len(nrow(df)), size = floor(0.3 * nrow(df)))
  df_3 <- df[sample_indices, ]
  df_7 <- df[-sample_indices, ]
  # Define output file paths
  output_dir_3 <- "data/02-analysis_data/02-testing"
  output_dir_7 <- "data/02-analysis_data/01-training"
  # Save the split data to separate directories
  new_file <- gsub("_cleaned_data", "", file)
  write_parquet(df_3, file.path(output_dir_3, paste0("test_", new_file)))
  write_parquet(df_7, file.path(output_dir_7, paste0("train_", new_file)))
}






