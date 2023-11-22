from typing import List, Tuple, Dict, Any, Self
from io import TextIOWrapper
import os
import json
import requests 
from requests.models import Response
from urllib.parse import urljoin

def create_path(paths : List[str] = None) -> str:
    """
    Create a full path by joining individual path components.

    Args:
    paths (List[str], optional): List of strings representing individual components of the path.
                                  Defaults to None.

    Returns:
    str: The concatenated full path string.

    Raises:
    AssertionError: If paths is None or an empty list.
    """
    assert not (paths is None or len(paths) == 0), \
        "Incorrect parameters given to the path list"
    fullpath : str = paths[0]
    paths : List[str] = paths[1:]
    for path in paths:
        fullpath : str = os.path.join(fullpath, path) 
    return fullpath

class FileLoader:
    def __init__(self, file_path):
        """
        Initialize a FileLoader instance.

        Args:
            file_path (str): The path to the file to be loaded and updated.
        """
        self.file_content : str = None
        self.file_path : str = file_path

    def update_coffee_name_inside_coffee_creation_file(self, coffee_name : str, default : bool = False) -> bool:
        """
        Update the coffee name inside the file.

        Args:
            coffee_name (str): The coffee name to be updated in the file.
            use_default_placeholder (bool): Whether to use a default placeholder. Default is False.

        Returns:
            bool: True if the update was successful, False otherwise.
        """
        with open(self.file_path, "r") as input_file:
            file_content : str = input_file.read()
            self.file_content : str = file_content.replace(coffee_name, "{coffee_name}") if default else \
                file_content.replace("{coffee_name}", coffee_name)
            return self.__update_file()
    
    def __update_file(self):
        """
        Update the contents of the file with the modified content.

        This private method writes the updated content back to the file specified during initialization.

        Returns:
            bool: True if the update was successful, False otherwise.
        """
        with open(self.file_path, "w") as output_file:
            output_file.write(self.file_content)
        return True

class DataTansformer:
    """
    A class for fetching and transforming data.
    """
    def __init__(self):
        """
        Initializes DataTransformer class.
        """
        self.data : dict | None = None

    def fetch(self, base_url : str, endpoint : str, params : Dict[str, Any] | None = None) -> Self:
        """
        Fetches data from the specified URL endpoint.

        Args:
            base_url (str): The base URL.
            endpoint (str): The endpoint to fetch data from.
            params (Dict[str, Any] | None, optional): Parameters for the request. Defaults to None.

        Returns:
            DataTransformer: The DataTransformer object.
        """
        url : str = urljoin(base_url, endpoint)
        try:
            response : Response = requests.get(url=url, params=params)
            status_code : int = response.status_code
            if status_code == 200:
                try:
                    data : Dict = json.loads(response.text)[0]
                except ValueError as json_error:
                    raise ValueError(f"Failed to parse JSON response: {json_error}")
        except (requests.exceptions.ConnectionError,
                requests.exceptions.Timeout,
                requests.exceptions.HTTPError,
                requests.exceptions.RequestException) as error:
            if isinstance(error, requests.exceptions.ConnectionError):
                raise requests.exceptions.ConnectionError(f"Connection error occurred, error: {error}")
            elif isinstance(error, requests.exceptions.Timeout):
                raise requests.exceptions.Timeout(f"Request timeout occurred, error: {error}")
            elif isinstance(error, requests.exceptions.HTTPError):
                raise requests.exceptions.HTTPError(f"HTTP error occurred, error: {error}")
            else:
                raise requests.exceptions.RequestException(f"Another request exception occurred, error: {error}") 
        self.data = data
        return self

    def __parse_json(self, data : Dict) -> List[Tuple[str, int]]:
        """
        Parses JSON data to extract users' information.

        Args:
            data (Dict): JSON data to be parsed.

        Returns:
            List[Tuple[str, str]]: A list of tuples containing users' information.
        """
        users_information : List[Tuple[str, str]] = []
        users : List[Dict[str, str]] = data["users"][0]["user"]
        for user in users:
            name : str = user["name"]
            try:
                id : int = int(user["id"])
            except ValueError as error:
                raise ValueError(f"Error when trying to convert id from string to int: {error}")
            users_information.append((name, id))
        return users_information

    def transform(self) -> List[Tuple[str, int]]:
        """
        Transforms data to extract users' information.

        Returns:
            List[Tuple[str, str]]: A list of tuples containing users' information.
        """
        users_information : List[Tuple[str, int]] = self.__parse_json(self.data)
        return users_information

class UserPromptGenerator:
    """Generates default prompt data for each user based on provided information."""
    def __init__(self, users_information : List[Tuple[str, int]], root_path : str):
        """
        Initializes UserPromptGenerator object.
        
        Args:
            users_information (List[Tuple[str, int]]): List of tuples containing user information.
            source_path (str): Path to the source file containing data.
        """
        self.prompt_files_path : str = os.path.join(root_path, "assets", "users_prompt_files")
        self.source_path : str = os.path.join(root_path, "assets", "coffee_creation_data.txt")
        self.previous_users_prompt_files_path : str = os.path.join(root_path, "assets", "previous_users_information.txt")
        self.users_information : List[Tuple[str, int]] = users_information

    def generate(self) -> str:
        """
        Generates prompt data for users by generating directories and copying content from the source file.
        
        Raises:
            TypeError: If elements at the first or second positions in users_information are not of the expected types.
            FileNotFoundError: If the source file is not found or if an error occurs during file operations.
        """
        if not all(isinstance(user_information[0], str) for user_information in self.users_information):
            raise TypeError("Not all elements at the first position are of type string.")
        if not all(isinstance(user_information[1], int) for user_information in self.users_information):
            raise TypeError("Not all elements at the second position are of type integer.")
                
        if not os.path.exists(self.prompt_files_path):
            success : bool | str = self.__create_hierarchical_structure()
        else:
            success : bool | str = self.__update_hierarchical_structure()
        return success

    def __create_hierarchical_structure(self) -> str | FileNotFoundError:
        """
        Create prompt data for users, generating directories and copying content from source files.

        Raises:
            FileNotFoundError: If the source file or directory is not found.
        
        Returns:
            bool: True if the operation was successful.
        """
        os.makedirs(self.prompt_files_path)
        os.chdir(self.prompt_files_path)
        sub_directories : List[str] = [f"{id}_{name.lower()}" for name, id in self.users_information]
        response_msg : bool | str = self.__store_previous_users_information(file_path=self.previous_users_prompt_files_path, users_information=sub_directories)
        assert response_msg == "Successfully stored the users information", response_msg
        for sub_directory in sub_directories:
            current_dir_path : str = os.path.join(self.prompt_files_path, sub_directory)
            if not os.path.exists(current_dir_path):
                os.makedirs(current_dir_path)
            destination_path : str = os.path.join(current_dir_path, "prompt_data.txt")
            try:
                with open(file=self.source_path, mode="r") as source, open(file=destination_path, mode="w") as destionation:
                    content : str = source.read()
                    destionation.write(content)
            except FileNotFoundError as error:
                raise FileNotFoundError(f"Error: {error}. Files/File not found. Please check the file paths")
        return "Successfully created the directories and files for each user"

    def __update_hierarchical_structure(self) -> str:
        """
        Update the hierarchical structure based on changes in user information.

        Returns:
            str: A message indicating whether the structure needs updating or not.

        Raises:
            Any specific exceptions raised during the process.
        """
        previous_info : List[Tuple[str, int]] = self.__load_previous_users_information(self.previous_users_prompt_files_path)
        current_info : List[Tuple[str, int]] = list(map(lambda user_information: (user_information[0].lower(), user_information[1]), self.users_information))   
        previous_info : set = set(previous_info)
        current_info : set = set(current_info)
        difference_info : set = previous_info - current_info
        difference_info : List[Tuple[str, int]] = list(difference_info)
        if len(difference_info) == 0:
            return "No need to update the structure, there isn't any change in the AWS backend"
        #TODO 
        elif len(difference_info) > 0:
            if len(current_info) > len(previous_info):
                pass
            else:
                pass
        else:
            raise RuntimeError("The difference between the sets cannot be smaller than 0")
        # add the users that are not in the previous_users_information.txt file
        return "Successfully updated the directories and files for the respectiv user/users"

    def __store_previous_users_information(self, file_path : str, users_information : List[str]) -> bool | str:
        """
        Store previous users' information in a file.

        Args:
            file_path (str): The path to the file where information will be stored.
            users_information (List[str]): List of strings containing user information.

        Returns:
            bool: True if the information was stored successfully, False otherwise.
        """
        file : TextIOWrapper | None = None
        try:
            file = open(file=file_path, mode="w")
            file.write("\n".join([user_information.replace("_", " ") for user_information in users_information]))                
        except IOError as error:
            return f"An error occurred while writing to the file: {file_path}. Error: {error}"
        finally:
            if file:
                file.close()
        return "Successfully stored the users information"

    def __load_previous_users_information(self, file_path : str) -> List[Tuple[str, int]]:
        """
        Load previous users' information from a file and return a list of tuples containing names (lowercased)
        and corresponding IDs.

        Args:
            file_path (str): The path to the file containing user information.

        Returns:
            List[Tuple[str, int]]: A list of tuples where each tuple contains a lowercased name and an ID.

        Raises:
            ValueError: If an error occurs while converting ID from string to int.
            AttributeError: If an error occurs while converting name to lowercase.
        """
        previous_users_information : List[str] = []
        with open(file=file_path, mode="r") as file:
            for line in file.readlines():
                line_splitted : List[str] = line.split()
                if len(line_splitted) != 2:
                    continue
                try:
                    id : str = int(line_splitted[0])
                    name : str = line_splitted[1].lower()
                except ValueError as error:
                    raise ValueError(f"Cannot convert id from string to int. Error: {error}")
                except AttributeError as error:
                    raise AttributeError(f"Cannot convert name to lowercase. Error: {error}")
                previous_users_information.append((name, id))
        return previous_users_information
