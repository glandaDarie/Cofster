from typing import Dict, Callable, Generator
from helpers.coffee_machine_controller import CoffeeMachineController
from time import sleep
import concurrent.futures
from threading import Event
# import ctypes

class DrinkCreationInterrupt(Exception):
    pass

class DrinkCreationSevice(CoffeeMachineController):
    def __init__(self):
        super().__init__()
        self.stop_drink_creation_event : Event = Event()
        self.drink_successfully_created : bool = False

    def simulate_creation(self, drink_information : Dict[str, str], callback_cup_detection : Callable[[bool], bool]) -> str:
        while True:
            if callback_cup_detection():
                with concurrent.futures.ThreadPoolExecutor(max_workers=2) as executor:
                    self.stop_drink_creation_event.clear()
                    futures : Dict[concurrent.futures.ThreadPoolExecutor, str] = {}
                    futures[executor.submit(lambda : self.__create_drink(drink_information=drink_information))] = "create_drink"
                    futures[executor.submit(lambda : self.__continuously_check_cup(callback_cup_detection=callback_cup_detection))] = "continuously_check_cup"
                    
                    for future in concurrent.futures.as_completed(futures):
                        try:
                            # result_drink_creation : bool|Generator = future.result()
                            # print(f"result_cup_detected: {next(result_drink_creation)}")
                            # if isinstance(result_drink_creation, bool):
                            #     self.drink_successfully_created = result_drink_creation
                            #     print(f"self.drink_successfully_created: {self.drink_successfully_created}")
                            #     sleep(5)
                            #     break
                            result_drink_creation : bool | Generator = future.result()
                            if isinstance(result_drink_creation, Generator):
                                if next(result_drink_creation) == "Cup not detected":
                                    break                               
                            #     for result_cup_detected in future.result():
                            #         print(f"result_cup_detected: {result_cup_detected}")
                            #         if result_cup_detected == "Cup not detected":
                            #             break
                            elif isinstance(result_drink_creation, bool):
                                if result_drink_creation:
                                    self.drink_successfully_created = result_drink_creation
                                    print(f"self.drink_successfully_created: {self.drink_successfully_created}")
                                    break
                        except InterruptedError as e:  
                            return f"Error from thread: {e}"
                                        
                if self.drink_successfully_created:
                    print("Coffee creation complete.")
                    drink_information.pop(0)
                    self.drink_successfully_created = False
                    break
                # sleep(5)
                # drink_information.pop(0) 
            else:
                print("Cup not detected, stopping coffee creation.")

    def __create_drink(self, drink_information : Dict[str, str]) -> bool | str:
        while True:
            try:
                is_drink_creation_interrupted : bool = self.stop_drink_creation_event.wait(timeout=10)
                # do the drink creation here
                # print(drink_information)
                if is_drink_creation_interrupted:
                    print(f"is_drink_creation_interrupted: {is_drink_creation_interrupted}")
                    self.stop_drink_creation_event.clear()
                    continue
            except Exception as e:
                return f"Error, cup is moved again from the normal position: {e}"
            return True

    def __continuously_check_cup(self, callback_cup_detection : Callable[[bool], bool]) -> Generator:
        while True:
            if callback_cup_detection():
                yield "Cup detected"            
            else:
                self.stop_drink_creation_event.set()
                yield "Cup not detected"
    