from typing import Tuple, Dict, Any
from interfaces.coffee_creator import CoffeeCreator

class FlatWhiteCreator(CoffeeCreator):
    def do(self, flat_white_data : Dict[str, Any]) -> Tuple[str]:
        pass