from typing import Dict, List, Literal
from flask import Flask, Response, jsonify, request
from sqlalchemy import create_engine, Table, Row, MetaData, select, Engine, Select
from typing import Tuple
import os

from utils.constants import PROMPT_TEMPLATE
from services.open_ai_service import OpenAIService
from services.previous_prompt_service import PreviousPromptService
from utils.helpers import FileLoader, add_probabilities_using_bellman_equation
from utils.paths import COFFEE_CREATION_PATH

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
        prompt_recipe : str = PROMPT_TEMPLATE.format(coffee_name)
        previous_prompt_sevice : PreviousPromptService =  PreviousPromptService()
        # chat_history : List[str] = []
        # should write the changes to the file that are recieved from the prompt so you can read them later, 
        # inside the promptService I should also update that, fetch the data from the postgresql history database
        # work on the data, and pass it as param to generate an update prompt for the user given the information it has
        # it should returning back only the new prompt updated, and that thing should be the new data
        
        # OR
        
        # should fetch only the new prompt and save it in the text file, to use it later for the prompt service
        previous_prompt : str = previous_prompt_sevice.get_prompt(base_url="http://192.168.1.102:8050", \
                                                        endpoint="/user_prompt", \
                                                        customer_name=customer_name) 
        
        # should save the previous_prompt in the coffee_creation_data.txt -> previous_prompt["content"]
        file_loader : FileLoader = FileLoader(file_path=COFFEE_CREATION_PATH)
        file_loader.write_to_file(content=previous_prompt["content"])

        # work fetched data from the database with SQLAlchemy (formular input) and convert data to probabilities 
        # (newer data should have more importance than older one), add probabilities using window function (OVER with PARTITION BY) -> for replies 

        # add also probabilities using window function for all the questions
        # SELECT questionnaire.timestamp, questionnaire.question_1, questionnaire.question_2
        # FROM Questionnaire AS questionnaire
        # WHERE customer.name = customer_name;


        # get the data from the database for that specific user, something like:
        # SELECT question_1, question_2 from Questionnaire WHERE name = customer_name
        # should return a List[List[str]] back and that should be out chat history
        # chat_history.append(chat_history_prompt)

        
        # should create a function for handling this SQLAlchemy ORM code
        database : str = os.environ.get('POSTGRES_DB')
        username : str = os.environ.get('POSTGRES_USER')
        password : str = os.environ.get('POSTGRES_PASSWORD'),
        host : str = os.environ.get('POSTGRES_HOST', '127.0.0.1'),
        port : int = int(os.environ.get('POSTGRES_PORT', 5432))

        database_url : str = f"postgresql://{username}:{password}@{host}:{port}/{database}"
        engine : Engine = create_engine(url=database_url, echo=True)
        table_name : str = "questionnaire"
        metadata : MetaData = MetaData()

        questionnaire_table : Table = Table(name=table_name, metadata=metadata, autoload_with=engine)

        statement : Select = select([questionnaire_table.c.timestamp, questionnaire_table.c.question_1, questionnaire_table.c.question_2]) \
                    .where(questionnaire_table.c.column_name == customer_name) \
                    .order_by(questionnaire_table.c.timestamp)
        
        person_responses : List[str] = engine.execute(statement).fetchall()

        person_responses_with_probabilities : List[Tuple] = add_probabilities_using_bellman_equation(elements=person_responses)
        print(f"{person_responses_with_probabilities = }") # debugging as of now

        openai_service : OpenAIService = OpenAIService()
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
    