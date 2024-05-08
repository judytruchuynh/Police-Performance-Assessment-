from hdfs import InsecureClient
import os
import pandas as pd

# Set the directory where the datasets are located
data_root_dir = r"E:\Sheffield\ADMP\Data\New - Data\crime"

# Initialize empty lists to store datasets for each category
street_datasets = []
outcome_datasets = []
stop_and_search_datasets = []

# Loop through each directory in the root directory
for subdir, dirs, files in os.walk(data_root_dir):
    for dir_name in dirs:
        # Check if the directory name is of the form "YYYY-MM"
        if len(dir_name) == 7 and dir_name[4] == '-':
            # Set the data directory
            data_dir = os.path.join(subdir, dir_name)

            # Loop through each file in the directory and add the data to the appropriate list
            for file_name in os.listdir(data_dir):
                if file_name.endswith("street.csv"):
                    # Read the data
                    df = pd.read_csv(os.path.join(data_dir, file_name))

                    # Add new columns for year and month
                    df['Year'] = pd.DatetimeIndex(df['Month']).year
                    df['Month'] = pd.DatetimeIndex(df['Month']).month

                    # Append the modified data to the street datasets list
                    street_datasets.append(df)

                elif file_name.endswith("outcomes.csv"):
                    # Read the data
                    df = pd.read_csv(os.path.join(data_dir, file_name))

                    # Add new columns for year and month
                    df['Year'] = pd.DatetimeIndex(df['Month']).year
                    df['Month'] = pd.DatetimeIndex(df['Month']).month

                    # Append the modified data to the outcome datasets list
                    outcome_datasets.append(df)

                elif file_name.endswith("stop-and-search.csv"):
                    # Read the data
                    df = pd.read_csv(os.path.join(data_dir, file_name))

                    # Add new columns for day, month, year, and time
                    df['Date'] = pd.to_datetime(df['Date'])
                    df['Day'] = pd.DatetimeIndex(df['Date']).day
                    df['Month'] = pd.DatetimeIndex(df['Date']).month
                    df['Year'] = pd.DatetimeIndex(df['Date']).year
                    df['Time'] = pd.DatetimeIndex(df['Date']).time

                    # Append the modified data to the stop and search datasets list
                    stop_and_search_datasets.append(df)

# Concatenate the datasets for each category
street_dataset = pd.concat(street_datasets, axis=0, ignore_index=True)
outcome_dataset = pd.concat(outcome_datasets, axis=0, ignore_index=True)
stop_and_search_dataset = pd.concat(stop_and_search_datasets, axis=0, ignore_index=True)

# Write the datasets to separate CSV files in the same directory
street_dataset.to_csv(os.path.join(data_root_dir, "joined_street.csv"), index=False)
outcome_dataset.to_csv(os.path.join(data_root_dir, "joined_outcomes.csv"), index=False)
stop_and_search_dataset.to_csv(os.path.join(data_root_dir, "joined_stop_and_search.csv"), index=False)

# Create a client to connect to the HDFS cluster
client = InsecureClient("hdfs://sandbox-hdp.hortonworks.com:8020", user="ml-refvm-300601\labstudent-55-706949")

# Upload the concatenated datasets to HDFS
# Upload the joined datasets to HDFS
with client.write("/user/maria_devt/Crime/joined_street.csv", overwrite=True) as hdfs_file:
    street_dataset.to_csv(hdfs_file, index=False)

with client.write("/user/maria_devt/Crime/joined_outcomes.csv", overwrite=True) as hdfs_file:
    outcome_dataset.to_csv(hdfs_file, index=False)

with client.write("/user/maria_devt/Crime/joined_stop_and_search.csv", overwrite=True) as hdfs_file:
    stop_and_search_dataset.to_csv(hdfs_file, index=False)

# Upload the non-appended datasets to HDFS
with client.write("/user/maria_devt/Crime/street.csv", overwrite=True) as hdfs_file:
    for subdir, dirs, files in os.walk(street_dir):
        for file_name in files:
            if file_name.endswith(".csv"):
                df = pd.read_csv(os.path.join(subdir, file_name))
                df.to_csv(hdfs_file, index=False, header=hdfs_file.tell()==0)

with client.write("/user/maria_devt/Crime/outcomes.csv", overwrite=True) as hdfs_file:
    for subdir, dirs, files in os.walk(outcome_dir):
        for file_name in files:
            if file_name.endswith(".csv"):
                df = pd.read_csv(os.path.join(subdir, file_name))
                df.to_csv(hdfs_file, index=False, header=hdfs_file.tell()==0)

with client.write("/user/maria_devt/Crime/stop_and_search.csv", overwrite=True) as hdfs_file:
    for subdir, dirs, files in os.walk(stop_and_search_dir):
        for file_name in files:
            if file_name.endswith(".csv"):
                df = pd.read_csv(os.path.join(subdir, file_name))
                df.to_csv(hdfs_file, index=False, header=hdfs_file.tell()==0)

