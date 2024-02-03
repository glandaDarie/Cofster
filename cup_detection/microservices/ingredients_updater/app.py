from typing import Dict, Literal
from flask import Flask, Response, jsonify, request
import sys
from typing import Tuple
# import requests

# Temporary workaround: Adding the parent directory to the sys.path
# This is necessary for relative imports to work in the current project structure.
# Please consider restructuring the project to eliminate the need for this workaround.
sys.path.append("../")

from utils.constants import PROMPT_TEMPLATE
from services.open_ai_service import OpenAIService

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
        # response_data : Response = requests.get(url="http://192.168.1.102:8030/user_prompt", params={"customer_name" : customer_name})
        # status_code : int = response_data["status_code"]
        # if status_code != 200:
        #     raise(f"Error: {response_data['error_message']}")
        # chat_history : str = response_data["chat_history"]
        # coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt_recipe, chat_history=chat_history)
        coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt_recipe)
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
    