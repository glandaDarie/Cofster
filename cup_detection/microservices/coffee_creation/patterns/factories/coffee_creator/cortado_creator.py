from typing import Tuple, Dict, Any
from interfaces.coffee_creator import CoffeeCreator
from time import time

class CortadoCreator(CoffeeCreator):
    def do(self, cortado_data : Dict[str, Any]) -> Tuple[str]:
        start_time : float = time()
        verbose : bool = cortado_data.get("verbose", False)

        # here should be the real implementation, can also add a decorator for this instead of like this
        message : str = f"Customer: {cortado_data['customerName']} successfully recieved {cortado_data['quantity']} Cortado"
        history : Dict[str, Any] = {"time_for_order" : time() - start_time}
        
        return (message, history) if verbose else (message, {}) 