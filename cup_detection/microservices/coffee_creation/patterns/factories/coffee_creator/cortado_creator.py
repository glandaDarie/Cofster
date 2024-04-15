from typing import List, Tuple, Dict, Any
from time import time
import RPi.GPIO as GPIO  
from types import ModuleType
from interfaces.coffee_creator import CoffeeCreator
from patterns.decorators.initialize_gpio import initialize_gpio
from utils.constants.drinks_pin_mapper import drinks_pin_mapper
from utils.enums.coffee_types import CoffeeTypes
from utils.enums.coffee_creator_types import CoffeeCreatorType
from utils.paths.cortado_attrs_path import CORTADO_ATTRS_PATH
from utils.helpers.module_from_path import get_module_from_path
from utils.exceptions.no_such_coffee_type_creator_service_error import NoSuchCoffeeTypeCreatorService
from interfaces.type_coffee_creator_service import TypeCoffeeCreatorService

class CortadoCreator(CoffeeCreator):
    def __init__(self, type_coffee_creator_service : TypeCoffeeCreatorService):
        self.type_coffee_creator_service : TypeCoffeeCreatorService = type_coffee_creator_service

    @initialize_gpio(*drinks_pin_mapper[CoffeeTypes.CORTADO.value], type_input=GPIO.OUT)
    def do(self, cortado_data : Dict[str, Any], *, pins : List[int] | None = None) -> Tuple[str]:
        start_time : float = time()
        message : str | None = None
        history : Dict[str, Any] = {}
        verbose : bool = cortado_data.get("verbose", False)
        
        module : ModuleType = get_module_from_path(module_path=CORTADO_ATTRS_PATH)

        if self.type_coffee_creator_service == CoffeeCreatorType.PARALLEL.value:
            self.type_coffee_creator_service.start_workers(data=cortado_data, module=module, pins=pins)
            if len(self.type_coffee_creator_service) > 0:
                self.type_coffee_creator_service.wait_for_workers_to_finish()
        elif self.type_coffee_creator_service == CoffeeCreatorType.SEQUENTIAL.value:
            pass
        else:
            message = NoSuchCoffeeTypeCreatorService().message

        if message is None:
            message : str = f"Customer: {cortado_data['customerName']} successfully recieved {cortado_data['quantity']} Cortado"
            history : Dict[str, Any] = {"time_for_order" : time() - start_time}
        
        return (message, history) if verbose else (message, {}) 