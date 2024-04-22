from typing import Dict, Any
from urllib.parse import urljoin, urlsplit
import requests
from utils.enums.mqtt_response_type import MqttResponseType
from utils.errors.mqtt_response_error import MqttResponseError
from utils.logger import LOGGER

def __process_coffee_name_helper(current_data : str) -> str:
    """
    Process the coffee name.

    Parameters:
    - current_data (str): The current data containing the coffee name.

    Returns:
    - str: The processed coffee name.
    """
    current_data : str = current_data.split("\n")[0].lower()
    return current_data.replace("-", "_") if "-" in current_data else current_data

def get_mqtt_response_value(data : str, key_splitter : str) -> str:
    """
    Get the value corresponding to the given key from MQTT response data.

    Parameters:
    - data (str): The MQTT response data string.
    - key_splitter (str): The key splitter used to extract the key from data.

    Returns:
    - str: The value corresponding to the key.

    Raises:
    - MqttResponseError: If the key is unknown or the key format is invalid.
    """
    try:
        value : str = data.split(key_splitter)[-1].split(":")[1].strip()
        if key_splitter == MqttResponseType.CUSTOMER_NAME.value:
            return value
        elif key_splitter == MqttResponseType.COFFEE_NAME.value:
            return __process_coffee_name_helper(current_data=value)
        else:
            raise MqttResponseError(f"Unknown key: {key_splitter}")
    except ValueError:
        raise MqttResponseError("Invalid key format")
    finally:
        LOGGER.info(f"{key_splitter} : {value}")

def parse_key_value_args(args : Any) -> Dict[str, Any]:
    """
    Parses key-value arguments.

    Args:
    - args (List[str]): List of string arguments in key=value format.

    Returns:
    - Dict[str, Any]: A dictionary containing parsed key-value pairs.
    """
    parsed_args : Dict[str, Any] = {}
    for arg in args:
        key, value = arg.split('=')
        parsed_args[key] = value
    return parsed_args

def url_builder(base_url : str, endpoint : str) -> str:
    """
    Build a complete URL from a base URL, and an endpoint.

    Parameters:
      base_url (str): The base URL.
      endpoint (str): The endpoint to append to the base URL.

    Returns:
      str: The constructed URL.

    Raises:
      ValueError: If the base URL is missing a valid scheme (http/https) or network location.
      ValueError: If the endpoint is an empty string.
    """
    url : str = urljoin(base_url, endpoint)
    scheme, netloc, _, _, _ = urlsplit(url)
    if not scheme or not netloc:
        raise ValueError("Invalid base URL. Must have a scheme (http/https) and network location.")
    return url

class CoffeePrompt:
    def __init__(self):
        pass
    
    def put(self, base_url : str, endpoint : str, headers : Dict[str, str], **data : Dict[str, Any]) -> str:
        """Updates coffee recipe data from an API using a PUT request.

        Args:
            base_url (str): The base URL of the API.
            endpoint (str): The specific endpoint for the API.
            **data (Dict[str, Any]): Parameters to include in the request.

        Returns:
            str: The data to update the coffee recipe data.

        Raises:
            RuntimeError: If the API response status code is not 200.

        """
        url : str = url_builder(base_url=base_url, endpoint=endpoint)
        response : requests.Response = requests.put(url=url, headers=headers, json=data)
        status_code : int = response.status_code
        response_data : Dict[str, Any] = response.json()
        if status_code != 200:
            raise RuntimeError(f"Error: {response_data['error_message']}")
        return response_data["prompt"]