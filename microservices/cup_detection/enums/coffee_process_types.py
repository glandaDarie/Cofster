from enum import Enum

class CoffeeProcessTypes(Enum):
    CUP_DETECTED : str = "Cup detected"
    CUP_NOT_DETECTED : str = "Cup not detected"
    DRINK_CREATED : str = "Drink created"
    DRINK_NOT_CREATED : str = "Drink not created"
    