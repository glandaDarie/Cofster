from typing import List, Dict, Callable
import RPi.GPIO as GPIO
from functools import wraps
from typing import Any

from utils.constants.pin_ingredient_mapper import LED_INDICATOR

def initialize_drink(*pins: List[int], **gpio_information: Dict[str, Any]) -> Any:
    def decorator(func : Callable):
        @wraps(func)
        def wrapper(self, data : Dict[str, Any], *args : List[Any], **kwargs : Dict[str, Any]):
            GPIO.setmode(GPIO.BCM)
            GPIO.setwarnings(False)
            for pin in pins:
                GPIO.setup(pin, gpio_information["type_input"])
            GPIO.setup(LED_INDICATOR, GPIO.OUT)

            return func(self, data, *args, **kwargs, pins=pins)
        return wrapper
    return decorator