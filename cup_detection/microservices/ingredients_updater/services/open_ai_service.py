from typing import List, Any, Dict
import os
from langchain.indexes import VectorstoreIndexCreator
from langchain.chat_models import ChatOpenAI
from langchain.document_loaders import TextLoader
from langchain.indexes import VectorstoreIndexCreator
from langchain.chains import ConversationalRetrievalChain
from utils.logger import LOGGER
from dotenv import load_dotenv

class OpenAIService:
    def __init__(self, file_path : str):
        """
        Initialize the OpenAI instance.

        Sets the OpenAI API key from the environment variable API_TOKEN_OPENAI.

         Args:
            file_path (str): The path of the prompt file.

        """
        try:
            load_dotenv(".env")
            os.environ["OPEN_AI_KEY"] = os.getenv("OPENAI_API_KEY")
            self.file_path : str = file_path
        
        except FileNotFoundError as file_not_found_error:
            LOGGER.error(f"Error loading .env file: {file_not_found_error}")
            raise 
        
        except TypeError as type_error:
            LOGGER.error(f"Error setting OPEN_AI_KEY: {type_error}")
            raise 
        
        except Exception as exception:
            LOGGER.error(f"Unexpected error during OpenAIService initialization: {exception}")
            raise 

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
        text_loader : TextLoader = TextLoader(file_path=self.file_path)
        index : VectorstoreIndexCreator = VectorstoreIndexCreator().from_loaders([text_loader])
        chain : ConversationalRetrievalChain = ConversationalRetrievalChain.from_llm(
            llm=ChatOpenAI(model=model, temperature=temperature_prompt),
            retriever=index.vectorstore.as_retriever(search_kwargs= {"k": 1}),
        )
        result : Dict[str, str] = chain({"question": prompt, "chat_history": []})

        result : Dict[str, str] = chain({"question": prompt, "chat_history": chat_history})
        return result["answer"] 
    
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