  
  library(sparklyr)
  library(dplyr)
  library(stringr)
  
  # Function to extract year, month, day, and time from date string
  extract_date_time <- function(date_str) {
    year <- str_sub(date_str, 1, 4)
    month <- str_sub(date_str, 6, 7)
    day <- str_sub(date_str, 9, 10)
    time <- str_sub(date_str, 12, 19)
    return(c(year, month, day, time))
  }
  
  
  ########################################################################################################
  ##        STOP AND SEARCH 
  ########################################################################################################
  
  # Set working directory
  setwd("E:/Sheffield/ADMP/Data/New - Data/search")
  # Get file paths
  file_paths <- list.files(".", pattern = "stop-and-search.csv", full.names = TRUE, recursive = TRUE)
  stop_and_search_df <- data.frame()
  # Loop through each file path and process the data
  for (file_path in file_paths) {
    file_parts <- strsplit(basename(file_path), "-")[[1]]
    Location <- paste(file_parts[3:(length(file_parts) - 3)], collapse = "-")
    Location <- gsub("-", " ", Location)
    Location <- str_to_title(Location)
    # Process the data
    stop_and_search_data <- read.csv(file_path, check.names=FALSE)
    # Extract year, month, day, and time from "Date" column
    date_time <- sapply(stop_and_search_data$Date, extract_date_time)
    stop_and_search_data$Year <- date_time[1,]
    stop_and_search_data$Month <- date_time[2,]
    stop_and_search_data$Day <- date_time[3,]
    stop_and_search_data$Time <- date_time[4,]
    # remove the original Date column
    stop_and_search_data <- stop_and_search_data[, !(names(stop_and_search_data) %in% c("Date"))]
    names(stop_and_search_data) <- c("Type", "Part_of_a_policing_operation", "Policing_operation", "Latitude", "Longitude", "Gender", "Age_range", "Self_defined_ethnicity", "Officer_defined_ethnicity", "Legislation", "Object_of_search", "Outcome", "Outcome_linked_to_object_of_search", "Removal_of_more_than_just_outer_clothing", "Year", "Month", "Day", "Time")
    stop_and_search_data <- subset(stop_and_search_data, select = -c(Policing_operation))
    stop_and_search_data$Age_range <- gsub("Oct-17", "10-17", stop_and_search_data$Age_range)
    stop_and_search_data[stop_and_search_data == ""] <- NA
    stop_and_search_data[stop_and_search_data == "<NA>"] <- NA
    # Add the processed data to the data frame
    stop_and_search_data$Location <- Location
    stop_and_search_df <- rbind(stop_and_search_df, stop_and_search_data)
  }
  
  # Write the data frame to the system
  write.csv(stop_and_search_df, file = "E:/Sheffield/ADMP/Data/New - Data/crime/search_cleaned.csv", row.names = FALSE)
  
  
  
  ########################################################################################################
  ##        OUTCOMES
  ########################################################################################################
  
  
  # Set working directory
  setwd("E:/Sheffield/ADMP/Data/New - Data/outcomes")
  # Get file paths
  file_paths <- list.files(".", pattern = "outcomes.csv", full.names = TRUE, recursive = TRUE)
  
  outcomes_df <- data.frame()
  # Loop through each file path and process the data
  for (file_path in file_paths) {
    file_parts <- strsplit(basename(file_path), "-")[[1]]
    Location_file <- paste(file_parts[3:(length(file_parts) - 1)], collapse = "-")
    Location_file <- gsub("-", " ", Location_file)
    Location_file <- str_to_title(Location_file)
    # Process the data
    outcomes_data <- read.csv(file_path, check.names=FALSE)
    
    # Extract year, month, day, and time from "Date" column
    date_time <- sapply(outcomes_data$Month, extract_date_time)
    outcomes_data$Year <- date_time[1,]
    outcomes_data$Month_ <- date_time[2,]
    # remove the original Date column
    outcomes_data <- outcomes_data[, !(names(outcomes_data) %in% c("Month"))]  
    names(outcomes_data) <- c("Crime_ID", "Report_by", "Falls_within", "Longitude", "Latitude", "Location", "LSAO_code", "LSAO_name", "Outcome_type", "Year", "Month")
    outcomes_data[outcomes_data == ""] <- NA
    outcomes_data[outcomes_data == "<NA>"] <- NA
    # Add the processed data to the data frame
    outcomes_data$Location_file <- Location_file
    
    outcomes_df <- rbind(outcomes_df, outcomes_data)
  }
  # Write the data frame to the system
  write.csv(outcomes_df, file = "E:/Sheffield/ADMP/Data/New - Data/crime/outcomes_cleaned.csv", row.names = FALSE)
  
  
  ########################################################################################################
  ##        STREET 
  ########################################################################################################
  
  
  # Set working directory
  setwd("E:/Sheffield/ADMP/Data/New - Data/street")
  # Get file paths
  file_paths <- list.files(".", pattern = "street.csv", full.names = TRUE, recursive = TRUE)
  
  street_df <- data.frame()
  # Loop through each file path and process the data
  for (file_path in file_paths) {
    file_parts <- strsplit(basename(file_path), "-")[[1]]
    Location_file <- paste(file_parts[3:(length(file_parts) - 1)], collapse = "-")
    Location_file <- gsub("-", " ", Location_file)
    Location_file <- str_to_title(Location_file)
    # Process the data
    street_data <- read.csv(file_path, check.names=FALSE)
    
    # Extract year, month, day, and time from "Date" column
    date_time <- sapply(street_data$Month, extract_date_time)
    street_data$Year <- date_time[1,]
    street_data$Month_ <- date_time[2,]
    # remove the original Date column
    street_data <- street_data[, !(names(street_data) %in% c("Month"))]  
    names(street_data) <- c("Crime_ID", "Report_by", "Falls_within", "Longitude", "Latitude", "Location", "LSAO_code", "LSAO_name", "Crime_type", "Last_outcome_category", "Context", "Year", "Month")
    street_data <- subset(street_data, select = -c(Context))
    street_data[street_data == ""] <- NA
    street_data[street_data == "<NA>"] <- NA
    # Add the processed data to the data frame
    street_data$Location_file <- Location_file
    
    street_df <- rbind(street_df, street_data)
  }
  # Write the data frame to the system
  write.csv(street_df, file = "E:/Sheffield/ADMP/Data/New - Data/crime/street_cleaned.csv", row.names = FALSE)
  
  
