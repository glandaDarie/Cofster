from typing import Any
import paho.mqtt.client as mqtt
import sys

sys.path.append("../")

from utils.arguments_parser import ArgumentParser
from utils.logger import LOGGER

def on_connect(client : Any, userdata : Any, flags : Any, rc : Any):
    LOGGER.info(f"Connected with result code {rc}")
    client.subscribe("questionnaire_LLM_updater_topic") 

def on_message(client : Any, userdata : Any, msg : Any):
    data : str = msg.payload.decode()
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

