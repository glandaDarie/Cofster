from typing import Dict, List, Literal, Any
from flask import Flask, Response, jsonify, request
from sqlalchemy import create_engine, Table, MetaData, Engine, func, String, DateTime 
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm.query import Query
from typing import Tuple
# from utils.constants import PROMPT_TEMPLATE
from services.open_ai_service import OpenAIService
from services.previous_prompt_service import PreviousPromptService
from utils.helpers import FileLoader, Arguments, concat_probabilities_using_bellman_equation
from utils.paths import COFFEE_CREATION_PATH
from utils.logger import LOGGER

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
    # coffee_name : str = request.args.get("coffee_name")
    customer_name : str = request.args.get("customer_name")
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
        # print(f"Actual prompt recieved: {prompt}")

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
                raise RuntimeError(f"Table {table_name} could not be found in the reflected metadata.")

            Session = sessionmaker(bind=engine)
            session = Session()

            row_count = session.query(func.count().label('row_count')).select_from(questionnaire_table).scalar()
            print(f"Number of rows in the 'questionnaire' table: {row_count}")

            # statement : Select = select([questionnaire_table.c.timestamp, questionnaire_table.c.question_1, questionnaire_table.c.question_2]) \
            #     .where(questionnaire_table.c.column_name == customer_name) \
            #     .order_by(questionnaire_table.c.timestamp)
            # : Query[Tuple[DateTime, String, String]]
            person_query = session.query( \
                questionnaire_table.c.timestamp, \
                questionnaire_table.c.question_1, \
                questionnaire_table.c.question_2 \
            ) \
                .filter(questionnaire_table.c.user_name == customer_name) \
                .order_by(questionnaire_table.c.timestamp) 
            
            person_responses : List[Tuple[DateTime, String, String]] = person_query.all()

            # print(f"person_responses: {person_responses}")
            # THIS WORKS

            person_responses_with_probabilities : List[Tuple[DateTime, String, String, float]] = \
                concat_probabilities_using_bellman_equation(elements=person_responses)
            
            print(f"{person_responses_with_probabilities = }") # debugging as of now
        
            # openai_service : OpenAIService = OpenAIService()
            # coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt_recipe)
            # coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt_recipe, chat_history=chat_history)
            # response : Dict[str, str] = {
            #     "ingredients": coffee_ingredients
            # }

        except Exception as error:
            LOGGER.error(f"Table {table_name} could not be found in the database. Error: {error}")
            raise 
    except Exception as exception:
        return jsonify({"error" : f"Server side error: {exception}"}), 500
    
    return jsonify({"message" : "correct_dummy"}), 200    
    
        # print(f"All tables: {metadata.tables['questionnaire']}")

    #     try:
    #         questionnaire_table : Table = Table(table_name, metadata, autoload_with=engine)
    #     except Exception as error:
    #         print(f"Table {table_name} could not be found in the database. Error: {error}")
    #         LOGGER.error(f"Table {table_name} could not be found in the database. Error: {error}")
    #         raise 
        
    #     statement : Select = select([questionnaire_table.timestamp, questionnaire_table.c.question_1, questionnaire_table.c.question_2])
    #     print("ALIVE (2)")
    #     # statement : Select = select([questionnaire_table.c.timestamp, questionnaire_table.c.question_1, questionnaire_table.c.question_2]) \
    #     #         .where(questionnaire_table.c.column_name == customer_name) \
    #     #         .order_by(questionnaire_table.c.timestamp)
    #     person_responses : List[str] = engine.execute(statement).fetchall()
    #     print("ALIVE (3)")
    #     print(f"person_responses: {person_responses}")

    #     # person_responses_with_probabilities : List[Tuple] = add_probabilities_using_bellman_equation(elements=person_responses)
    #     # print(f"{person_responses_with_probabilities = }") # debugging as of now


    #     # openai_service : OpenAIService = OpenAIService()
    #     # coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt_recipe)
    #     # coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt_recipe, chat_history=chat_history)
    #     # response : Dict[str, str] = {
    #     #     "ingredients": coffee_ingredients
    #     # }
    # except Exception as exception:
    #     return jsonify({"error" : f"Server side error: {exception}"}), 500
    # return jsonify({"message" : "correct_dummy"}), 200    
    # return jsonify(response), 200

def __put_coffee_recipe() -> Tuple[Response, int]:
    #TODO
    pass

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8030)
    