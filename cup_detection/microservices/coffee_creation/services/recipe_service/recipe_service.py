from typing import Dict
from abc import ABC, abstractclassmethod

class RecipeService(ABC):
    @abstractclassmethod
    def get_recipe(self, base_url: str, endpoint: str, **params: Dict[str, str]) -> str:   
        pass

