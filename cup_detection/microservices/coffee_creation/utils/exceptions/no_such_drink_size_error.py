class NoSuchDrinkSizeError(Exception):
    def __init__(self, message : str = "No such drink size found.", status_code : None | int = None):
        self.message : str = message
        self.status_code : int = status_code
        super().__init__(message)
    
    def __str__(self):
        return f"{self.message}"