import sys
sys.path.append("../")

from typing import Dict, Pattern, AnyStr
from json import loads
from re import compile
from controllers.recipe_controller import RecipeController
from cup_detection.microservices.coffee_creation.services.recipe_service.recipe_llm_service import RecipeLlmService

def test_llm_recipe() -> None:
    recipe_controller : RecipeController = RecipeController(RecipeLlmService())
    expected_status_code : int = 200
    response : str = recipe_controller.get_recipe(base_url="http://192.168.1.102:8001/", endpoint="coffee_recipe", coffee_name="Mocha")
    response : Dict[Dict[str, int], Dict[str, str]] = loads(response)
    actual_status_code : int = response["status_code"]
    actual_ingredients : Dict[str, str] = loads(response["ingredients"])
    assert actual_status_code == expected_status_code, f"Actual: {actual_status_code}, Expected: {expected_status_code}"
    pattern : Pattern = compile(r"ingredient_\d+")
    assert all(pattern.match(key) for key in list(actual_ingredients.keys())), "All ingredient keys should match the pattern."
