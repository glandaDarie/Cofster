from typing import Dict, Any
from urllib.parse import urljoin, urlsplit
import requests

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

        response_data : requests.Response = requests.put(url=url, headers=headers, json=data)
        # response_data : requests.Response = requests.get(url=url, params=params)

        status_code : int = response_data.status_code
        if status_code != 200:
            raise RuntimeError(f"Error: {response_data['error_message']}")
        return response_data["prompt"]