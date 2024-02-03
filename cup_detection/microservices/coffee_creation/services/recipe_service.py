from typing import Dict, List
import os
import requests
import json
from requests.models import Response

class RecipeService:
    def get_recipe(self, base_url: str, endpoint: str, **params: Dict[str, str]) -> str:        
        if not isinstance(params, dict):
            return json.dumps({
                "status_code": 400,
                "error": "Invalid parameter format: Expected a dictionary."
            })
        url : str = os.path.join(base_url, endpoint)
        try:
            response : Response = requests.get(url=url, params=params)
            status_code : int = response.status_code
            if status_code == 200:
                try:
                    data : Dict[str, Dict[str, str]] = json.loads(response.text)
                    keys : List[str] = list(data.keys())
                    if not isinstance(data, dict):
                        return json.dumps({
                            "status_code": 400,
                            "error": "Invalid response format: Expected a dictionary."
                        })
                    if len(keys) != 1:
                        return json.dumps({
                            "status_code": 500,
                            "error": "The output from the LLM is not in the correct shape."
                        })
                    return json.dumps({
                        "status_code": 200,
                        "ingredients": json.dumps(data[keys[-1]])
                    })
                except ValueError as json_error:
                    return json.dumps({
                        "status_code": 500,
                        "error": f"Failed to parse JSON response: {json_error}"
                    })
            return json.dumps({
                "status_code": f"Request failed with status code: {status_code}",
            })
        except requests.exceptions.RequestException as request_exception:
            return json.dumps({
                "status_code": 500,
                "error": f"Request failed: {request_exception}"
            })
    
    def update_recipe(self, base_url : str, endpoint : str, **params : Dict[str, str]) -> str:
        pass