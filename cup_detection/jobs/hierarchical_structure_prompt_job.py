import sys
# Temporary workaround: Adding the parent directory to the sys.path
# This is necessary for relative imports to work in the current project structure.
# Please consider restructuring the project to eliminate the need for this workaround.
sys.path.append("../")

from utils.helpers import UserPromptGenerator
from utils.helpers import DataTansformer
from schedule import every, repeat, run_pending
from time import sleep
from utils.logger import LOGGER
from utils.paths import PATH_ROOT

# @repeat(every(4).minutes)
@repeat(every(10).seconds)
def format_and_generate_prompt_hierarchial_structure_for_users():
    """
    Fetches user information, transforms it, generates prompts based on the information, and logs the job information.

    This function utilizes a scheduler to repetitively execute a set of tasks. It fetches user information from a specified API,
    transforms the data, generates prompts, and logs the job information periodically.

    Raises:
        TypeError: If the fetched user information does not conform to the expected data types.

    Note:
        This function is designed to be used with a scheduler to run periodically.
    """
    data_tansformer : DataTansformer = DataTansformer()
    users_information = data_tansformer \
        .fetch(base_url="https://2rbfw9r283.execute-api.us-east-1.amazonaws.com", endpoint="prod/users", params={"usersInformation" : "info"}) \
        .transform()
    if not all(isinstance(user_information[0], str) for user_information in users_information):
        raise TypeError("Not all elements at the first position are of type string.")
    if not all(isinstance(user_information[1], int) for user_information in users_information):
        raise TypeError("Not all elements at the second position are of type integer.")
    user_prompt_generator : UserPromptGenerator = UserPromptGenerator(users_information=users_information, root_path=PATH_ROOT) 
    message : str = user_prompt_generator.generate()
    LOGGER.info(f"--JOB INFORMATION-- : {message}")

if __name__ == "__main__":
    while True:
        run_pending()
        sleep(1)