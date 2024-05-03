class NoAllParamsPassedError(Exception):
    def __init__(self, message : str = "Not all parameters where passed.", status_code : int = 500):
        super().__init__(message)
        self.message : str = message
        self.status_code : int = status_code