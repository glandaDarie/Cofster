from typing import Dict, Any
import requests
import sys

sys.path.append("../")

from utils.helpers import url_builder

class PreviousPromptService:
    def __init__(self):
        pass

    def get_prompt(self, base_url : str, endpoint : str, **params : Dict[str, Any]) -> str:
        url : str = url_builder(base_url=base_url, endpoint=endpoint)
        response_data : requests.Response = requests.get(url=url, params=params)
        status_code : int = response_data["status_code"]
        if status_code != 200:
            raise RuntimeError(f"Error: {response_data['error_message']}")
        return response_data["prompt"]