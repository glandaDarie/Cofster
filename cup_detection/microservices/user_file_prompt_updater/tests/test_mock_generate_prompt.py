from typing import List, Tuple

import sys
sys.path.append("../")

from utils.helpers import UserPromptGenerator
from utils.paths import ROOT_PATH

def test_mock_generate_prompt():
    users_information : List[Tuple[str, int]] = [('whatever', 1), ('none', 2), ('marian', 3), \
                    ('sebastian', 4), ('daniel', 5), ('brandon', 6), ('maguire', 7)]
    user_prompt_generator : UserPromptGenerator = UserPromptGenerator(users_information=users_information, root_path=ROOT_PATH) 
    message : str = user_prompt_generator.generate()
    assert message == "Successfully created the directories and files for the respective user/users" \
        or message == "Successfully updated the directories and files for the respective user/users" \
        or message == "No need to update the structure, there isn't any change in the backend"





