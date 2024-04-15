from typing import List, Tuple, Dict, Any
from abc import ABC, abstractmethod
from interfaces.type_coffee_creator_service import TypeCoffeeCreatorService

class CoffeeCreator(ABC):
    @abstractmethod
    def __init__(self, parallel_coffee_creator_service : TypeCoffeeCreatorService):
        self.parallel_coffee_creator_service : TypeCoffeeCreatorService = parallel_coffee_creator_service

    @abstractmethod
    def do(self, coffee_data : Dict[str, Any], *, pins : List[int] | None = None) -> Tuple[str]:
        pass
