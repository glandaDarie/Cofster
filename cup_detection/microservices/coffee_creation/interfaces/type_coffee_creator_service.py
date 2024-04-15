from abc import ABC, abstractmethod
from typing import List, Dict, Any
from threading import Thread
from types import ModuleType

class TypeCoffeeCreatorService(ABC):
    @abstractmethod
    def start_workers(self, data: Dict[str, Any], module: ModuleType, pins: List[int]) -> Dict[str, Thread]:
        pass

    @abstractmethod
    def wait_for_workers_to_finish(self):
        pass
