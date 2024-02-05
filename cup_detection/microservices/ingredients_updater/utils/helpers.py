from typing import List, Tuple
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

# def bellman_updater(elements : List[str], discount_factor : float = 0.9, previous_probability : float = 1.0 ) -> List[Tuple]:
#     """
#     Update probabilities using the Bellman equation.

#     Parameters:
#     - elements (List[str]): List of data elements.
#     - discount_factor (float): Discount factor for the Bellman equation. Default is 0.9.
#     - initial_probability (float): Initial probability value. Default is 1.0.

#     Returns:
#     - List[Tuple]: List of tuples containing updated data and corresponding probabilities.
#     """
#     trajectory : List[Tuple] = []      
#     for d in data:
#         current_probability = previous_probability * discount_factor
#         trajectory.append(tuple(d) + (current_probability, ))
#         previous_probability = current_probability

from typing import List, Tuple

def add_probabilities_using_bellman_equation(elements: List[str], discount_factor: float = 0.9, initial_probability: float = 1.0) -> List[Tuple]:
    """
    Add probabilities using the Bellman equation.

    Parameters:
    - elements (List[str]): List of data elements.
    - discount_factor (float): Discount factor for the Bellman equation. Default is 0.9.
    - initial_probability (float): Initial probability value. Default is 1.0.

    Returns:
    - List[Tuple]: List of tuples containing the trajectory with the probabilites for each timestamp.
    """
    trajectory : List[Tuple] = []      
    current_probability : float = initial_probability
    for element in elements:
        current_probability *= discount_factor
        trajectory.append(tuple(element) + (current_probability,))
    return trajectory

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
    
    def write_to_file(self, content: str) -> None | IOError:
        """
        Write content to a file.

        Args:
            content (str): The content to be written to the file.

        Returns:
            bool: True if the content was successfully written to the file.

        Raises:
            IOError: If an error occurs during file opening or writing.

        Note:
            This function attempts to write the specified content to the file located at self.file_path.
            If successful, it returns True; otherwise, it raises an IOError with details about the specific error.
        """
        try:
            with open(self.file_path, "w") as output_file:
                output_file.write(content)
        except IOError as open_error:
            raise IOError(f"Could not open file. Error: {open_error}")
        except Exception as write_error:
            raise IOError(f"Could not write to file. Error: {write_error}")
        
    def read_file(self) -> str | IOError:
        """
        Read content from a file.

        Returns:
            str: The content read from the file.

        Raises:
            IOError: If an error occurs during file reading.

        Note:
            This function attempts to read the content from the file located at self.file_path.
            If successful, it returns the content as a string; otherwise, it raises an IOError with details about the specific error.
        """
        try:
            with open(self.file_path, "r") as input_file:
                content : str = input_file.read()
            return content
        except IOError as read_error:
            raise IOError(f"Could not read file. Error: {read_error}")
        except Exception as error:
            raise IOError(f"Unexpected error while reading file. Error: {error}")
