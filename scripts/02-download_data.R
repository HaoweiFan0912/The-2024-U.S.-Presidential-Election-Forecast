# Load required libraries
library(httr)
library(readr)

# Specify the URL for the polling data
url <- "https://projects.fivethirtyeight.com/polls/data/president_polls.csv"

# Specify the local file path where the CSV will be saved
output_file <- "president_polls.csv"

# Download the CSV file
response <- GET(url)

# Check if the request was successful
if (status_code(response) == 200) {
  # Write the content to a local CSV file
  writeBin(content(response, "raw"), output_file)
  message("File downloaded successfully!")
} else {
  message("Failed to download the file. Status code: ", status_code(response))
}

# Optional: Read and display the data
polls_data <- read_csv(output_file)
print(head(polls_data))
