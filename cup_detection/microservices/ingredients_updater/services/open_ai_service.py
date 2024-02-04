from typing import List, Any, Dict
import os
from langchain.indexes import VectorstoreIndexCreator
from langchain.chat_models import ChatOpenAI
from langchain.document_loaders import TextLoader
from langchain.indexes import VectorstoreIndexCreator
from langchain.chains import ConversationalRetrievalChain
from utils.paths import COFFEE_CREATION_PATH
from utils.helpers import FileLoader
import json
from dotenv import load_dotenv

class OpenAIService:
    def __init__(self):
        """
        Initialize the OpenAI instance.

        Sets the OpenAI API key from the environment variable API_TOKEN_OPENAI and initializes a FileLoader instance.

        """
        load_dotenv(".env")
        os.environ["OPEN_AI_KEY"] = os.getenv("OPENAI_API_KEY")
        
    def __generate_available_ingredients(self, prompt : str, \
                                        model : str = "gpt-3.5-turbo", \
                                        temperature_prompt : float = 0, \
                                        chat_history : List[Any] = []) -> Dict[str, str]:
        """
        Helper method to generate a response to a query using the OpenAI model.

        Args:
            query (str): The input query or prompt.
            model (str): The OpenAI model to use (default is "gpt-3.5-turbo").
            temperature_prompt (float): The temperature for controlling response randomness (default is 0).
            chat_history (List[Any]): Some past information for the LLM (default is an empty List).

        Returns:
            Dict[str, str]: The generated response.
        """
        text_loader : TextLoader = TextLoader(file_path=COFFEE_CREATION_PATH) # file should be changed with the new data fetched from the backend
        index : VectorstoreIndexCreator = VectorstoreIndexCreator().from_loaders([text_loader])
        chain : ConversationalRetrievalChain = ConversationalRetrievalChain.from_llm(
            llm=ChatOpenAI(model=model, temperature=temperature_prompt),
            retriever=index.vectorstore.as_retriever(search_kwargs={"k": 1}),
        )
        result : Dict[str, str] = chain({"question": prompt, "chat_history": chat_history})
        return json.loads(result["answer"]) 
    
    def __call__(self, prompt : str, \
                model : str = "gpt-3.5-turbo", \
                temperature_prompt : float = 0, \
                chat_history : List[Any] = []) -> Dict[str, str]:
        """
        Generate a response to a query using the OpenAI model.

        Args:
            prompt (str): The input query or prompt.
            model (str): The OpenAI model to use (default is "gpt-3.5-turbo").
            temperature_prompt (float): The temperature for controlling response randomness (default is 0).
            chat_history (List[Any]): Some past information for the LLM (default is an empty List).

        Returns:
            Dict[str, str]: The generated response.
        """
        return self.__generate_available_ingredients(prompt=prompt, model=model, temperature_prompt=temperature_prompt, chat_history=chat_history)