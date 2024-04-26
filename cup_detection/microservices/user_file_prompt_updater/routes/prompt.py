from typing import Dict, Any, Tuple
from flask import jsonify, Blueprint, request
import os
import sys

prompt_blueprint : Blueprint = Blueprint(name="prompt", import_name=__name__)
prompt_update_blueprint : Blueprint = Blueprint(name="update_prompt", import_name=__name__)

sys.path.append("../")

from utils.paths import ROOT_PATH
from utils.logger import LOGGER
from utils.helpers import UserPromptGenerator, IOFile, get_prompt_information
from services.prompt_convertor_builder_service import PromptConvertorBuilderService

@prompt_blueprint.get("/prompt")
def get_prompt() -> Tuple[jsonify, int]:
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
    coffee_name : str = request.args.get("coffee_name")
    
    LOGGER.info(f"Customer_name: {customer_name}")

    if customer_name is None:
        return jsonify({
            "error_message" : "Customer name is missing in the query parameters"
        }), 400

    user_prompt_generator : UserPromptGenerator = UserPromptGenerator(root_path=ROOT_PATH)

    user_prompt_information : Dict[str, Any] = user_prompt_generator.get_user_prompt_file_information( \
        customer_name=customer_name.lower(), \
        coffee_name=coffee_name \
    )
    
    if "content" not in user_prompt_information:
        return jsonify({
            "error_message" : "Could not fetch the user prompt content.",
            "error_information" : f"Error information: {user_prompt_information['error_message']}"
        }), 500

    return jsonify(user_prompt_information), 200

@prompt_update_blueprint.put("/prompt")
def update_prompt() -> Tuple[jsonify, int]:
    """
    Handles HTTP PUT request for updating prompt information.

    Returns:
        Tuple[jsonify, int]: A tuple containing a JSON response and an HTTP status code.
            - If the request is invalid or missing parameters, returns a 400 status code with an error message.
            - If an unexpected error occurs, returns a 500 status code with an error message.
            - If the update is successful, returns a 200 status code with a success message.
    """
    try:
        if not request.is_json:
            return jsonify({
                "error_message" : "Invalid request. Content-Type must be application/json."
            }), 400

        data : Any = request.get_json()
        LOGGER.info(f"Data: {data}")

        if not "customer_name" in data:
            return jsonify({
                "error_message" : "Missing required parameter 'customer_name' in the request body."
            }), 400
        
        if not "coffee_name" in data:
            return jsonify({
                "error_message" : "Missing required parameter 'coffee_name' in the request body."
            }), 400

        if not "prompt" in data:
            return jsonify({
                "error_message" : "Missing required parameter 'prompt' in the request body."
            }), 400
        
        customer_name : str = data["customer_name"]
        coffee_name : str = data["coffee_name"]
        prompt : str = data["prompt"]

        prompt_information = get_prompt_information( \
            prompt_files_path=os.path.join(ROOT_PATH, "assets", "users_prompt_files"), \
            customer_name=customer_name.lower(), \
            coffee_name=coffee_name, \
            updated_prompt=prompt, \
            file_dependency=IOFile \
        )

        if isinstance(prompt_information, str):
            LOGGER.error(f"Error updating prompt: {prompt_information}")
            return jsonify({
                "error_message" : prompt_information
            }), 400
        
        new_prompt_information, old_prompt, user_file_path = prompt_information

        UserPromptGenerator.update_and_save_prompt_to_specific_user_file( \
            user_file_path=user_file_path, \
            prompt_convertor_builder_service_dependency=PromptConvertorBuilderService( \
                coffee_name=coffee_name, \
                new_prompt_information=new_prompt_information, \
                old_prompt=old_prompt, \
            ), \
            file_dependency=IOFile, \
        )

        return jsonify( {
            "message": f"Update on the prompt for customer {data['customer_name']} was done successfully."
        }), 200
    
    except Exception as error:
        LOGGER.error(f"An unexpected error occurred: {error}")
        return jsonify({"error_message": "An unexpected error occurred. Please try again later."}), 500