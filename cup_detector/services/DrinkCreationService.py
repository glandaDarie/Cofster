from typing import Dict, Callable, Generator
from helpers.coffee_machine_controller import CoffeeMachineController
import concurrent.futures
from threading import Event
from utils.logger import thread_information_logger

class DrinkCreationSevice(CoffeeMachineController):
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
                    futures[executor.submit(lambda : self.__create_drink(drink_information=drink_information))] = "create_drink"
                    futures[executor.submit(lambda : self.__continuously_check_cup(callback_cup_detection=callback_cup_detection))] = "continuously_check_cup"
                    
                    for future in concurrent.futures.as_completed(futures):
                        try:
                            result_drink_creation : bool|Generator = future.result()                                            
                            if isinstance(result_drink_creation, bool):
                                print(f"Result: {result_drink_creation}")
                                if result_drink_creation:
                                    executor.shutdown()
                                    thread_information_logger(futures)
                                    break
                            # # implementation is still dummy here, need to remove the if statement
                            # if isinstance(result_drink_creation, Generator):
                            #     for result_generator_item in result_drink_creation:
                            #         print(f"Result: {result_generator_item}")
                            #         if result_generator_item == "Cup not detected":
                            #             pass
                            # elif isinstance(result_drink_creation, bool):
                            #     print(f"Result: {result_drink_creation}")
                            #     if result_drink_creation:
                            #         executor.shutdown()
                            #         thread_information_logger(futures)
                            #         break
                        except InterruptedError as e:  
                            return f"Error from thread: {e}"                         
                print("Coffee creation complete.")
                drink_information.pop(0)
                return
            else:
                print("Cup not detected, stopping coffee creation.")

    def __create_drink(self, drink_information : Dict[str, str]) -> bool | str:
        while True:
            try:
                is_drink_creation_interrupted : bool = self.stop_drink_creation_event.wait(timeout=10)
                # do the drink creation here
                # print(drink_information)
                # need to also monitor if the cup was detected throughout the 10 seconds that the state didn't change
                if is_drink_creation_interrupted:
                    print(f"is_drink_creation_interrupted: {is_drink_creation_interrupted}")
                    # self.stop_drink_creation_event.clear()
                    continue
            except Exception as e:
                return f"Error, cup is moved again from the normal position: {e}"
            self.stop_continuous_cup_checking.set()
            return True

    def __continuously_check_cup(self, callback_cup_detection : Callable[[bool], bool]) -> Generator:
        while not self.stop_continuous_cup_checking.is_set():
            if callback_cup_detection():
                self.stop_drink_creation_event.clear()
                yield "Cup detected"            
            else:
                self.stop_drink_creation_event.set()
                yield "Cup not detected"