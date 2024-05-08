library(sparklyr)
library(dplyr)
library(stringr)
setwd("E:/Sheffield/ADMP/Data/New - Data/crime")

# Function to extract year, month, day, and time from date string
extract_date_time <- function(date_str) {
  year <- str_sub(date_str, 1, 4)
  month <- str_sub(date_str, 6, 7)
  day <- str_sub(date_str, 9, 10)
  time <- str_sub(date_str, 12, 19)
  return(c(year, month, day, time))
}

# Function to process stop and search data
process_stop_and_search_data <- function(file_path) {
  file_parts <- strsplit(basename(file_path), "-")[[1]]
  Location <- paste(file_parts[3:(length(file_parts) - 3)], collapse = "-")
  Location <- gsub("-", " ", Location)
  Location <- str_to_title(Location)
  stop_and_search_data <- read.csv(file_path, check.names=FALSE)
  # Extract year, month, day, and time from "Date" column
  date_time <- sapply(stop_and_search_data$Date, extract_date_time)
  stop_and_search_data$Year <- date_time[1,]
  stop_and_search_data$Month <- date_time[2,]
  stop_and_search_data$Day <- date_time[3,]
  stop_and_search_data$Time <- date_time[4,]
  # Remove the original Date column
  stop_and_search_data <- stop_and_search_data[, !(names(stop_and_search_data) %in% c("Date"))]
  names(stop_and_search_data) <- c("Type", "Part_of_a_policing_operation", "Latitude", "Longitude", "Gender", "Age_range", "Self_defined_ethnicity", "Officer_defined_ethnicity", "Legislation", "Object_of_search", "Outcome", "Outcome_linked_to_object_of_search", "Removal_of_more_than_just_outer_clothing", "Year", "Month", "Day", "Time")
  stop_and_search_data <- subset(stop_and_search_data, select = -c(Part_of_a_policing_operation))
  stop_and_search_data$Age_range <- gsub("Oct-17", "10-17", stop_and_search_data$Age_range)
  stop_and_search_data[stop_and_search_data == ""] <- NA
  stop_and_search_data[stop_and_search_data == "<NA>"] <- NA
  # Add the processed data to the data frame
  stop_and_search_data$Location <- Location
  return(stop_and_search_data)
}

# Loop through each subdirectory and process the stop and search data
stop_and_search_df <- data.frame()
subdirs <- list.dirs(".", recursive = TRUE, full.names = TRUE)
for (subdir in subdirs) {
  file_paths <- list.files(subdir, pattern = "stop-and-search.csv", full.names = TRUE, recursive = FALSE)
  for (file_path in file_paths) {
    stop_and_search_data <- process_stop_and_search_data(file_path)
    stop_and_search_df <- rbind(stop_and_search_df, stop_and_search_data)
  }
}

# Write the data frame to the system
write.csv(stop_and_search_df, file = "E:/Sheffield/ADMP/Data/New - Data/crime/search_cleaned.csv", row.names = FALSE)
