from typing import List, Tuple
import os

import sys
sys.path.append("../")

from utils.helpers import UserPromptGenerator
from utils.paths import ROOT_PATH

def test_generate_prompts() -> None:
    users_information : List[Tuple[str, int]] = [("text1", 1), ("text2", 2), ("text3", 3), ("text4", 4)] 
    user_prompt_generator : UserPromptGenerator = UserPromptGenerator(users_information=users_information, root_path=ROOT_PATH) 
    actual : str = user_prompt_generator.generate()
    expected : str = "Successfully generated the files and directories for each user"
    assert "Success" in actual, f"Actual: {actual}, Expected: {expected}"