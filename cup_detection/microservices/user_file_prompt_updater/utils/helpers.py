from typing import List, Tuple, Set
from io import TextIOWrapper
import os
from utils.logger import LOGGER
import copy
import shutil

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

    def __generate_user_subdirectories(self, data : List[Tuple[str, int]] | None = None) -> List[str]:
        """
        Generate a list of subdirectories based on user information.

        Args:
            data (List[Tuple[str, int]]): Optional. The user information. Defaults to None.

        Returns:
            List[str]: A list of subdirectories in the format 'id_name.lower()' for each user.

        Notes:
            - If 'data' is None, the function uses the user information stored within the class.
            - If 'data' is provided, it uses the provided user information to generate subdirectories.
        """
        return [f"{id}_{name.lower()}" for name, id in self.users_information] if data is None \
            else [f"{id}_{name.lower()}" for name, id in data]

    def __create_hierarchical_structure(self, data : List[Tuple[str, int]] | None = None, command : str = "<create>") -> str | FileNotFoundError:
        """
        Create prompt data for users, generating directories and copying content from source files.

        Raises:
            FileNotFoundError: If the source file or directory is not found.
        
        Returns:
            bool: True if the operation was successful.
        """
        
        if data is None:
            os.makedirs(name=self.prompt_files_path)
            os.chdir(path=self.prompt_files_path)
        sub_directories : List[str] = self.__generate_user_subdirectories()
        subdirs_merged : List[str] = copy.deepcopy(sub_directories)

        response_msg : bool | str = self.__store_previous_users_information(file_path=self.previous_users_prompt_files_path, subdirs=subdirs_merged)
        assert response_msg == "Successfully cached the users information", response_msg

        for sub_directory in sub_directories:
            current_dir_path : str = os.path.join(self.prompt_files_path, sub_directory)
            if not os.path.exists(current_dir_path):
                os.makedirs(current_dir_path)
                destination_path : str = os.path.join(current_dir_path, "prompt_data.txt")
                LOGGER.info(f"Destination path: {destination_path}")
                try:
                    with open(file=self.source_path, mode="r") as source, open(file=destination_path, mode="w") as destination:
                        content : str = source.read()
                        destination.write(content)
                except FileNotFoundError as error:
                    raise FileNotFoundError(f"Error: {error}. Files/File not found. Please check the file paths")
        if data is None:
            return "Successfully created the users_prompt_files, the directories and files for each new user"
        return "Successfully created the directories and files for the new user/new users"

    def __update_hierarchical_structure(self) -> str:
        """
        Update the hierarchical structure based on changes in user information.

        Returns:
            str: A message indicating whether the structure needs updating or not.

        Raises:
            Specific exceptions raised during the process.
        """
        previous_info: List[Tuple[str, int]] = self.__load_previous_users_information(self.previous_users_prompt_files_path)
        current_info: List[Tuple[str, int]] = [(user_info[0].lower(), user_info[1]) for user_info in self.users_information]

        previous_info_set: Set[Tuple[str, int]] = set(previous_info)
        current_info_set: Set[Tuple[str, int]] = set(current_info)

        difference_current_info: Set[Tuple[str, int]] = current_info_set.difference(previous_info_set)
        difference_previous_info: Set[Tuple[str, int]] = previous_info_set.difference(current_info_set)

        if not difference_current_info and not difference_previous_info:
            return "No need to update the structure, there isn't any change in the backend"
        else:
            if difference_current_info and not difference_previous_info:
                error_msg : str = self.__add_prompt_files(prompt_files=list(difference_current_info))
                if error_msg is not None:
                    raise RuntimeError(error_msg)
                LOGGER.info("Successfully added a new prompt file/prompt files")
            elif not difference_current_info and difference_previous_info:
                error_msg : str = self.__delete_prompt_files(prompt_files=list(difference_previous_info))
                if error_msg is not None:
                    raise RuntimeError(error_msg)
                LOGGER.info("Successfully removed a prompt file/prompt files")
            else: 
                error_msg : str = self.__delete_prompt_files(prompt_files=list(difference_previous_info))
                if error_msg is not None:
                    raise RuntimeError(error_msg)
                LOGGER.info("Successfully removed a prompt file/prompt files")
                error_msg : str = self.__add_prompt_files(prompt_files=list(difference_current_info))
                if error_msg is not None:
                    raise RuntimeError(error_msg)
        return "Successfully updated the directories and files for the respective user/users"

    def __add_prompt_files(self, prompt_files : List[Tuple[str, int]]) -> str:
        """
        Add prompt files and directories for newly added users to the Cofster mobile app.

        Args:
            prompt_files (List[Tuple[str, int]]): A list of tuples containing information about newly added users.
                Each tuple contains the user's name and identifier.

        Returns:
            str: A message indicating the outcome of the addition process.
                - If the addition process was successful, it returns "Successfully added the prompt files and directories for the new user/new users".
                - If an error occurred during the addition process, it returns an error message explaining the issue.

        Raises:
            Specific exceptions are raised if any critical errors occur during the addition process.
        """
        msg : str | None = None
        recieved_msg : str = self.__create_hierarchical_structure(data=prompt_files)
        if recieved_msg.lower().strip() != "Successfully created the directories and files for the new user/new users".lower().strip():
            msg = recieved_msg
        return msg

    def __delete_prompt_files(self, prompt_files : List[Tuple[str, int]]) -> str:
        """
        Deletes the prompt files and their content.

        Args:
            prompt_files (List[Tuple[str, int]]): A list of tuples containing file names and IDs.
        
        Returns:
            str: The error message
        """
        msg : str | None = None
        prompt_files : List[str] = self.__generate_user_subdirectories(data=prompt_files)
        for prompt_file in prompt_files:
            path : str = os.path.join(self.prompt_files_path, prompt_file)
            try:
                shutil.rmtree(path)
            except Exception as e:
                msg = f"Error while processing {prompt_file}: {e}"
        return msg

    def __store_previous_users_information(self, file_path : str, subdirs : List[str]) -> bool | str:
        """
        Store previous users' information in a file.

        Args:
            file_path (str): The path to the file where information will be stored.
            subdirs (List[str]): List of strings containing the subdirectories.

        Returns:
            bool: True if the information was stored successfully, False otherwise.
        """
        file : TextIOWrapper | None = None
        try:
            file = open(file=file_path, mode="w")
            file.write("\n".join([subdir.replace("_", " ") for subdir in subdirs]))                
        except IOError as error:
            return f"An error occurred while writing to the file: {file_path}. Error: {error}"
        finally:
            if file:
                file.close()
        return "Successfully cached the users information"

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