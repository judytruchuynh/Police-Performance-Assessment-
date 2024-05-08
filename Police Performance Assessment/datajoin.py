import pandas as pd
import os

# Set the path to the root directory that contains all the data folders
root_dir = '/path/to/root/directory'

# Get a list of all subdirectories in the root directory
subdirs = [x[0] for x in os.walk(root_dir)]

# Initialize an empty list to store all the dataframes
dfs = []

# Loop over each subdirectory
for subdir in subdirs:
    # Skip the root directory itself
    if subdir == root_dir:
        continue
    
    # Get a list of all CSV files in the subdirectory
    csv_files = [os.path.join(subdir, f) for f in os.listdir(subdir) if f.endswith('.csv')]
    
    # Loop over each CSV file
    for filename in csv_files:
        # Load the CSV file into a dataframe
        df = pd.read_csv(filename)
        
        # Extract the year and month from the filename
        year, month = filename.split('-')[0:2]
        
        # Add the year and month columns to the dataframe
        df['year'] = int(year)
        df['month'] = int(month)
        
        # Append the dataframe to the list of dataframes
        dfs.append(df)

# Concatenate all the dataframes into a single dataframe
combined_df = pd.concat(dfs)

# Save the concatenated dataframe to a CSV file
combined_df.to_csv('combined_data.csv', index=False)
