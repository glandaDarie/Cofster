from utils.helpers import UserPromptGenerator
from services.data_transformer_service import DataTransformerService
from daos.data_transformer_dao import DataTransformerDAO
from schedule import every, repeat, run_pending
from time import sleep
from utils.logger import LOGGER
from utils.paths import ROOT_PATH
from threading import Thread
from flask import Flask
from routes.prompt import prompt_blueprint, prompt_update_blueprint

@repeat(every(10).seconds) # test
# @repeat(every(4).minutes) # prod
def format_and_generate_prompt_hierarchial_structure_for_users() -> None | TypeError | ValueError:
    """
    Fetches user information, transforms it, generates prompts based on the information, and logs the job information.

    This function utilizes a scheduler to repetitively execute a set of tasks. It fetches user information from a specified API,
    transforms the data, generates prompts, and logs the job information periodically.

    Raises:
        TypeError: If the fetched user information does not conform to the expected data types.
        ValueError: If it cannot updater the prompt hierarchy.

    Note:
        This function is designed to be used with a scheduler to run periodically.
    """
    data_tansformer_service : DataTransformerService = DataTransformerService(data_transformer_dao=DataTransformerDAO())
    users_information = data_tansformer_service \
        .fetch(base_url="https://2rbfw9r283.execute-api.us-east-1.amazonaws.com", endpoint="prod/users", params={"usersInformation" : "info"}) \
        .transform() \
        .collect()
    
    if not all(isinstance(user_information[0], str) for user_information in users_information):
        raise TypeError("Not all elements at the first position are of type string.")
    if not all(isinstance(user_information[1], int) for user_information in users_information):
        raise TypeError("Not all elements at the second position are of type integer.")
    LOGGER.info(f"--USERS INFORMATION-- : {users_information}")

    user_prompt_generator : UserPromptGenerator = UserPromptGenerator(root_path=ROOT_PATH, users_information=users_information) 
    user_prompt_response : str = user_prompt_generator.generate()
    LOGGER.info(f"--JOB INFORMATION-- : {user_prompt_response}")

app = Flask(__name__)

app.register_blueprint(blueprint=prompt_blueprint)
app.register_blueprint(blueprint=prompt_update_blueprint)

if __name__ == "__main__":
    thread_web_server : Thread = Thread(target=lambda : app.run(host="0.0.0.0", port=8050, debug=True, use_reloader=False))
    thread_web_server.start()
    while True:
        run_pending()
        sleep(1)