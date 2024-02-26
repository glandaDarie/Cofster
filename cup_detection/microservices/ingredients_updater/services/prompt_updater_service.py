from typing import List, Tuple
from sqlalchemy import DateTime, String
from sqlalchemy.exc import NoSuchTableError
from sqlalchemy.orm.query import Query
from services.questionnaire_database_service import QuestionnaireDatabaseService
from services.open_ai_service import OpenAIService
from services.previous_prompt_service import PreviousPromptService

import sys
sys.path.append("\..")

from utils.helpers import Convertor, concat_probabilities_using_bellman_equation
from utils.exceptions import LLMResponseError
from utils.logger import LOGGER

class PromptUpdaterService:
    def __init__(self, questionnaire_database_service : QuestionnaireDatabaseService, openai_service : OpenAIService):
        self.questionnaire_database_service : QuestionnaireDatabaseService = questionnaire_database_service
        self.openai_service : OpenAIService = openai_service

    def __call__(self, customer_name : str, prompt_recipe : str, model : str = "gpt-3.5-turbo", temperature_prompt : float = 0, limit_nr_responses : int = 10) -> str | None:
        try:
            person_responses : Query[Tuple[DateTime, String, String]] = self.questionnaire_database_service.get_customer_responses(\
                                                                                        customer_name=customer_name, \
                                                                                        limit_nr_responses=limit_nr_responses)
            chat_history : List[Tuple[DateTime, String, String, float]] \
                = Convertor.stringify_items(concat_probabilities_using_bellman_equation(elements=person_responses))
            prompt_recipe : str = prompt_recipe.format(str(chat_history))
            new_user_file_prompt : str = self.openai_service(prompt=prompt_recipe, model=model, temperature_prompt=temperature_prompt, chat_history=[])

            print(f"API call GPT 3.5 response: {new_user_file_prompt}")

            if "I don't know".lower() == new_user_file_prompt.lower() or "I don't know".lower() in new_user_file_prompt.lower():
                raise LLMResponseError(f"No LLM response available, response is: {new_user_file_prompt}")

            response_information : str = PreviousPromptService.put_new_prompt( \
                base_url="http://user-file-prompt-updater:8050", \
                endpoint="/prompt", \
                body_data={ \
                    "customer_name" : customer_name, \
                    "prompt" : new_user_file_prompt, \
                }, \
                headers={'Content-Type': 'application/json'}, \
                timeout=7, \
            )

            LOGGER.info(f"Message: {response_information}")
            
            # should make here a PUT request to the endpoint "http://user-file-prompt-updater:8050/prompt?name=passed_name" 
            # to update the given file with that respective name. Body params should be { name : param_name, user_file_prompt : new_user_file_prompt}

        except NoSuchTableError as table_error:
            error_msg : str = f"Table {self.questionnaire_database_service.table_name} could not be found in the database. Error: {table_error}"
            return error_msg