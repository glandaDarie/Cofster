from enum import Enum

class GPTModelType(Enum):
    GPT_3_5_TURBO_0125 : str = "gpt-3.5-turbo-0125"
    GPT_3_5_TURBO : str = "gpt-3.5-turbo"
    GPT_3_5_TURBO_1106 : str = "gpt-3.5-turbo-1106"
    GPT_4_TURBO : str = "gpt-4-turbo"
    GPT_4_TURBO_2024_04_09 : str = "gpt-4-turbo-2024-04-09"
    GPT_4_0613: str = "gpt-4-0613"
    GPT_4 : str = "gpt-4"
    GPT_4_32K : str = "gpt-4-32k"
