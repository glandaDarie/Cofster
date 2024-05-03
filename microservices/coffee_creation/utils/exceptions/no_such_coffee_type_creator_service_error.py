class NoSuchCoffeeTypeCreatorService(Exception):
    def __init__(self, message : str = "The coffee creator type does not exist", status_code : int = 500):
        super().__init__(message)
        self.message : str = message
        self.status_code : int = status_code