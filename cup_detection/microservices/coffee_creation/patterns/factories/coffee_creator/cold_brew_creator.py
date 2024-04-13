from typing import Tuple, Dict, Any
from interfaces.coffee_creator import CoffeeCreator

class ColdBrewCreator(CoffeeCreator):
    def do(self, cold_brew_data : Dict[str, Any]) -> Tuple[str]:
        pass