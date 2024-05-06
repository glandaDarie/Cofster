class NoArgumentsProvidedException(Exception):
    def __init__(self, error_message : str = "No arguments provided.", status_code : int = 500):
        super().__init__(error_message)
        self.error_message : str = error_message
        self.status_code : int = status_code

    def __str__(self):
        return f"Error message: {self.error_message}. Status code: {self.status_code}" 