from typing import Dict, List, Any
import requests
from requests.models import Response
from services.recipe_service.recipe_service import RecipeService

class RecipeDatabaseService(RecipeService):
    def get_recipe(self, base_url: str, endpoint: str, **params: Dict[str, str]) -> str:
        """
        Get recipe data from the specified endpoint with optional query parameters.

        Args:
            base_url (str): The base URL of the API.
            endpoint (str): The endpoint to fetch the recipe data from.
            **params (Dict[str, str]): Optional query parameters.

        Returns:
            Dict[str, Any]: The recipe data returned from the API.

        Raises:
            ValueError: If the parameters are not in the correct format or if there are issues with the response.
        """
        if not isinstance(params, dict):
            raise ValueError("Invalid parameter format: Expected a dictionary.")
        
        url : str = f"{base_url}/{endpoint}"
        try:
            response : Response = requests.get(url=url, params=params)
            response.raise_for_status() 
            
            data : Dict[str, Any] = response.json()

            if data is None:
                raise ValueError("Error: problems when parsing the JSON")

            status_code : int = data["statusCode"]
            if data["statusCode"] != 200:
                raise ValueError(f"Error: status code: {status_code} appeard from error {data}")
            
            body : Dict[str, Any] = data["body"][0]
            print(f"{body = }")
            ingredients : List[Dict[str, str]] = body.get("ingredients")
            if not ingredients:
                raise ValueError("Error: No ingredients found in the response")

            recipe : Dict[str, str] = ingredients[0]
            return recipe
        
        except requests.exceptions.RequestException as request_exception:
            raise ValueError(f"Request failed: {request_exception}")