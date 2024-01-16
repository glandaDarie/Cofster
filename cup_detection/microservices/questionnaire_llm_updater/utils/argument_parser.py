import argparse
import sys

sys.path.append("../")

from utils.decorators import key_value

class ArgumentParser:
    @staticmethod
    @key_value
    def get_llm_updater_arguments() -> argparse.Namespace:
        """
        Parses and returns LLM Updater MQTT Subscriber arguments merged with key-value arguments.

        Returns:
        - argparse.Namespace: Parsed arguments for LLM Updater MQTT Subscriber.
        """
        parser: argparse.ArgumentParser = argparse.ArgumentParser(description="LLM Updater MQTT Subscriber")
        parser.add_argument("--message_broker", type=str, default="test.mosquitto.org", help="Message broker")
        parser.add_argument("--port", type=int, default=1883, help="Port")
        parser.add_argument("--keepalive", type=int, default=60, help="Keepalive")
        return parser.parse_args()
        