from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from typing import List, Tuple

if __name__ == "__main__":
    spark_session : SparkSession = SparkSession.builder \
        .appName("Testing cluster") \
        .getOrCreate()
    try:
        data : List[Tuple[str, int]] = [("Alice", "Wonder", 25), ("Bob", "Builder", 30), ("Charlie", "Manson", 35)]
        features : List[str] = ["name", "surname", "age"]
        df = spark_session.createDataFrame(data=data, schema=features)
        df.createOrReplaceTempView("people")
        result_query = spark_session.sql("SELECT surname, age FROM people WHERE age >= 30")
        print(result_query.show())
    finally: 
        spark_session.stop()