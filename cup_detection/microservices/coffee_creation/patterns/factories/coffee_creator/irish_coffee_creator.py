from typing import List, Tuple, Dict, Any
from interfaces.coffee_creator import CoffeeCreator
from interfaces.type_coffee_creator_service import TypeCoffeeCreatorService

class IrishCoffeeCreator(CoffeeCreator):
    def __init__(self, parallel_coffee_creator_service : TypeCoffeeCreatorService):
        self.parallel_coffee_creator_service : TypeCoffeeCreatorService = parallel_coffee_creator_service

    def do(self, *, pins : List[int], irish_coffee_data : Dict[str, Any]) -> Tuple[str]:
        pass
    