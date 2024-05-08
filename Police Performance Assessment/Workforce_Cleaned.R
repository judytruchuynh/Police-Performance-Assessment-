clean_workforce <- function(input_path, output_path) {
  library(readr)
  library(dplyr)
  
  # Read the CSV file
  workforce <- read.csv(input_path)
  
  # Rename columns with unique names
  colnames(workforce) <- c("Year", "Geo_code", "Force_name", "Region", "Sex", "Rank_description", "Worker_type", "Total_headcount", "Total_FTE")
  
  # Replace "&" with "and" in Force_name column where the value is "Avon & Somerset"
  workforce$Force_name <- ifelse(workforce$Force_name == "Avon & Somerset", "Avon and Somerset", workforce$Force_name)
  
  # filter the data to exclude years between 2007 and 2019
  workforce <- workforce %>% filter(Year < 2007 | Year > 2019)
  workforce$Total_headcount <- gsub("_", "NA", workforce$Total_headcount)
  workforce$Total_headcount <- gsub("-", "NA", workforce$Total_headcount)
  workforce$Total_headcount <- gsub("N/A", "NA", workforce$Total_headcount)
  workforce$Geo_code <- gsub("N/A", "NA", workforce$Geo_code)
  
  
  
  workforce$Total_FTE <- gsub("_", "NA", workforce$Total_FTE)
  workforce$Total_FTE <- gsub("-", "NA", workforce$Total_FTE)
  workforce$Total_FTE <- gsub("N/A", "NA", workforce$Total_FTE)
  workforce$Region <- gsub("N/A", "NA", workforce$Region)
 
  

  
  # Write the updated file to disk
  write.csv(workforce, output_path, row.names = FALSE)
  
  cat("Cleaning complete!\n")
  return(workforce)
}

clean_workforce("C:/Users/Harshada Khopade/Desktop/ADMP/workforce.csv", "C:/Users/Harshada Khopade/Desktop/ADMP/cleaned_workforce15.csv")

empty_counts <- sapply(workforce, function(x) sum(is.na(x) | x == ""))
empty_counts

# Create frequency tables for each column using lapply()
lapply(workforce, function(x) {
  table(factor(x, exclude = NULL))
})


