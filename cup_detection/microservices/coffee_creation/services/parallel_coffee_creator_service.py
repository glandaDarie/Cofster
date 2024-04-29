from typing import List, Tuple, Dict, Any, Callable
from threading import Thread
from re import match
from types import ModuleType
from utils.regex.regex import INGREDIENT_WITH_LAST_CHARACTER_NUMBER
from interfaces.type_coffee_creator_service import TypeCoffeeCreatorService
from utils.enums.coffee_creator_types import CoffeeCreatorType
from utils.constants.drink_sizes import DRINK_SIZES

class ParallelCoffeeCreatorService(TypeCoffeeCreatorService):
    def __init__(self):
        self.workers : Dict[str, Thread] = {}

    def __len__(self) -> int:
        return len(self.workers)

    def __eq__(self, other : str) -> bool:
        return CoffeeCreatorType.PARALLEL.value == other

    def __getitem__(self, key : str) -> Thread:
        return self.workers[key]

    def start_workers(self, data : Dict[str, Any], module : ModuleType, pins: List[int]) -> Dict[str, Thread]:
        pin_index : int = 0
        for thread_id, (key, value) in enumerate(data.items()):
            if match(INGREDIENT_WITH_LAST_CHARACTER_NUMBER, key) is not None:
                ingredient : str = value.lower().replace(" ", "_")
                if hasattr(module, ingredient):
                    target : Callable = getattr(module, ingredient)
                    params : Tuple[int] = (pins[pin_index],)
                    worker_name : str = f"thread{thread_id + 1}"
                    self.workers[worker_name] = Thread(target=target, args=params)
                    self.workers[worker_name].daemon = True
                    self.workers[worker_name].start()
                    pin_index += 1
        return self.workers

    def wait_for_workers_to_finish(self):
        for worker_value in self.workers.values():
            worker_value.join()
    
    def __str__(self) -> str:
        return f"ParallelCoffeeCreatorService(workers={self.workers})"