from typing import Dict, Any, Callable, Generator
from time import time
import concurrent.futures
from threading import Event

from messaging.drink_information_consumer import DrinkInformationConsumer
from enums.coffee_process_types import CoffeeProcessTypes
from utils.constants import CUP_DETECTION_DURATION_SECONDS
from utils.logger import (
    thread_information_logger, 
    LOGGER
)
from controllers.coffee_creation_controller import CoffeeCreationController
from services.coffee_creation_service import CoffeeCreationService

class DrinkCreationSevice:
    """
    A service for simulating drink creation in a coffee machine.

    This service uses threads to simulate the creation of drinks in a coffee machine.
    It monitors cup detection and creates drinks when a cup is detected.

    Args:
        drink_finished_callback (Callable[[bool], bool]): A callback function to handle the completion of drink creation.

    Attributes:
        drink_finished_callback (Callable[[bool], bool]): A callback function to handle the completion of drink creation.
        stop_drink_creation_event (Event): An event used to control drink creation threads.
        stop_continuous_cup_checking_event (Event): An event used to control cup detection monitoring.
        start_time_cup_detection (float): The start time for cup detection monitoring.

    Methods:
        simulate_creation: Public method to simulate the creation of drinks based on cup detection.
        __create_drink: Private method to create drinks.
        __continuously_check_cup: Private method to continuously monitor cup detection.
    """
    def __init__(self, drink_finished_callback : Callable[[bool], bool]):
        """
        Initialize the DrinkCreationService.

        Args:
            drink_finished_callback (Callable[[bool], bool]): A callback function to handle the completion of drink creation.
        """
        self.drink_finished_callback : Callable[[bool], bool] = drink_finished_callback
        self.stop_drink_creation_event : Event = Event()
        self.stop_continuous_cup_checking_event : Event = Event()
        self.start_time_cup_detection : float = time()

    def simulate_creation(self, drinks_information_consumer : DrinkInformationConsumer, callback_cup_detection : Callable[[bool], bool], \
                          main_thread_terminated_event : Event) -> str:
        """
        Simulate the creation of drinks based on cup detection.

        This method continuously monitors cup detection and, when the given cup is detected,
        it spawns threads to create drinks using the provided drink information and cup detection callback.
        It waits for the drink creation to complete and then cleans up the order information.

        Args:
            drinks_information_consumer (DrinkInformationConsumer): An instance of DrinkInformationConsumer
                containing information about the drinks to be created.
            callback_cup_detection (Callable[[bool], bool]): A callback function to detect the presence of a cup.
            main_thread_terminated_event (Event): An event used to send broadcast alerts to the children threads to join the main one

        Returns:
            str: A message indicating the status of the drink creation process.
        """
        while not main_thread_terminated_event.is_set():
            if callback_cup_detection():
                with concurrent.futures.ThreadPoolExecutor(max_workers=1) as executor:
                    self.stop_drink_creation_event.clear()
                    self.stop_continuous_cup_checking_event.clear()

                    futures : Dict[concurrent.futures.ThreadPoolExecutor, str] = {}
                    futures[executor.submit(lambda : self.__continuously_check_cup(callback_cup_detection=callback_cup_detection, \
                        main_thread_terminated_event=main_thread_terminated_event))] = "continuously_check_cup" 
                    
                    drink_creation_completed : bool = False
                    for future in concurrent.futures.as_completed(futures):
                        try:
                            results_drink_creation : Generator = future.result()
                            for result_drink_creation in results_drink_creation:
                                print(f"Status: {result_drink_creation}")
                                LOGGER.info(f"DrinkCreationSevice >> simulate_creation: Coffee information status: {result_drink_creation}")
                                if result_drink_creation == CoffeeProcessTypes.DRINK_CREATED.value:
                                    self.stop_continuous_cup_checking_event.set()
                                    executor.shutdown()
                                    thread_information_logger(futures)
                                    drink_creation_completed = True
                                    break
                        except InterruptedError:
                            raise   
                        finally:                    
                            LOGGER.info("DrinkCreationSevice >> simulate_creation: Coffee creation completed")
                
                if drink_creation_completed:
                    table_name : str = drinks_information_consumer.table_name
                    order_id : str = drinks_information_consumer.order_ids[0]
                    drinks_information_consumer.update_order_in_message_broker(new_value=1, endpoint=f"/{table_name}/{order_id}/coffeeStatus")
                    drinks_information_consumer.delete_order_from_message_broker(endpoint=f"/{table_name}/{order_id}")
                    drinks_information_consumer.drinks_information.pop(0)
                    drinks_information_consumer.order_ids.pop(0)
                    self.drink_finished_callback(True)
            else:
                LOGGER.info("DrinkCreationSevice >> simulate_creation: Cup not detected")
                print("Cup not detected")

    def __continuously_check_cup(self, callback_cup_detection : Callable[[bool], bool], main_thread_terminated_event : Event) -> Generator:
        """
        Private method to continuously monitor cup detection and trigger actions accordingly.

        Args:
            callback_cup_detection (Callable[[bool], bool]): A callback function to detect the presence of the cup.
            main_thread_terminated_event (Event): An event to signal termination of the main thread.

        Yields:
            str: The status of cup detection - "Cup detected" if the cup is detected, "Cup not detected" otherwise.
        """
        while not main_thread_terminated_event.is_set() and not self.stop_continuous_cup_checking_event.is_set():
            if callback_cup_detection():
                elapsed_time_cup_detection : float = time() - self.start_time_cup_detection
                if elapsed_time_cup_detection >= CUP_DETECTION_DURATION_SECONDS:
                    print("Entered here safe and sound")
                    # make a HTTP call to create the coffee, without still continously performing cup checking
                    # requests.get("http://{ip}:{port}/app")

                    payload : Dict[str, Any] = {}
                    coffee_creation_service : CoffeeCreationService = CoffeeCreationController(CoffeeCreationService()) \
                        .create_coffee(
                            base_url="http://192.168.1.106:5000", \
                            endpoint="/coffee", \
                            payload=payload
                    )
                    
                    self.__reset_cup_detection_timer()
                    yield CoffeeProcessTypes.DRINK_CREATED.value

                yield CoffeeProcessTypes.CUP_DETECTED.value
            else:
                self.__reset_cup_detection_timer()
                self.stop_drink_creation_event.set()
                yield CoffeeProcessTypes.CUP_NOT_DETECTED.value
    
    def __reset_cup_detection_timer(self) -> None:
        """
        Reset the cup detection timer.

        This method resets the start time of cup detection to the current time.
        """
        self.start_time_cup_detection = time()
