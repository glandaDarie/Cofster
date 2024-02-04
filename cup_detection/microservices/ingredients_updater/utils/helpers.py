from typing import Any, Dict
from urllib.parse import urlsplit, urljoin

def url_builder(base_url : str, endpoint : str) -> str:
    """
    Build a complete URL from a base URL, and an endpoint.

    Parameters:
    - base_url (str): The base URL.
    - endpoint (str): The endpoint to append to the base URL.

    Returns:
    - str: The constructed URL.

    Raises:
    - ValueError: If the base URL is missing a valid scheme (http/https) or network location.
    - ValueError: If the endpoint is an empty string.
    """
    url : str = urljoin(base_url, endpoint)
    scheme, netloc, _, _, _ = urlsplit(url)
    if not scheme or not netloc:
        raise ValueError("Invalid base URL. Must have a scheme (http/https) and network location.")
    return url

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
    
    def __update_file(self) -> bool:
        """
        Update the contents of the file with the modified content.

        This private method writes the updated content back to the file specified during initialization.

        Returns:
            bool: True if the update was successful, False otherwise.
        """
        with open(self.file_path, "w") as output_file:
            output_file.write(self.file_content)
        return True