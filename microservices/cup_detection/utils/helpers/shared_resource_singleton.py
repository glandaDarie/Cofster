from typing import Dict, Type
from threading import Lock
from abc import ABC, abstractmethod

class SharedResourceSingleton(ABC):
    _singleton_instances: Dict[Type['SharedResourceSingleton'], 'SharedResourceSingleton'] = {}

    @classmethod
    def __new__(cls, *args, **kwargs):
        if cls not in cls._singleton_instances:
            cls._singleton_instances[cls] = super().__new__(cls)
            cls._singleton_instances[cls].lock = Lock()
            cls._singleton_instances[cls].state = [False]
        return cls._singleton_instances[cls]

    @abstractmethod
    def set_state(self, *args, **kwargs) -> None:
        pass

    @abstractmethod
    def get_state(self) -> bool:
        pass