from typing import Any
import paho.mqtt.client as mqtt
from utils.argument_parser import ArgumentParser
from utils.logger import LOGGER
from services.monad_preprocessing import MonadPreprocessing
from services.preprocessing import SparkPreprocessorStrategy
from data_access.database_strategies.postgres_strategy_dao import PostgresStrategyDAO

def on_connect(client : Any, userdata : Any, flags : Any, rc : Any):
    LOGGER.info(f"Connected with result code {rc}")
    client.subscribe("questionnaire_LLM_updater_topic") 

def on_message(client : Any, userdata : Any, msg : Any):
    data : str = msg.payload.decode()
    # check if data is received correctly from frontend
    LOGGER.info(f"Received data: {data} on topic {msg.topic}")
    print(f"Received data: {data} on topic {msg.topic}")
    
    # sample code testing here
    # preprocess here data with Spark, modify the LLM file and save the data in a SQL database (can use a columnar later to perform writes on it)
    # should add the code from the preprocessing here

    monad_preprocessing : MonadPreprocessing = MonadPreprocessing(args=None)
    spark_preprocessor_strategy : SparkPreprocessorStrategy = SparkPreprocessorStrategy(
        session_name=msg.topic, \
        data=data, \
        table_save_data="Questionnaire", \
        loader_db_dao_strategy=PostgresStrategyDAO( \
            database="database", \
            username="username", \
            password="password" \
        ) \
    )
    monad_preprocessing \
        .bind(callback=spark_preprocessor_strategy.start_session) \
        .bind(callback=spark_preprocessor_strategy.transform) \
        .bind(callback=spark_preprocessor_strategy.save) \
        .bind(callback=spark_preprocessor_strategy.stop_session)
        
    # SPARK test
    # -------------------------------
    # spark_session : SparkSession = SparkSession.builder \
    #     .appName(msg.topic) \
    #     .getOrCreate()
    # try:
    #     data : List[Tuple[str, int]] = [("Alice", "Wonder", 25), ("Bob", "Builder", 30), ("Charlie", "Manson", 35)]
    #     features : List[str] = ["name", "surname", "age"]
    #     df = spark_session.createDataFrame(data=data, schema=features)
    #     df.createOrReplaceTempView("people")
    #     result_query = spark_session.sql("SELECT surname, age FROM people WHERE age >= 30")
    #     print(result_query.show())
    # finally: 
    #     spark_session.stop()
    # # -------------------------------

if __name__ == "__main__":
    LOGGER.info("---MQTT subscriber started---")
    client : mqtt.Client = mqtt.Client() 
    client.on_connect = on_connect
    client.on_message = on_message
    cli_arguments = ArgumentParser.get_llm_updater_arguments()
    client.connect(host=cli_arguments.message_broker, port=cli_arguments.port, keepalive=cli_arguments.keepalive)
    client.loop_forever()