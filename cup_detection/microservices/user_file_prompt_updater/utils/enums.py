from enum import Enum

class ReadType(Enum):
    STRING : str = "str"
    LIST : str = "list"

class DeleteFrom(Enum):
    PREVIOUS_USERS_INFORMATION : str = "previous_users_information"
    USERS_PROMPT_FILES : str = "users_prompt_files"