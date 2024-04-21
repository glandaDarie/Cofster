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
from utils.logger import LOGGER

class PromptUpdaterService:
    def __init__(self, openai_service : OpenAIService, questionnaire_database_service : QuestionnaireDatabaseService | None = None):
        self.openai_service : OpenAIService = openai_service
        self.questionnaire_database_service : QuestionnaireDatabaseService = questionnaire_database_service

    def __call__(self, customer_name : str, coffee_name : str, prompt : str, model : str = "gpt-3.5-turbo", temperature_prompt : float = 0, limit_nr_responses : int = 10) -> str | None:
        try:
            if self.questionnaire_database_service is not None:
                person_responses : Query[Tuple[DateTime, String, String]] = self.questionnaire_database_service.get_customer_responses(\
                                                                                            customer_name=customer_name, \
                                                                                            coffee_name=coffee_name, \
                                                                                            limit_nr_responses=limit_nr_responses)
                chat_history : List[Tuple[DateTime, String, String, float]] \
                    = Convertor.stringify_items(concat_probabilities_using_bellman_equation(elements=person_responses))
                prompt : str = prompt.format(str(chat_history))

            data : str = self.openai_service(prompt=prompt, model=model, temperature_prompt=temperature_prompt, chat_history=[])
            LOGGER.info(f"GPT 3.5 response: {data}")

            if "I don't know".lower() == data.lower() or "I don't know".lower() in data.lower():
                return f"No LLM response available. LLM said {data}"

            if self.questionnaire_database_service is not None:
                response_information : str = PreviousPromptService.put_new_prompt( \
                    base_url="http://user-file-prompt-updater:8050", \
                    endpoint="/prompt", \
                    body_data={ \
                        "customer_name" : customer_name, \
                        "coffee_name" : coffee_name, \
                        "prompt" : data, \
                    }, \
                    headers={'Content-Type': 'application/json'}, \
                    timeout=7, \
                )
                LOGGER.info(f"Message: {response_information}")
            else:
                LOGGER.info(f"Data: {data}")
                return data
            
        except NoSuchTableError as table_error:
            error_msg : str = f"Table {self.questionnaire_database_service.table_name} could not be found in the database. Error: {table_error}"
            return error_msg