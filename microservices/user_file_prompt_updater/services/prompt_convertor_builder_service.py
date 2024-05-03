from typing import Type
import sys
import re
from re import Match

sys.path.append("../")

from utils.logger import LOGGER
from utils.patterns import CURRENT_COFFEE_RECIPE_REGEX_PATTERN

class PromptConvertorBuilderService:
    """
    A class for building and transforming prompts.
    """
    def __init__(self, new_prompt_information : str, old_prompt : str, coffee_name : str):
        """
        Initialize the PromptConvertorBuilderService.

        Parameters:
        - coffee_name (str): the actual name of the coffee
        - new_prompt_information (str): The new prompt information.
        - old_prompt (str): The old prompt to be updated.
        """
        self.coffee_name : str = coffee_name
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
        coffee_matcher : Match = re.search(pattern=CURRENT_COFFEE_RECIPE_REGEX_PATTERN, string=self.old_prompt)
        self.new_prompt_information = f"For coffee drink {self.coffee_name}, current recipe is: \n {self.new_prompt_information}"
        if coffee_matcher: # the coffee drink exists, update only that part
            self.new_prompt_information = re.sub(\
                pattern=CURRENT_COFFEE_RECIPE_REGEX_PATTERN, \
                repl=self.new_prompt_information, \
                string=self.old_prompt \
            )
        else: # the coffee drink doesn't exist, insert self.new_prompt_information before "Ensure that ..." part
            insert_before_pattern : str = r'Ensure that the JSON format is a string.*'
            self.new_prompt_information = re.sub(\
                pattern=insert_before_pattern, \
                repl=self.new_prompt_information + "\n\n" + r'\g<0>', \
                string=self.old_prompt \
            )
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