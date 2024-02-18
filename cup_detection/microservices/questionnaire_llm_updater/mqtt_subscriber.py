from typing import Dict, Any
import paho.mqtt.client as mqtt
from utils.argument_parser import ArgumentParser
from utils.logger import LOGGER
from services.monad_preprocessing import MonadPreprocessing
from services.spark_preprocessing_strategy import SparkPreprocessorStrategy
from data_access.database_strategies.postgres_strategy_dao import PostgresStrategyDAO
from utils.helpers import CoffeePrompt

def on_connect(client : Any, userdata : Any, flags : Any, rc : Any):
    LOGGER.info(f"Connected with result code {rc}")
    client.subscribe("questionnaire_LLM_updater_topic") 

def on_message(client : Any, userdata : Any, msg : Any):
    data : str = msg.payload.decode()
    # check if data is received correctly from frontend
    LOGGER.info(f"Received data: {data} on topic {msg.topic}")
    cli_arguments_postgres : Dict[str, Any] = ArgumentParser.get_llm_updater_arguments_postgres()
    
    monad_preprocessing : MonadPreprocessing = MonadPreprocessing(args=None)
    spark_preprocessor_strategy : SparkPreprocessorStrategy = SparkPreprocessorStrategy(
        session_name=msg.topic, \
        data=data, \
        table_save_data="Questionnaire", \
        loader_db_dao_strategy=PostgresStrategyDAO( \
            database=cli_arguments_postgres["database"], \
            username=cli_arguments_postgres["username"], \
            password=cli_arguments_postgres["password"], \
            host=cli_arguments_postgres["host"], \
            port=cli_arguments_postgres["port"], \
        ) \
    )
    monad_preprocessing \
        .bind(callback=spark_preprocessor_strategy.start_session) \
        .bind(callback=spark_preprocessor_strategy.transform) \
        .bind(callback=spark_preprocessor_strategy.save) \
        .bind(callback=spark_preprocessor_strategy.stop_session)

    customer_name : str = data.split("name")[-1].split(":")[1].strip()
    coffee_prompt : CoffeePrompt = CoffeePrompt()
    response_data : str = coffee_prompt.get( \
        base_url="http://ingredients-updater:8030", \
        endpoint="/coffee_recipe", \
        customer_name=customer_name \
    )
    print(f"Response data: ${response_data}")

if __name__ == "__main__":
    LOGGER.info("---MQTT subscriber started---")
    client : mqtt.Client = mqtt.Client() 
    client.on_connect = on_connect
    client.on_message = on_message
    cli_arguments_mqtt = ArgumentParser.get_llm_updater_arguments_mqtt()
    client.connect(host=cli_arguments_mqtt.message_broker, port=cli_arguments_mqtt.port, keepalive=cli_arguments_mqtt.keepalive)
    client.loop_forever()
