from typing import Tuple, Dict, Any
from interfaces.coffee_creator import CoffeeCreator

class CappuccinoCreator(CoffeeCreator):
    def do(self, cappuccino_data : Dict[str, Any]) -> Tuple[str]:
        pass