from typing import Tuple, Dict, Any
from abc import ABC

class CoffeeCreator(ABC):
    def do(coffee_data : Dict[str, Any]) -> Tuple[str]:
        pass