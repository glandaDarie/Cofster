from typing import Dict, Any, List, Tuple
import json
import requests 
from requests.models import Response
from urllib.parse import urljoin

class DataTransformerDAO:
    """
        A DAO class for fetching.
    """

    def fetch(self, base_url: str, endpoint: str, params: Dict[str, Any] = None):
        """
        Fetches data from the specified URL endpoint.

        Args:
            base_url (str): The base URL.
            endpoint (str): The endpoint to fetch data from.
            params (Dict[str, Any] | None, optional): Parameters for the request. Defaults to None.

        Returns:
            DataTransformerDAO: The DataTransformerDAO object.
        """
        url : str = urljoin(base_url, endpoint)
        try:
            response : Response = requests.get(url=url, params=params)
            status_code : int = response.status_code
            if status_code == 200:
                try:
                    data : Dict = json.loads(response.text)[0]
                except ValueError as json_error:
                    raise ValueError(f"Failed to parse JSON response: {json_error}")
        except (requests.exceptions.ConnectionError,
                requests.exceptions.Timeout,
                requests.exceptions.HTTPError,
                requests.exceptions.RequestException) as error:
            if isinstance(error, requests.exceptions.ConnectionError):
                raise requests.exceptions.ConnectionError(f"Connection error occurred, error: {error}")
            elif isinstance(error, requests.exceptions.Timeout):
                raise requests.exceptions.Timeout(f"Request timeout occurred, error: {error}")
            elif isinstance(error, requests.exceptions.HTTPError):
                raise requests.exceptions.HTTPError(f"HTTP error occurred, error: {error}")
            else:
                raise requests.exceptions.RequestException(f"Another request exception occurred, error: {error}") 
        return data

    def transform(self, data : Dict) -> List[Tuple[str, int]]:
        """
        Transforms data to extract information.

        Args: 
            data (Dict): The fetched data.

        Returns:
            List[Tuple[str, str]]: A list of tuples containing information.
        """
        users_information : List[Tuple[str, str]] = []
        users : List[Dict[str, str]] = data["users"][0]["user"]
        for user in users:
            name : str = user["name"]
            try:
                id : int = int(user["id"])
            except ValueError as error:
                raise ValueError(f"Error when trying to convert id from string to int: {error}")
            users_information.append((name, id))
        return users_information