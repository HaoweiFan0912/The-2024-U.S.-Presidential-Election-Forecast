#### Preamble ####
# Purpose: Downloads and saves the data from fivethirtyeight.
# Author: Haowei Fan, Fangning Zhang, Shaotong Li
# Date: 13 October 2024
# Contact: haowei.fan@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)

#### Download data ####
url <- "https://projects.fivethirtyeight.com/polls/data/president_polls.csv"
the_raw_data <- read.csv(url)

#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(the_raw_data, "data/01-raw_data/raw_data.csv") 

