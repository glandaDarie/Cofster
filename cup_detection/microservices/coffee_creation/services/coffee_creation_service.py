from typing import Dict, Any
import requests
from requests import Response

class CoffeeCreationService:
    def __init__(self):
        pass

    def create_coffee(self, 
        base_url: str, 
        endpoint: str, 
        payload : Dict[str, Any], 
        headers : Dict[str, Any] = {"Content-Type" : "application/json"}, 
        timeout : float = 7, 
    ) -> str:    
        """
        Send a POST request to create coffee.

        Args:
            base_url (str): The base URL of the API.
            endpoint (str): The endpoint of the API.
            payload (Dict[str, Any]): The payload to be sent in the request.
            headers (Dict[str, Any], optional): The headers to be included in the request. Defaults to {"Content-Type" : "application/json"}.
            timeout (float, optional): The request timeout in seconds. Defaults to 7.

        Returns:
            Dict[str, Any]: A dictionary containing the output of the request, including any error messages.
        """
        if not isinstance(payload, dict):
            raise ValueError("Invalid parameter format: Expected a dictionary.")

        url : str = f"{base_url}/{endpoint}"
        error_message : None | str = None
        try:
            response : Response = requests.post(url, json=payload, headers=headers, timeout=timeout)
            response.raise_for_status()  
            status_code : int = response.status_code
            if status_code == 201:
                return response.coffee_recipe_information
        
        except requests.exceptions.Timeout:
            error_message = "Error: Request timed out."
        except requests.exceptions.RequestException as error:
            error_message = f"Error: An error occurred during the request: {error}"
        except Exception as error:
            error_message = f"Error: An unexpected error occurred: {error}"
        
        return error_message