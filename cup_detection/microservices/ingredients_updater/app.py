from typing import Dict, List, Tuple, Literal, Any
from flask import Flask, Response, jsonify, request
from sqlalchemy import create_engine, Table, MetaData, Engine, desc, String, DateTime
from sqlalchemy.exc import NoSuchTableError
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm.query import Query
from sqlalchemy.engine.row import Row
from requests.exceptions import RequestException

# from utils.constants import PROMPT_TEMPLATE
from services.open_ai_service import OpenAIService
from services.previous_prompt_service import PreviousPromptService
from utils.helpers import FileLoader, Arguments, concat_probabilities_using_bellman_equation
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
    # coffee_name : str = request.args.get("coffee_name")

    if not customer_name or not isinstance(customer_name, str):
        return jsonify({"error" : "Customer was not provided correctly"}), 400
    
    try:
        # prompt_recipe : str = PROMPT_TEMPLATE.format(coffee_name)

        previous_prompt_sevice : PreviousPromptService =  PreviousPromptService()
        # chat_history : List[str] = []
        # should write the changes to the file that are recieved from the prompt so you can read them later, 
        # inside the promptService I should also update that, fetch the data from the postgresql history database
        # work on the data, and pass it as param to generate an update prompt for the user given the information it has
        # it should returning back only the new prompt updated, and that thing should be the new data
        
        # OR
        
        # should fetch only the new prompt and save it in the text file, to use it later for the prompt service
        prompt : str = previous_prompt_sevice.get_prompt(base_url="http://user-file-prompt-updater:8050", \
                                                        endpoint="/prompt", \
                                                        customer_name=customer_name) 
        print(f"Actual prompt recieved: {prompt}") # check the prompt for debugging purposes

        # should save the previous_prompt in the coffee_creation_data.txt -> previous_prompt["content"]
        file_loader : FileLoader = FileLoader(file_path=COFFEE_CREATION_PATH)
        file_loader.write_to_file(content=prompt)

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

        arguments : Dict[str, Any] = Arguments.database_arguments()
        # should create a function for handling this SQLAlchemy ORM code
        database_url : str = f"postgresql://{arguments['username']}:{arguments['password']}@{arguments['host']}:{arguments['port']}/{arguments['database']}"
        engine : Engine = create_engine(url=database_url, echo=True)
        table_name : str = "questionnaire"
        metadata : MetaData = MetaData()

        try:
            metadata.reflect(bind=engine)
            questionnaire_table : Table = metadata.tables.get(table_name)

            if questionnaire_table is None:
                raise NoSuchTableError(f"Table {table_name} could not be found in the reflected metadata.")

            Session = sessionmaker(bind=engine)
            session = Session()

            person_query : Query[Tuple[DateTime, String, String]] = session.query( \
                questionnaire_table.c.timestamp, \
                questionnaire_table.c.question_1, \
                questionnaire_table.c.question_2 \
            ) \
                .filter(questionnaire_table.c.user_name == customer_name) \
                .order_by(desc(questionnaire_table.c.timestamp)) 
            
            person_responses : List[Row] = person_query.all()

            person_responses_with_probabilities : List[Tuple[DateTime, String, String, float]] = \
                concat_probabilities_using_bellman_equation(elements=person_responses)
            
            print(f"{person_responses_with_probabilities = }") 
        
            # openai_service : OpenAIService = OpenAIService()
            # coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt_recipe)
            # coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt_recipe, chat_history=chat_history)
            # response : Dict[str, str] = {
            #     "ingredients": coffee_ingredients
            # }

        except NoSuchTableError as table_error:
            error_msg : str = f"Table {table_name} could not be found in the database. Error: {table_error}"
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

    return jsonify({"message" : "correct_dummy"}), 200    

def __put_coffee_recipe() -> Tuple[Response, int]:
    #TODO
    pass

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8030)
    