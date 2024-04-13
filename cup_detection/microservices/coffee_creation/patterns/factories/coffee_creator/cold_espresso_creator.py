from typing import Tuple, Dict, Any
from interfaces.coffee_creator import CoffeeCreator

class ColdEspressoCreator(CoffeeCreator):
    def do(self, cold_espresso_data : Dict[str, Any]) -> Tuple[str]:
        pass