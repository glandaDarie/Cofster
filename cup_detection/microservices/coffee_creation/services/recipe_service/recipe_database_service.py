from typing import Dict, List, Any
import os
import requests
import json
from requests.models import Response
from services.recipe_service.recipe_service import RecipeService

class RecipeDatabaseService(RecipeService):
    def get_recipe(self, base_url: str, endpoint: str, **params: Dict[str, str]) -> str:
        if not isinstance(params, dict):
            raise ValueError("Invalid parameter format: Expected a dictionary.")

        url : str = os.path.join(base_url, endpoint)

        try:
            response : Response = requests.get(url=url, params=params)
            response.raise_for_status() 
            
            data : Dict[str, Any] = response.json()
            if data is None:
                raise ValueError("Error: problems when parsing the JSON")
            return data
        
        except requests.exceptions.RequestException as request_exception:
            raise ValueError(f"Request failed: {request_exception}")
    
    def update_recipe(self, base_url : str, endpoint : str, **params : Dict[str, str]) -> str:
        pass