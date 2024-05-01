from typing import List
from utils.helpers.shared_resource_singleton import SharedResourceSingleton

class DrinkFinished(SharedResourceSingleton):
    def set_state(self, new_state : bool) -> None:
        with self.lock:
            self.state[0] = new_state
    
    def get_state(self) -> bool:
        with self.lock:
             return self.state[0]