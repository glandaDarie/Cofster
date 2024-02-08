from typing import Dict, Any, Tuple
from flask import jsonify, Blueprint, request
import sys

prompt_blueprint : Blueprint = Blueprint(name="prompt", import_name=__name__)

sys.path.append("../")

from utils.paths import ROOT_PATH
from utils.helpers import UserPromptGenerator

@prompt_blueprint.get("/prompt")
def prompt() -> Tuple[jsonify, int]:
    """
    Endpoint to retrieve user prompt information.

    Args:
        request.args.get("customer_name"): The username provided in the query parameters.

    Returns:
        jsonify: JSON response containing user prompt information or error messages.

        Possible HTTP Status Codes:
        - 200: Successful response with user prompt information.
        - 400: Bad request if username is missing in the query parameters.
        - 500: Internal server error if there are issues fetching or processing user prompt information.
    """
    customer_name : str = request.args.get("customer_name")
    if customer_name is None:
        return jsonify({
            "error_message" : "Customer name is missing in the query parameters"
        }), 400

    userPromptGenerator : UserPromptGenerator = UserPromptGenerator(root_path=ROOT_PATH)
    user_prompt_information : Dict[str, Any] = userPromptGenerator.get_user_prompt_file_information(name=customer_name.lower())
    
    if "content" not in user_prompt_information:
        return jsonify({
            "error_message" : "Could not fetch the user prompt content.",
            "error_information" : f"Error information: {user_prompt_information['error_message']}"
        }), 500

    return jsonify(user_prompt_information), 200
