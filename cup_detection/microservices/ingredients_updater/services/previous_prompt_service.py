from typing import Dict, Any
import requests
import sys
import json
import logging

sys.path.append("../")

from utils.helpers import url_builder

class PreviousPromptService:
    def __init__(self):
        """
        Initializes the prompt service and the logger.
        """
        self.logger = logging.getLogger(__name__)

    def get_prompt(self, base_url: str, endpoint: str, timeout: int = 7, **params: Dict[str, Any]) -> str:
        """
        Fetches prompt data from a specified URL.

        Args:
            base_url (str): The base URL.
            endpoint (str): The endpoint for fetching prompt data.
            timeout (int, optional): The timeout for the HTTP request. Defaults to 7 seconds.
            **params (Dict[str, Any]): Additional parameters for the request.

        Returns:
            str: The content of the prompt data.

        Raises:
            RuntimeError: If the HTTP response status code is not 200.
            requests.exceptions.RequestException: If there is an error during the HTTP request.
            (json.decoder.JSONDecodeError, ValueError): If there is an error decoding JSON data.
        """
        url: str = url_builder(base_url=base_url, endpoint=endpoint)
        self.logger.info(f"Fetching prompt from URL: {url} with parameters: {params}")
        try:
            response: requests.Response = requests.get(url=url, params=params, timeout=timeout)
            self.logger.info(f"Response: {response}, status code: {response.status_code}")

            response.raise_for_status()     

            status_code : int = response.status_code
            if status_code != 200:
                raise RuntimeError(f"Error, status code {status_code}. {response['error_message']}")

            data: Dict[str, Any] = response.json()
            return data["content"]
        except requests.exceptions.RequestException as error:
            self.logger.error(f"Error during request: {error}")
            raise 
        except (json.decoder.JSONDecodeError, ValueError) as error:
            self.logger.error(f"Error when decoding JSON: {error}")
            raise