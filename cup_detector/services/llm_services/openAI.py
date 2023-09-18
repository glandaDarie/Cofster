from typing import Dict
import os
from langchain.indexes import VectorstoreIndexCreator
from langchain.chat_models import ChatOpenAI
from langchain.document_loaders import TextLoader
from langchain.indexes import VectorstoreIndexCreator
from langchain.chains import ConversationalRetrievalChain
from utils.paths import PATH_COFFEE_CREATION
from utils.helpers import FileLoader
import json

class OpenAI:
    def __init__(self):
        """
        Initialize the OpenAI instance.

        Sets the OpenAI API key from the environment variable API_TOKEN_OPENAI and initializes a FileLoader instance.

        """
        os.environ["OPEN_AI_KEY"] = os.getenv("API_TOKEN_OPENAI")
        self.file_loader : FileLoader = FileLoader(file_path=PATH_COFFEE_CREATION) 
    
    def generate_available_ingredients(self, coffee_name : str, query : str, model : str = "gpt-3.5-turbo", temperature_prompt : float = 0) -> json:
        """
        Generate a response to a query using the OpenAI model with a specified coffee name.

        Args:
            coffee_name (str): The name of the coffee to use in the query.
            query (str): The input query or prompt.
            model (str): The OpenAI model to use (default is "gpt-3.5-turbo").
            temperature_prompt (float): The temperature for controlling response randomness (default is 0.2).

        Returns:
            str: The generated response.
        """
        self.file_loader.update_coffee_name_inside_coffee_creation_file(coffee_name=coffee_name)
        text_loader : TextLoader = TextLoader(file_path=PATH_COFFEE_CREATION)
        index : VectorstoreIndexCreator = VectorstoreIndexCreator().from_loaders([text_loader])
        chain : ConversationalRetrievalChain = ConversationalRetrievalChain.from_llm(
            llm=ChatOpenAI(model=model, temperature=temperature_prompt),
            retriever=index.vectorstore.as_retriever(search_kwargs={"k": 1}),
        )
        result : Dict[str, str] = chain({"question": query})
        self.file_loader.update_coffee_name_inside_coffee_creation_file(coffee_name=coffee_name, default=True)
        return result["answer"]