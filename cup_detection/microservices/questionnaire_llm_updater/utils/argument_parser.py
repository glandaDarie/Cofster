import argparse
import sys
import os
from typing import Dict, Any

sys.path.append("../")

from utils.decorators import key_value

class ArgumentParser:
    @staticmethod
    @key_value
    def get_llm_updater_arguments_mqtt() -> argparse.Namespace:
        """
        Parses and returns LLM Updater MQTT Subscriber arguments converted to key-value arguments.

        Returns:
        - argparse.Namespace: Parsed arguments for LLM Updater MQTT Subscriber.
        """
        parser : argparse.ArgumentParser = argparse.ArgumentParser(description="LLM Updater MQTT Subscriber")
        parser.add_argument("--message_broker", type=str, default="test.mosquitto.org", help="Message broker")
        parser.add_argument("--port", type=int, default=1883, help="Port")
        parser.add_argument("--keepalive", type=int, default=60, help="Keepalive")
        return parser.parse_args()

    @staticmethod    
    def get_llm_updater_arguments_postgres() ->  Dict[str, Any]:
        """
        Get LLM Updater PostgreSQL arguments from environment variables.

        Returns:
        - Dict[str, Any]: Dictionary containing PostgreSQL arguments.
          Keys: "database", "username", "password", "host", "port".
        """
        return {
            "database": os.environ.get('POSTGRES_DB'),
            "username": os.environ.get('POSTGRES_USER'),
            "password": os.environ.get('POSTGRES_PASSWORD'),
            "host": os.environ.get('POSTGRES_HOST', '127.0.0.1'),
            "port": int(os.environ.get('POSTGRES_PORT', 5432)),
        }