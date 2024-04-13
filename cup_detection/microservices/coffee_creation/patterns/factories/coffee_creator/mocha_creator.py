from typing import Tuple, Dict, Any
from interfaces.coffee_creator import CoffeeCreator

class MochaCreator(CoffeeCreator):
    def do(self, mocha_data : Dict[str, Any]) -> Tuple[str]:
        pass