class CustomError(Exception):
    def __init__(self, message : str):
        super().__init__(message)

class LLMResponseError(CustomError):
    pass

class StatusCodeError(CustomError):
    pass