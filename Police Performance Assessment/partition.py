import os
import shutil

# Define the source directory and the three destination directories
src_dir = "E:/Sheffield/ADMP/Data/New - Data/crime"
dst_street = "E:/Sheffield/ADMP/Data/New - Data/crime/street"
dst_outcomes = "E:/Sheffield/ADMP/Data/New - Data/crime/outcomes"
dst_search = "E:/Sheffield/ADMP/Data/New - Data/crime/search"

# Loop through all subdirectories in the source directory
for subdir, dirs, files in os.walk(src_dir):
    # Loop through all files in the subdirectory
    for filename in files:
        # Check if the file ends with "-street.csv"
        if filename.endswith("-street.csv"):
            # Move the file to the "street" directory
            src_path = os.path.join(subdir, filename)
            dst_path = os.path.join(dst_street, filename)
            shutil.move(src_path, dst_path)
        # Check if the file ends with "-outcomes.csv"
        elif filename.endswith("-outcomes.csv"):
            # Move the file to the "outcomes" directory
            src_path = os.path.join(subdir, filename)
            dst_path = os.path.join(dst_outcomes, filename)
            shutil.move(src_path, dst_path)
        # Check if the file ends with "-stop-and-search.csv"
        elif filename.endswith("-stop-and-search.csv"):
            # Move the file to the "search" directory
            src_path = os.path.join(subdir, filename)
            dst_path = os.path.join(dst_search, filename)
            shutil.move(src_path, dst_path)
