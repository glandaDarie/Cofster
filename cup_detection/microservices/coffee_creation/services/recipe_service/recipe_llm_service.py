from typing import Dict, List, Any
import requests
import json
from requests.models import Response
from services.recipe_service.recipe_service import RecipeService
from urllib.parse import urljoin

class RecipeLlmService(RecipeService):
    def get_recipe(self, base_url: str, endpoint: str, **params: Dict[str, str]) -> Dict[str, Any]:   
        if not isinstance(params, dict):
            raise ValueError("Invalid parameter format: Expected a dictionary.")

        url : str = urljoin(base=base_url, url=endpoint)
        try:
            response : Response = requests.get(url=url, params=params)
            response.raise_for_status() 
            
            str_data : str = json.loads(response.text)
            data : Dict[str, Any] = json.loads(str_data)
            keys : List[str] = list(data.keys()) 
            if len(keys) <= 0:
                raise ValueError("The output from the LLM is not in the correct shape.")
            
            return data
    
        except requests.exceptions.RequestException as request_exception:
            raise ValueError(f"Request failed: {request_exception}")

        except json.JSONDecodeError as json_error:
            raise ValueError(f"Failed to parse JSON response: {json_error}")

        except ValueError as value_error:
            raise ValueError(str(value_error))