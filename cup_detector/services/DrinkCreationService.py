from typing import Type, Dict, Callable
from time import sleep

class DrinkCreationSevice():
    def __init__(self):
        pass

    @classmethod
    def create_drink(cls : Type["DrinkCreationSevice"], drink_information : Dict[str, str], callback_cup_detection : Callable[[bool], bool]) -> str:
        while True:
            if callback_cup_detection():
                print(drink_information)
                sleep(4)  # Simulate the drink creation time
                print("Coffee creation complete.")
                # drink_information.pop(0) 
            else:
                print("Cup not detected, stopping coffee creation.")
                sleep(1)