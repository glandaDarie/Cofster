from typing import List, Dict, Callable
import RPi.GPIO as GPIO
from functools import wraps
from typing import Any

def initialize_gpio(*pins: List[int], **gpio_information: Dict[str, Any]) -> Any:
    def decorator(func : Callable):
        @wraps(func)
        def wrapper(self, data : Dict[str, Any], *args : List[Any], **kwargs : Dict[str, Any]):
            GPIO.setmode(GPIO.BCM)
            GPIO.setwarnings(False)
            for pin in pins:
                GPIO.setup(pin, gpio_information["type_input"])
            return func(self, data, *args, **kwargs, pins=pins)
        return wrapper
    return decorator