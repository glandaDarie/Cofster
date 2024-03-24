from typing import Dict
from cup_detection.microservices.coffee_creation.services.recipe_service.recipe_service import RecipeService

class RecipeController:
    def __init__(self, recipe_service : RecipeService):
        self.recipe_service : RecipeService = recipe_service
    
    def get_recipe(self, base_url : str, endpoint : str, **params : Dict[str, str]) -> str:
        return self.recipe_service.get_recipe(base_url=base_url, endpoint=endpoint, **params)
    
    def update_recipe(self, base_url : str, endpoint : str, **params : Dict[str, str]) -> None:
        pass