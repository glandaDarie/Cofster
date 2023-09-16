from typing import List, Dict, Callable, Generator
from helpers.coffee_machine_controller import CoffeeMachineController
import concurrent.futures
from threading import Event, Lock
from utils.logger import thread_information_logger

class DrinkCreationSevice(CoffeeMachineController):
    """
    A service for simulating drink creation in a coffee machine.

    This service uses threads to simulate the creation of drinks in a coffee machine.
    It monitors cup detection and creates drinks when a cup is detected.

    Args:
        None

    Attributes:
        stop_drink_creation_event (Event): An event used to control drink creation threads.
        stop_continuous_cup_checking (Event): An event used to control cup detection monitoring.

    Methods:
        simulate_creation: Public method to simulate the creation of drinks based on cup detection.
        __create_drink: Private method to create drinks.
        __continuously_check_cup: Private method to continuously monitor cup detection.
    """
    def __init__(self):
        super().__init__()
        self.stop_drink_creation_event : Event = Event()
        self.stop_continuous_cup_checking : Event = Event()

    def simulate_creation(self, drink_information : Dict[str, str], callback_cup_detection : Callable[[bool], bool]) -> str:
        while True:
            if callback_cup_detection():
                with concurrent.futures.ThreadPoolExecutor(max_workers=2) as executor:
                    self.stop_drink_creation_event.clear()
                    self.stop_continuous_cup_checking.clear()
                    futures : Dict[concurrent.futures.ThreadPoolExecutor, str] = {}
                    futures[executor.submit(lambda : self.__create_drink(drink_information=drink_information, \
                            callback_cup_detection=callback_cup_detection))] = "create_drink"
                    futures[executor.submit(lambda : self.__continuously_check_cup(callback_cup_detection=callback_cup_detection))] = \
                            "continuously_check_cup"
                    for future in concurrent.futures.as_completed(futures):
                        try:
                            result_drink_creation : bool|Generator = future.result()                                            
                            if isinstance(result_drink_creation, bool):
                                print(f"Result: {result_drink_creation}")
                                if result_drink_creation:
                                    executor.shutdown()
                                    thread_information_logger(futures)
                                    break
                        except InterruptedError as e:  
                            return f"Error from thread: {e}"                         
                print("Coffee creation complete.")
                drink_information.pop(0)
                return
            else:
                print("Cup not detected, stopping coffee creation.")

    def __create_drink(self, drink_information : Dict[str, str], callback_cup_detection : Callable[[bool], bool]) -> bool | str:
        """
        Private thread method to create drinks.

        Args:
            drink_information (Dict[str, str]): Information about the drink that is to be created.
            callback_cup_detection (Callable[[bool], bool]): A callback function to detect the presence of a cup.

        Returns:
            bool | str: True if drink creation is successful, an error message otherwise. 
                        Interruptions happen if the cup is not present (moved) from the specific position.
        """
        while True:
            try:
                is_drink_creation_interrupted : bool = self.stop_drink_creation_event.wait(timeout=10)
                # do the drink creation here
                # print(drink_information)
                if is_drink_creation_interrupted or not callback_cup_detection():
                    print(f"is_drink_creation_interrupted: {is_drink_creation_interrupted}")
                    self.stop_drink_creation_event.clear()
                    continue
            except Exception as e:
                return f"Error, cup is moved again from the normal position: {e}"
            self.stop_continuous_cup_checking.set()
            return True

    def __continuously_check_cup(self, callback_cup_detection : Callable[[bool], bool]) -> Generator:
        """
        Private thread method to continuously monitor cup detection.

        Args:
            callback_cup_detection (Callable[[bool], bool]): A callback function to detect the presence of the respective cup.

        Yields:
            str: "Cup detected" if the cup is detected, "Cup not detected" otherwise.
        """
        while not self.stop_continuous_cup_checking.is_set():
            if callback_cup_detection():
                yield "Cup detected"            
            else:
                self.stop_drink_creation_event.set()
                yield "Cup not detected"