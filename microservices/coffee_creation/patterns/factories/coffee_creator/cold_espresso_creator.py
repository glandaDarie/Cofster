from typing import List, Tuple, Dict, Any
import RPi.GPIO as GPIO  
from patterns.facades.coffee_creator_simple_facade import CoffeeCreatorSimpleFacade
from patterns.decorators.initialize_drink import initialize_drink
from interfaces.coffee_creator import CoffeeCreator
from interfaces.type_coffee_creator_service import TypeCoffeeCreatorService
from utils.enums.coffee_types import CoffeeTypes
from utils.constants.drinks_pin_mapper import drinks_pin_mapper
from utils.paths.espresso_attrs_path import ESPRESSO_ATTRS_PATH

class ColdEspressoCreator(CoffeeCreator):
    def __init__(self, parallel_coffee_creator_service : TypeCoffeeCreatorService):
        self.parallel_coffee_creator_service : TypeCoffeeCreatorService = parallel_coffee_creator_service

    @initialize_drink(*drinks_pin_mapper[CoffeeTypes.COLD_ESPRESSO.value], type_input=GPIO.OUT)
    def do(self, cold_espresso_data : Dict[str, Any], *, pins : List[int] | None = None) -> Tuple[str]:
        params : Dict[str, Any] = {
            "drink_data" : cold_espresso_data, 
            "pins" : pins, 
            "parallel_coffee_creator_service" : self.parallel_coffee_creator_service,
            "attrs_path" : ESPRESSO_ATTRS_PATH
        }
        return CoffeeCreatorSimpleFacade.create(params=params)