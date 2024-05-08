from pyspark.sql import SparkSession
from pyspark.sql.functions import *
import os
import sched
import time

# Function to perform ETL process
def perform_etl(input_dir, output_dir, spark):
    # Read all CSV files in the input directory
    for csv_file in os.listdir(input_dir):
        if csv_file.endswith(".csv"):
            # Read input data
            input_path = os.path.join(input_dir, csv_file)
            df = spark.read.csv(input_path, header=True, inferSchema=True)

            # Example transformation: Extract year from the "Date" column
            extract_year = udf(lambda date_str: str_to_date(date_str, "yyyyMMdd").year, IntegerType())
            df_transformed = df.withColumn("Year", extract_year(col("Date")))

            # Write transformed data
            df_transformed.write.partitionBy("Year").mode("append").parquet(output_dir)

# Function to run the ETL process
def run_etl(input_dir, output_dir, spark):
    perform_etl(input_dir, output_dir, spark)

# Create a SparkSession
spark = SparkSession.builder.appName("Crime_ETL").getOrCreate()

# Define input and output directories
input_dir = "E:/Sheffield/ADMP/Data/New-Data/street"
output_dir = "E:/Sheffield/ADMP/Data/New-Data/crime-output"

# Define the interval (in seconds) for running the ETL process
interval = 900  # 15 minutes

# Create a scheduler object
scheduler = sched.scheduler(time.time, time.sleep)

# Function to run the ETL process on schedule
def run_etl_schedule():
    run_etl(input_dir, output_dir, spark)
    scheduler.enter(interval, 1, run_etl_schedule)

# Initial run of the ETL process
run_etl(input_dir, output_dir, spark)

# Schedule subsequent runs
scheduler.enter(interval, 1, run_etl_schedule)

# Start the scheduler
scheduler.run()

# Stop the SparkSession
spark.stop()
