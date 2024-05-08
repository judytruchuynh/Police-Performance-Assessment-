from pyspark.sql import SparkSession
from pyspark.sql.functions import *
import sched, time

# Function to perform ETL process
def perform_etl():
    # Create a SparkSession
    spark = SparkSession.builder.appName("Crime_ETL").getOrCreate()

    # Define input and output paths
    input_dir = "E:/Sheffield/ADMP/Data/New - Data/crime"
    output_dir = "E:/Sheffield/ADMP/Data/New - Data/crime-output"

    # Read input data
    street_df = spark.read.csv(f"{input_dir}/street/*.csv", header=True)
    outcomes_df = spark.read.csv(f"{input_dir}/outcomes/*.csv", header=True)
    stop_and_search_df = spark.read.csv(f"{input_dir}/stop-and-search/*.csv", header=True)

    # Transform data
    # Example: Extract year from the "Date" column
    extract_year = udf(lambda date_str: str_to_date(date_str, "yyyyMMdd").year, IntegerType())

    street_transformed = street_df.withColumn("Year", extract_year(col("Date")))
    outcomes_transformed = outcomes_df.withColumn("Year", extract_year(col("Date")))
    stop_and_search_transformed = stop_and_search_df.withColumn("Year", extract_year(col("Date")))

    # Write transformed data
    street_transformed.write.partitionBy("Year").parquet(f"{output_dir}/street")
    outcomes_transformed.write.partitionBy("Year").parquet(f"{output_dir}/outcomes")
    stop_and_search_transformed.write.partitionBy("Year").parquet(f"{output_dir}/stop-and-search")

    # Stop the SparkSession
    spark.stop()

# Create a scheduler object
scheduler = sched.scheduler(time.time, time.sleep)

# Define the interval (in seconds) for running the ETL process
interval = 900  # 15 minutes

# Function to run the ETL process on schedule
def run_etl_schedule():
    perform_etl()  # Run the ETL process
    scheduler.enter(interval, 1, run_etl_schedule)  # Schedule the next run

# Initial run of the ETL process
scheduler.enter(0, 1, run_etl_schedule)

# Start the scheduler
scheduler.run()
