import sys
# Temporary workaround: Adding the parent directory to the sys.path
# This is necessary for relative imports to work in the current project structure.
# Please consider restructuring the project to eliminate the need for this workaround.
sys.path.append("../../")

from typing import List, Tuple, Dict, Pattern, AnyStr
from json import loads
from re import compile
from controllers.recipe_controller import RecipeController
from services.recipe_service import RecipeService
from utils.helpers import UserPromptGenerator
from utils.helpers import DataTansformer
import os

def test_llm_recipe() -> None:
    recipe_controller : RecipeController = RecipeController(RecipeService())
    expected_status_code : int = 200
    response : str = recipe_controller.get_recipe(base_url="http://192.168.1.102:8001/", endpoint="coffee_recipe", coffee_name="Mocha")
    response : Dict[Dict[str, int], Dict[str, str]] = loads(response)
    actual_status_code : int = response["status_code"]
    actual_ingredients : Dict[str, str] = loads(response["ingredients"])
    assert actual_status_code == expected_status_code, f"Actual: {actual_status_code}, Expected: {expected_status_code}"
    pattern : Pattern[AnyStr@compile] = compile(r"ingredient_\d+")
    assert all(pattern.match(key) for key in list(actual_ingredients.keys())), "All ingredient keys should match the pattern."

def test_generate_prompts() -> None:
    users_information : List[Tuple[str, int]] = [("text1", 1), ("text2", 2), ("text3", 3), ("text4", 4)] 
    current_path : str = os.path.dirname(os.path.dirname(os.getcwd()))
    userPromptGenerator : UserPromptGenerator = UserPromptGenerator(users_information=users_information, root_path=current_path) 
    actual : str = userPromptGenerator.create()
    expected : str = "Successfully generated the files and directories for each user"
    assert actual == expected, f"Actual: {actual}, Expected: {expected}"

def test_integration_functionality_of_data_transformer_with_prompt_generator() -> None:
    dataTansformer : DataTansformer = DataTansformer()
    users_information = dataTansformer \
        .fetch(base_url="https://2rbfw9r283.execute-api.us-east-1.amazonaws.com", endpoint="prod/users", params={"usersInformation" : "info"}) \
        .transform()
    if not all(isinstance(user_information[0], str) for user_information in users_information):
        raise TypeError("Not all elements at the first position are of type string.")
    if not all(isinstance(user_information[1], int) for user_information in users_information):
        raise TypeError("Not all elements at the second position are of type integer.")
    current_path : str = os.path.dirname(os.path.dirname(os.getcwd()))
    userPromptGenerator : UserPromptGenerator = UserPromptGenerator(users_information=users_information, root_path=current_path) 
    actual : str = userPromptGenerator.create()
    expected : str = "Successfully generated the files and directories for each user"
    assert actual == expected, f"Actual: {actual}, Expected: {expected}"

if __name__ == "__main__":
#     # test_llm_recipe()
#     # test_generate_prompts()
    test_integration_functionality_of_data_transformer_with_prompt_generator()
    
    