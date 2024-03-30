import sys
sys.path.append("../")

from services.data_transformer_service import DataTransformerService
from daos.data_transformer_dao import DataTransformerDAO

from utils.helpers import UserPromptGenerator
from utils.paths import ROOT_PATH

def test_integration_functionality_of_data_transformer() -> None:
    data_transformer : DataTransformerService = DataTransformerService(data_transformer_dao=DataTransformerDAO())
    users_information = data_transformer \
        .fetch(base_url="https://p5niyz4q2e.execute-api.us-east-1.amazonaws.com", endpoint="prod/users", params={"usersInformation" : "info"}) \
        .transform() \
        .collect()
    
    if not all(isinstance(user_information[0], str) for user_information in users_information):
        raise TypeError("Not all elements at the first position are of type string.")
    if not all(isinstance(user_information[1], int) for user_information in users_information):
        raise TypeError("Not all elements at the second position are of type integer.")
    
    user_prompt_generator : UserPromptGenerator = UserPromptGenerator(users_information=users_information, root_path=ROOT_PATH) 
    actual : str = user_prompt_generator.generate()
    expected : str = "Successfully generated the directories and files for each user"
    assert "Success" in actual, f"Actual: {actual}, Expected: {expected}"