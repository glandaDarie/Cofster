class NoRecipeException(Exception):
    def __init__(self, message : str = "No such recipe found."):
        super.__init__(message)