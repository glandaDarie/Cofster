from typing import Tuple, Dict, Any
from interfaces.coffee_creator import CoffeeCreator

class AmericanoCreator(CoffeeCreator):
    def do(self, americano_data : Dict[str, Any]) -> Tuple[str]:
        pass