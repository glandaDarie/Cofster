class NoRecipeException(Exception):
    def __init__(self, message : str = "No such recipe found."):
        super.__init__(message)

class CoffeeNotCreatedError(Exception):
    def __init__(self, message : str = "Cannot create coffee."):
        super.__init__(message)
