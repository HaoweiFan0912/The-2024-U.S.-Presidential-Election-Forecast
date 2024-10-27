#### Preamble ####
# Purpose: Explore the analysis data and find representitive values
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-analysis_data saved and loaded
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(patchwork)

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

# Define file paths
source_folder <- "data/03-cleaned_data/cleaned_data_by_candidate/"
destination_folder <- "data/02-analysis_data/"

# Define filenames
files_to_move <- c("Donald Trump_cleaned_data.csv", "Kamala Harris_cleaned_data.csv", "Joe Biden_cleaned_data.csv")

# Copy each file from source to destination
for (file_name in files_to_move) {
  file_path <- file.path(source_folder, file_name)
  destination_path <- file.path(destination_folder, file_name)
  
  # Copy file
  file.copy(file_path, destination_path, overwrite = TRUE)
  message(paste("File saved to:", destination_path))
}

# Load data for each candidate
donald_trump_data <- read_csv("data/02-analysis_data/Donald Trump_cleaned_data.csv") 
joe_biden_data <- read_csv("data/02-analysis_data/Joe Biden_cleaned_data.csv") 
kamala_harris_data <- read_csv("data/02-analysis_data/Kamala Harris_cleaned_data.csv") 

# Define and load data for each candidate
candidate_data <- list(
  "Donald Trump" = donald_trump_data %>% select(-poll_id, -pct),
  "Kamala Harris" = joe_biden_data %>% select(-poll_id, -pct),
  "Joe Biden" = kamala_harris_data %>% select(-poll_id, -pct)
)

# Function to create distribution plots for each variable in a dataset
plot_distributions <- function(data, candidate_name) {
  plots <- list()
  
  for (var in names(data)) {
    if (is.numeric(data[[var]])) {
      # Histogram for numeric variables
      plot <- ggplot(data, aes(x = .data[[var]])) +
        geom_histogram(bins = 30, color = "black", fill = "skyblue") +
        labs(title = paste("Distribution of", var, "for", candidate_name), x = var, y = "Frequency") +
        theme_minimal()
      
    } else if (is.character(data[[var]]) || is.factor(data[[var]])) {
      # Bar plot for categorical variables
      plot <- ggplot(data, aes(x = .data[[var]])) +
        geom_bar(color = "black", fill = "skyblue") +
        labs(title = paste("Distribution of", var, "for", candidate_name), x = var, y = "Count") +
        theme_minimal()
      
    } else if (is.logical(data[[var]])) {
      # Bar plot for logical variables (TRUE/FALSE)
      plot <- ggplot(data, aes(x = factor(.data[[var]], levels = c(TRUE, FALSE)))) +
        geom_bar(color = "black", fill = "skyblue") +
        labs(title = paste("Distribution of", var, "for", candidate_name), x = var, y = "Count") +
        theme_minimal()
    }
    
    # Add plot to list
    plots[[var]] <- plot
  }
  
  # Combine all individual plots into one using patchwork
  combined_plot <- wrap_plots(plots) +
    plot_annotation(title = paste("Distributions of Variables for", candidate_name))
  
  return(combined_plot)
}

# Create and display combined plots for each candidate
for (candidate_name in names(candidate_data)) {
  data <- candidate_data[[candidate_name]]
  combined_plot <- plot_distributions(data, candidate_name)
  print(combined_plot)
}

# Define paths for each candidate's data
candidate_files <- list(
  "Donald Trump" = "data/02-analysis_data/Donald Trump_cleaned_data.csv",
  "Kamala Harris" = "data/02-analysis_data/Kamala Harris_cleaned_data.csv",
  "Joe Biden" = "data/02-analysis_data/Joe Biden_cleaned_data.csv"
)

# Function to calculate representative values
calculate_representative_value <- function(data) {
  data %>%
    summarise(
      pollscore_mean = mean(pollscore, na.rm = TRUE),
      numeric_grade_median = median(numeric_grade, na.rm = TRUE),
      transparency_score_mean = mean(transparency_score, na.rm = TRUE),
      duration_mean = mean(duration, na.rm = TRUE),
      sample_size_mean = mean(sample_size, na.rm = TRUE),
      population_mode = as.character(names(sort(table(population), decreasing = TRUE)[1])),  # Calculate mode
      hypothetical_mode = as.logical(names(sort(table(hypothetical), decreasing = TRUE)[1])),  # Calculate mode
      Methodology_mode = as.character(names(sort(table(Methodology), decreasing = TRUE)[1])),  # Calculate mode
      pct_mean = mean(pct, na.rm = TRUE)
    )
}

# Calculate and display representative values for each candidate
all_representative_values <- list()
for (candidate_name in names(candidate_files)) {
  data <- read_csv(candidate_files[[candidate_name]])
  representative_values <- calculate_representative_value(data)
  print(paste("Representative values for", candidate_name, ":"))
  print(representative_values)
  all_representative_values[[candidate_name]] <- representative_values
}

# Combine and display full results as a single data frame
full_representative_values <- bind_rows(all_representative_values, .id = "Candidate")
print(full_representative_values, width = Inf)
