from typing import Dict, List, Literal
from flask import Flask, Response, jsonify, request
import sys
from typing import Any, Tuple

sys.path.append("../")

from utils.constants import PROMPT_TEMPLATE
from services.open_ai_service import OpenAIService
from services.previous_prompt_service import PreviousPromptService

app = Flask(__name__)

@app.route("/coffee_recipe", methods=["GET", "PUT"])
def coffee_recipe() -> (tuple[Response, Literal[200]] | None):
    if request.method == "GET":
        return __get_coffee_recipe()
    elif request.method == "PUT":
        return __put_coffee_recipe()
    else:
        return "Method Not Allowed", 405

def __get_coffee_recipe() -> Tuple[Response, int]:
    coffee_name : str = request.args.get("coffee_name")
    customer_name : str = request.args.get("customer_name")
    if not coffee_name or not customer_name:
        return jsonify({"error", "Parameters we're not provided correctly"}), 400
    try:
        openai_service : OpenAIService = OpenAIService()
        prompt_recipe : str = PROMPT_TEMPLATE.format(coffee_name)
        previousPromptService : PreviousPromptService =  PreviousPromptService()
        chat_history : List[str] = []
        # should write the changes to the file that are recieved from the prompt so you can read them later, 
        # inside the promptService I should also update that, fetch the data from the postgresql history database
        # work on the data, and pass it as param to generate an update prompt for the user given the information it has
        # it should returning back only the new prompt updated, and that thing should be the new data
        
        # OR
        
        # should fetch only the new prompt and save it in the text file, to use it later for the prompt service
        chat_history_prompt : str = previousPromptService.get_prompt(base_url="http://192.168.1.102:8050", \
                                                        endpoint="/user_prompt", \
                                                        customer_name=customer_name)
        # get the data from the database for that specific user, something like:
        # SELECT question_1, question_2 from Questionnaire WHERE name = customer_name
        # should return a List[List[str]] back and that should be out chat history
        chat_history.append(chat_history_prompt)
        coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt_recipe)
        # coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt_recipe, chat_history=chat_history)
        response : Dict[str, str] = {
            "ingredients": coffee_ingredients
        }
    except Exception as exception:
        return jsonify({"error" : f"Server side error: {exception}"}), 500
    return jsonify(response), 200

def __put_coffee_recipe() -> Tuple[Response, int]:
    #TODO
    pass

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8030)
    