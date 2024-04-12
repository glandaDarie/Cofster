from typing import Dict
from abc import ABC

class RecipeService(ABC):
    def get_recipe(self, base_url: str, endpoint: str, **params: Dict[str, str]) -> str:   
        pass
