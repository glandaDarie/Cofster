from typing import Dict, Any, List, Tuple
from time import time
import os
from types import ModuleType
from utils.enums.coffee_creator_types import CoffeeCreatorType
from utils.helpers.module_from_path import get_module_from_path
from utils.exceptions.no_such_coffee_type_creator_service_error import NoSuchCoffeeTypeCreatorService
from utils.exceptions.no_all_params_passed_error import NoAllParamsPassedError
from interfaces.type_coffee_creator_service import TypeCoffeeCreatorService
from utils.constants.drink_sizes import DRINK_SIZES
from utils.exceptions.no_such_drink_size_error import NoSuchDrinkSizeError

class CoffeeCreatorSimpleFacade:
    @staticmethod
    def create(params : Dict[str, Any]) -> Tuple[str, Dict[str, Any]]:
        drink_data : Dict[str, Any] = params.get("drink_data", None)
        pins : List[int] = params.get("pins", None)
        parallel_coffee_creator_service : TypeCoffeeCreatorService = params.get("parallel_coffee_creator_service", None)
        attrs_path : str = params.get("attrs_path", None)

        drink_size : str = drink_data.get("coffeeCupSize", "S")
        if drink_size in DRINK_SIZES:
            attrs_path = os.path.join(attrs_path, drink_size)
        else:
            raise NoSuchDrinkSizeError()

        if drink_data is None or pins is None or parallel_coffee_creator_service is None or attrs_path is None:
            raise NoAllParamsPassedError()

        start_time : float = time()
        message : str | None = None
        history : Dict[str, Any] = {}
        verbose : bool = drink_data.get("verbose", False)

        module : ModuleType = get_module_from_path(module_path=attrs_path)

        if parallel_coffee_creator_service == CoffeeCreatorType.PARALLEL.value:
            parallel_coffee_creator_service.start_workers(data=drink_data, module=module, pins=pins)
            if len(parallel_coffee_creator_service) > 0:
                parallel_coffee_creator_service.wait_for_workers_to_finish()
        elif parallel_coffee_creator_service == CoffeeCreatorType.SEQUENTIAL.value:
            pass
        else:
            message = NoSuchCoffeeTypeCreatorService().message

        if message is None:
            drink_name: str = drink_data.get("coffeeName", "Coffee drink")
            customer_name: str = drink_data.get("customerName", "Anonymous").capitalize()
            drink_quantity: str = drink_data.get("quantity", "1")

            message : str = f"Customer {customer_name} successfully recieved {drink_quantity} {drink_name if drink_quantity == 1 else f'{drink_name}s'}"
            history : Dict[str, Any] = {"time_for_order" : time() - start_time}
            
        return (message, history) if verbose else (message, {})