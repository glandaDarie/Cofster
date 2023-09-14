
from typing import Dict, Callable
from helpers.coffee_machine_controller import CoffeeMachineController
from time import sleep

class DrinkCreationSevice(CoffeeMachineController):
    def __init__(self):
        super().__init__()

    def simulate_creation(self, drink_information : Dict[str, str], callback_cup_detection : Callable[[bool], bool]) -> str:
        while True:
            if callback_cup_detection():
                self.__create_drink(drink_information=drink_information, callback_cup_detection=callback_cup_detection)
                print("Coffee creation complete.")
                # drink_information.pop(0) 
            else:
                print("Cup not detected, stopping coffee creation.")
                sleep(1)
    
    def __create_drink(self, drink_information : Dict[str, str], callback_cup_detection : Callable[[bool], bool]) -> str:
        sleep(30)