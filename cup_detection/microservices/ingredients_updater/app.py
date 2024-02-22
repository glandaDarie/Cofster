from typing import Dict, Tuple, Literal, Any
from flask import Flask, Response, jsonify, request
from requests.exceptions import RequestException
from services.open_ai_service import OpenAIService
from services.previous_prompt_service import PreviousPromptService
from services.questionnaire_database_service import QuestionnaireDatabaseService
from services.prompt_updater_service import PromptUpdaterService
from utils.helpers import FileLoader, Arguments
from utils.paths import COFFEE_CREATION_PATH
from utils.logger import LOGGER
from utils.constants import PROMPT_TEMPLATE

app = Flask(__name__)

@app.route("/coffee_recipe", methods=["GET", "PUT"])
def coffee_recipe() -> (tuple[Response, Literal[200]] | None):
    if request.method == "GET":
        return __get_coffee_recipe()
    elif request.method == "PUT":
        return __put_coffee_recipe()
    else:
        return jsonify({
            "error_message" : "Method Not Allowed"
        }), 405

def __get_coffee_recipe() -> Tuple[Response, int]:
    customer_name : str = request.args.get("customer_name")
    coffee_name : str = request.args.get("coffee_name")

    if not customer_name or not isinstance(customer_name, str):
        return jsonify({"error" : "Customer was not provided correctly"}), 400
    
    prompt_recipe : str = PROMPT_TEMPLATE.format(coffee_name) if coffee_name and isinstance(coffee_name, str) else PROMPT_TEMPLATE

    try:
        previous_prompt_sevice : PreviousPromptService =  PreviousPromptService() 
        prompt : str = previous_prompt_sevice.get_prompt(base_url="http://user-file-prompt-updater:8050", \
                                                        endpoint="/prompt", \
                                                        customer_name=customer_name) 

        file_loader : FileLoader = FileLoader(file_path=COFFEE_CREATION_PATH)
        file_loader.write_to_file(content=prompt)

        arguments : Dict[str, Any] = Arguments.database_arguments()
        database_url : str = f"postgresql://{arguments['username']}:{arguments['password']}@{arguments['host']}:{arguments['port']}/{arguments['database']}"

        prompt_updater_service : PromptUpdaterService = PromptUpdaterService(\
            questionnaire_database_service=QuestionnaireDatabaseService(database_url=database_url, table_name="questionnaire"),
            openai_service=OpenAIService(file_path=COFFEE_CREATION_PATH)
        )

        prompt_updater_service_params : Dict[str, Any] = {
            "customer_name" : customer_name,
            "prompt_recipe" : prompt_recipe,
            "model" : "gpt-3.5-turbo-0125",
            # "model" : "gpt-4-0125-preview",
            "temperature_prompt" : 0,
            "limit_nr_responses" : 10
        }

        error_msg : str = prompt_updater_service(**prompt_updater_service_params)
        if error_msg:
            return jsonify({"error" : error_msg}), 500

    except RequestException as network_error:
        if "Failed to establish a new connection" in str(network_error):
            error_msg : str = "Failed to establish a connection to the server. Please check your network connection."
        else:
            error_msg : str = f"An error occurred during the network request: {network_error}"
        LOGGER.error(error_msg)
        return jsonify({"error": error_msg}), 500
    
    except FileNotFoundError as file_error:
        error_msg : str = f"An error occurred while writing to the file: {file_error}"
        LOGGER.error(error_msg)
        return jsonify({"error": error_msg}), 500

    return jsonify({"message" : "correct_dummy"}), 200 # this needs to change  

def __put_coffee_recipe() -> Tuple[Response, int]:
    #TODO
    pass

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8030)
    