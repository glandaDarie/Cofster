from typing import Type
import sys
import re

sys.path.append("../")

from utils.logger import LOGGER

class PromptConvertorBuilderService:
    """
    A class for building and transforming prompts.
    """
    def __init__(self, new_prompt_information : str, old_prompt : str):
        """
        Initialize the PromptConvertorBuilderService.

        Parameters:
        - new_prompt_information (str): The new prompt information.
        - old_prompt (str): The old prompt to be updated.
        """
        self.new_prompt_information : str = new_prompt_information
        self.old_prompt : str = old_prompt

    def remove_curly_brackets(self) -> Type['PromptConvertorBuilderService']:
        """
        Remove curly brackets and format the new prompt information.

        Returns:
        - Type['PromptConvertorBuilderService']: The updated PromptConvertorBuilderService instance.
        """
        self.new_prompt_information : str = re.sub(r"\{\s*", "", self.new_prompt_information)
        self.new_prompt_information : str = re.sub(r"\}", "", self.new_prompt_information)
        self.new_prompt_information : str = re.sub(r"\n\s*", "\n", self.new_prompt_information).strip() + "\n"
        self.new_prompt_information : str = "\n" + self.new_prompt_information
        return self
    
    def update_old_prompt_with_new_information(self) -> Type['PromptConvertorBuilderService']:
        """
        Update the old prompt with the new information.

        Returns:
        - Type['PromptConvertorBuilderService']: The updated PromptConvertorBuilderService instance.
        """
        self.new_prompt_information : str = re.sub(r"\{\s*[^{}]+\}", f"{{ {self.new_prompt_information} }}", self.old_prompt, flags=re.DOTALL)
        return self

    def update_coffee_name(self, old_data : str, new_data : str) -> Type['PromptConvertorBuilderService']:
        """
        Update the coffee drink name in the new prompt information.

        Parameters:
        - old_data (str): The old coffee drink name.
        - new_data (str): The new coffee drink name.

        Returns:
        - Type['PromptConvertorBuilderService']: The updated PromptConvertorBuilderService instance.
        """
        if old_data in self.new_prompt_information:
            LOGGER.info(f"Update on the coffee drink name, from: {old_data} to {new_data}")
            self.new_prompt_information : str = self.new_prompt_information.replace(old_data, new_data)
        return self

    def build(self) -> str:
        """
        Build and return the final prompt.

        Returns:
        - str: The final prompt.
        """
        return self.new_prompt_information  