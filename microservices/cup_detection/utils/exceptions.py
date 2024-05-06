class NoRecipeException(Exception):
    def __init__(self, message : str = "No such recipe found."):
        super.__init__(message)

class MethodNotPassedToBuilderException(Exception):
    def __init__(self, message : str = "Method not passed to builder class."):
        super.__init__(message)

class NoSuchCupDetector(Exception):
    def __init__(self, message : str = "Respective cup detector not found."):
        super.__init__(message)