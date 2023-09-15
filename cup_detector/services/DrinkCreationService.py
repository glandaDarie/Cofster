from typing import Dict, Callable, Generator
from helpers.coffee_machine_controller import CoffeeMachineController
from time import sleep
import concurrent.futures
import multiprocessing
# import ctypes

class DrinkCreationInterrupt(Exception):
    pass

class DrinkCreationSevice(CoffeeMachineController):
    def __init__(self):
        super().__init__()

    def simulate_creation(self, drink_information : Dict[str, str], callback_cup_detection : Callable[[bool], bool]) -> str:
        while True:
            print("STILL HERE??")
            if callback_cup_detection():
            #     pool : multiprocessing.Pool = multiprocessing.Pool(processes=2)
            #     futures : Dict[concurrent.futures.ThreadPoolExecutor, str] = {}
            #     futures[pool.apply_async(self.__create_drink, (drink_information,))] = "create_drink"
            #     futures[pool.apply_async(self.__continuously_check_cup, (callback_cup_detection,))] = "continuously_check_cup"

            #     for future in futures:
            #         if futures[future] == "continuously_check_cup":
            #             try:
            #                 # result_cup_detected = future.get()
            #                 for result_cup_detected in future.get():
            #                     print(f"result_cup_detected: {result_cup_detected}")
            #                     if result_cup_detected == "Cup not detected":
            #                         pool.terminate()
            #             except InterruptedError as e:
            #                 return f"Error from process: {e}"
            #     print("Coffee creation complete.")
            #     sleep(5)
            # else:
            #     print("Cup not detected, stopping coffee creation.")


                with concurrent.futures.ThreadPoolExecutor(max_workers=2) as executor:
                    futures : Dict[concurrent.futures.ThreadPoolExecutor, str] = {}
                    futures[executor.submit(lambda : self.__create_drink(drink_information=drink_information))] = "create_drink"
                    futures[executor.submit(lambda : self.__continuously_check_cup(\
                        callback_cup_detection=callback_cup_detection))] = "continuously_check_cup"
                    
                    for future in concurrent.futures.as_completed(futures):
                        if futures[future] == "continuously_check_cup":
                            try:
                                for result_cup_detected in future.result():
                                    print(f"result_cup_detected: {result_cup_detected}")
                                    if result_cup_detected == "Cup not detected":
                                        executor.shutdown()
                                        raise DrinkCreationInterrupt("Interrupted drink creation")                                       
                            except InterruptedError as e:  
                                return f"Error from thread: {e}"
                print("Coffee creation complete.")
                sleep(5)
                drink_information.pop(0) 
            else:
                print("Cup not detected, stopping coffee creation.")

    # def __terminate_futures(self, executor : concurrent.futures.ThreadPoolExecutor) -> str:
    #     for future in executor._threads:
    #         try:
    #             ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(future.ident), ctypes.py_object(SystemExit))
    #         except Exception as e:
    #             return f"Error terminating future: {e}"
    #         return "Terminated futures successfully"

    def __create_drink(self, drink_information : Dict[str, str]) -> str:
        try:
            sleep(30)
            # do the drink creation here
        except DrinkCreationInterrupt as e:
            print(f"Drink information: {drink_information}")
            return f"Error, cup is moved again from the normal position: {e}"
    
    def __continuously_check_cup(self, callback_cup_detection : Callable[[bool], bool]) -> Generator:
        while True:
            if callback_cup_detection():
                yield "Cup detected"            
            else:
                yield "Cup not detected"
    