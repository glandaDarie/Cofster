from typing import Any
import paho.mqtt.client as mqtt
import sys
from pyspark.sql import SparkSession
from typing import List, Tuple

sys.path.append("../")

from utils.arguments_parser import ArgumentParser
from utils.logger import LOGGER

def on_connect(client : Any, userdata : Any, flags : Any, rc : Any):
    LOGGER.info(f"Connected with result code {rc}")
    client.subscribe("questionnaire_LLM_updater_topic") 

def on_message(client : Any, userdata : Any, msg : Any):
    data : str = msg.payload.decode()
    # sample code testing here
    spark_session : SparkSession = SparkSession.builder \
        .appName(msg.topic) \
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
    # preprocess here data with Spark, modify the LLM file and save the data in RedShift 
    LOGGER.info(f"Received data: {data} on topic {msg.topic}")
    print(f"Received data: {data} on topic {msg.topic}")

if __name__ == "__main__":
    client : mqtt.Client = mqtt.Client() 
    client.on_connect = on_connect
    client.on_message = on_message
    cli_arguments = ArgumentParser.get_llm_updater_arguments()
    client.connect(host=cli_arguments.message_broker, port=cli_arguments.port, keepalive=cli_arguments.keepalive)
    client.loop_forever()