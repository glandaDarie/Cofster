from typing import Dict, Any
from flask import jsonify, Blueprint, request
import sys

prompt_blueprint : Blueprint = Blueprint(name="prompt", import_name=__name__)

sys.path.append("../")

from utils.paths import ROOT_PATH
from utils.helpers import UserPromptGenerator

@prompt_blueprint.get("/prompt")
def prompt():
    user_name : str = request.args.get("customer_name")
    if user_name is None:
        return jsonify({
            "error" : "Username is missing in the query parameters"
        }), 400
    
    userPromptGenerator : UserPromptGenerator = UserPromptGenerator(root_path=ROOT_PATH)
    user_prompt_information : Dict[str, Any] = userPromptGenerator.get_user_prompt_file_information(name=user_name)
    
    if "error_message" in user_prompt_information:
        return jsonify(user_prompt_information), 500
    
    if not user_prompt_information["content"] or user_prompt_information["content"] is None:
        return jsonify({
            "error" : "Could not fetch the user prompt content."
        }), 500
    
    return jsonify(user_prompt_information), 200
