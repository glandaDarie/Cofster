import os
from typing import List, Tuple

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
        self.users_information : List[Tuple[str, int]] = users_information

    def create(self) -> None:
        """
        Creates prompt data for users by generating directories and copying content from the source file.
        
        Raises:
            TypeError: If elements at the first or second positions in users_information are not of the expected types.
            FileNotFoundError: If the source file is not found or if an error occurs during file operations.
        """
        if not all(isinstance(user_information[0], str) for user_information in self.users_information):
            raise TypeError("Not all elements at the first position are of type string.")
        if not all(isinstance(user_information[1], int) for user_information in self.users_information):
            raise TypeError("Not all elements at the second position are of type integer.")
        
        if not os.path.exists(self.prompt_files_path):
            os.makedirs(self.prompt_files_path)
            os.chdir(self.prompt_files_path)
            sub_directories : List[str] = [f"{id}_{name.lower()}" for name, id in self.users_information]
            for sub_directory in sub_directories:
                current_dir_path : str = os.path.join(self.prompt_files_path, sub_directory)
                if not os.path.exists(current_dir_path):
                    os.makedirs(current_dir_path)
                destination_path : str = os.path.join(current_dir_path, "prompt_data.txt")
                try:
                    with open(self.source_path, "r") as source, open(destination_path, "w") as destionation:
                        content : str = source.read()
                        destionation.write(content)
                except FileNotFoundError as error:
                    raise FileNotFoundError(f"Error: {error}. Files/File not found. Please check the file paths")
        return "Successfully generated the files and directories for each user"