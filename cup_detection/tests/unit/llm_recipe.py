from typing import Dict
import requests
from flask import Response

def get_llm_recipe(coffee_name : str) -> str:
    params : Dict[str] = {"coffee_name" : coffee_name}
    try:
        response : Response = requests.get("http:127.0.0.1:8001", params=params)
        assert response.status_code == 200, f"Request failed with status code {response.status_code}" 
        return response.json()
    except requests.exceptions.RequestException as exception:
        raise exception

if __name__ == "__main__":
    expected : str = "dummy for now"
    print(get_llm_recipe("Mocha"))
