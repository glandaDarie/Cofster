from typing import Dict, Any
import sys

sys.path.append("../")

from controllers.recipe_controller import RecipeController
from services.recipe_service.recipe_service import RecipeService
from services.recipe_service.recipe_llm_service import RecipeLlmService
from services.recipe_service.recipe_database_service import RecipeDatabaseService
from utils.exceptions import NoRecipeException
from enums.recipe_types import RecipeType

class RecipeSimpleFactory:
    @staticmethod
    def create(recipe_type : str, customer_data : Dict[str, Any]) -> Dict[str, Any]:
        if recipe_type == RecipeType.llm.value:
            # should be changed with the containers IP, so RPI and the rest of microservices should communicate
            recipe_service : RecipeService = RecipeController(RecipeLlmService()) \
            .get_recipe(
                base_url="http://127.0.0.1:8030", \
                endpoint="/coffee_recipe", \
                coffee_name=customer_data["coffee_name"],
                customer_name=customer_data["customer_name"]
            )
        elif recipe_type == RecipeType.recipe.value:
            recipe_service : RecipeService = RecipeController(RecipeDatabaseService()) \
            .get_recipe(
                base_url="https://ood8852240.execute-api.us-east-1.amazonaws.com/prod", \
                endpoint="/drink_information", \
                drinkId="100", \
                drink=customer_data["coffee_name"]
            )
        else:
            raise NoRecipeException(f"No such recipe type implemented: {recipe_type}")

        return recipe_service