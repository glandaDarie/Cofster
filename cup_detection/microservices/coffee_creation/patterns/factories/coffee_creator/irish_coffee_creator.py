from typing import Tuple, Dict, Any
from interfaces.coffee_creator import CoffeeCreator

class IrishCoffeeCreator(CoffeeCreator):
    def do(self, irish_coffee_data : Dict[str, Any]) -> Tuple[str]:
        pass