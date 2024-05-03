from typing import Dict, Any, Type
import requests
import sys
import json
import logging
from logging import Logger

sys.path.append("../")

from utils.helpers import url_builder
from utils.exceptions import StatusCodeError

class PreviousPromptService():
    
    logger : Logger = logging.getLogger(__name__)

    @classmethod
    def get_prompt( \
        cls : Type['PreviousPromptService'], \
        base_url : str, \
        endpoint : str, \
        timeout : int = 7, \
        **params : Dict[str, Any] \
    ) -> str:
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
            StatusCodeError: If the HTTP response status code is not 200.
            requests.exceptions.RequestException: If there is an error during the HTTP request.
            (json.decoder.JSONDecodeError, ValueError): If there is an error decoding JSON data.
        """
        url: str = url_builder(base_url=base_url, endpoint=endpoint)
        cls.logger.info(f"Fetching prompt from URL: {url} with parameters: {params}")

        try:
            response: requests.Response = requests.get(url=url, params=params, timeout=timeout)
            cls.logger.info(f"Response: {response}, status code: {response.status_code}")

            response.raise_for_status()     

            status_code : int = response.status_code
            if status_code != 200:
                raise StatusCodeError(f"StatusCodeError: status code is {status_code}. Error message from server: {response['error_message']}")

            data: Dict[str, Any] = response.json()
            return data["content"]
        except requests.exceptions.RequestException as request_error:
            cls.logger.error(f"Error during request: {request_error}")
            raise 
        except (json.decoder.JSONDecodeError, ValueError) as decoding_error:
            cls.logger.error(f"Error when decoding JSON: {decoding_error}")
            raise
    
    @classmethod
    def put_new_prompt( \
        cls : Type['PreviousPromptService'], \
        base_url : str, \
        endpoint : str, \
        body_data : Dict[str, Any], \
        headers : Dict[str, str], \
        timeout : int = 7
    ) -> str:
        """
        Updates a prompt by making a PUT request to the specified URL.

        Args:
            cls: The class reference (implicitly passed).
            base_url (str): The base URL for the request.
            endpoint (str): The endpoint for the request.
            body_data (Dict[str, Any]): The data to be included in the request body.
            headers (Dict[str, str]): The headers to be included in the request.
            timeout (int, optional): The timeout for the HTTP request (default is 7 seconds).
            **params (Dict[str, Any]): Additional parameters for the request.

        Returns:
            str: The message received in the response.

        Raises:
            StatusCodeError: If the response status code is not 200.
            requests.exceptions.Timeout: If the request times out.
            requests.exceptions.RequestException: If there is an error during the HTTP request.
            (json.decoder.JSONDecodeError, ValueError): If there is an error decoding JSON data.
            Exception: For any other unexpected errors.
        """
        url: str = url_builder(base_url=base_url, endpoint=endpoint)
        cls.logger.info(f"Updating prompt from URL: {url} with body parameters: {body_data}")

        try:
            response : requests.Response = requests.put(url=url, headers=headers, json=body_data, timeout=timeout)
            cls.logger.info(f"Response: {response}, status code: {response.status_code}")

            response.raise_for_status()

            status_code : int = response.status_code
            if response.status_code != 200:
                raise StatusCodeError(f"StatusCodeError: status code is {status_code}. Error message from server: {response['error_message']}")

            data: Dict[str, Any] = response.json()
            return data["message"]
        
        except requests.exceptions.Timeout as timeout_error:
            cls.logger.error(f"Timeout error: {timeout_error}")
            raise
        except requests.exceptions.RequestException as request_error:
            cls.logger.error(f"Error during request: {request_error}")
            raise
        except (json.decoder.JSONDecodeError, ValueError) as decoding_error:
            cls.logger.error(f"Error when decoding JSON: {decoding_error}. Response content: {response.text}")
            raise
        except Exception as error:
            cls.logger.error(f"An unexpected error occurred: {error}")
            raise