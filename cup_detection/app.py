from typing import List, Dict
import numpy as np
import cv2
from ultralytics import YOLO
from utils.constants import CAMERA_INDEX, WINDOW_NAME
from detectors.YOLOv8 import YOLOv8Detector
from utils.firebase_rtd_url import DATABASE_OPTIONS
from messaging.drinkInformationConsumer import DrinkInformationConsumer
from threading import Thread
from threading import Lock
from utils.logger import LOGGER
from utils.arguments_parser import ArgumentParser
from utils.constants import TABLE_NAME
from services.drinkCreationService import DrinkCreationSevice
from services.imageProcessorService import ImageProcessorBuilderService
from time import time
from services.llm_services.openAIService import OpenAIService
from utils.constants import PROMPT_TEMPLATE
from threading import Event, active_count
from utils.paths import PATH_MODEL_CUP_DETECTION
# from utils.paths import PATH_MODEL_PLACEMENT_DETECTION

"""
Handles the real-time processing of coffee drink information. It listens for updates from a message broker,
generates prompts for an AI service to determine coffee ingredients, performs real-time cup detection, and creates coffee drinks.

Usage:
    Run this script to initiate coffee drink processing. It continuously listens for updates on coffee drink information,
    generates prompts for an AI service to determine ingredients, performs real-time cup detection, and creates coffee drinks
    until manually terminated.

    The script initializes several components:
    - A message broker listener for coffee drink information.
    - An AI service for generating ingredients based on coffee drink names.
    - Real-time camera capture for cup detection.
    - Locks and callback functions for managing state and coordination.
    - A background thread for coffee drink creation.

    The process includes:
    1. Listening for and receiving coffee drink information updates.
    2. Generating prompts for an AI service based on coffee names.
    3. Using the AI service to determine coffee ingredients.
    4. Initializing and opening a camera for real-time cup detection.
    5. Managing locks and callback functions for state synchronization.
    6. Creating coffee drinks in a background thread.
    7. Real-time frame processing for cup detection and user interface display.
    8. Checking for completion of coffee drinks.
"""

if __name__ == "__main__":
    cli_arguments = ArgumentParser.get_arguments()
    drinks_information_consumer : DrinkInformationConsumer = DrinkInformationConsumer(table_name=TABLE_NAME, options=DATABASE_OPTIONS)
    main_thread_terminated_event : Event = Event()
    background_firebase_table_update_thread : Thread = Thread(target=drinks_information_consumer.listen_for_updates_on_drink_message_broker)
    background_firebase_table_update_thread.daemon = True
    background_firebase_table_update_thread.start()
    openai_service : OpenAIService = OpenAIService()
    while True:
        if len(drinks_information_consumer.drinks_information) > 0:
            coffee_name : str = drinks_information_consumer.drinks_information[0]["coffeeName"]
            prompt : str = PROMPT_TEMPLATE.format(coffee_name)
            coffee_ingredients : Dict[str, str] = openai_service(prompt=prompt)
            if cli_arguments.llm_recipe:
                drinks_information_consumer.drinks_information[0] : Dict[str, str] = {**drinks_information_consumer.drinks_information[0], \
                                                                                      **coffee_ingredients}
            print(f"new drinks information consumer : {drinks_information_consumer.drinks_information}")
            camera : object = cv2.VideoCapture(CAMERA_INDEX) 
            if not camera.isOpened():
                LOGGER.error("Error when trying to open the camera")
                break
            success, frame = camera.read()
            if not success or frame is None:
                LOGGER.error(f"Error when trying to read the frame: {frame}")
                break

            cup_detection_model : YOLO = YOLOv8Detector.detect_cup(path_weights=PATH_MODEL_CUP_DETECTION)
            # cup_detection_placement_model : YOLO = YOLOv8_detector.detect_cup_placement(path=PATH_MODEL_PLACEMENT_DETECTION)

            cup_detection_lock : Lock = Lock()
            cup_detection_state : List[bool] = [False]

            def callback_cup_detection(new_cup_detection_state : bool | None = None) -> bool:
                with cup_detection_lock:
                    if new_cup_detection_state is not None:
                        cup_detection_state[0] = new_cup_detection_state
                    return cup_detection_state[0]
            
            finished_thread_lock : Lock = Lock()
            finished_drink_state : List[bool] = [False]

            def drink_finished_callback(new_finished_drink_state : bool | None = None) -> bool:
                with finished_thread_lock:
                    if new_finished_drink_state is not None:
                        finished_drink_state[0] = new_finished_drink_state
                    return finished_drink_state[0]

            drink_creation_service : DrinkCreationSevice = DrinkCreationSevice(drink_finished_callback=drink_finished_callback)
            background_create_coffee_drink_thread : Thread = Thread(target=drink_creation_service.simulate_creation, \
                                                                    args=(drinks_information_consumer, callback_cup_detection, main_thread_terminated_event))
            background_create_coffee_drink_thread.daemon = True
            background_create_coffee_drink_thread.start()
            
            start_fps_time : float = time()
            end_fps_time : float = start_fps_time
            image_processor_builder_service : ImageProcessorBuilderService = ImageProcessorBuilderService()
            while success:
                end_fps_time = time()
                cup_detection_model, frame, cup_detected = YOLOv8Detector.detect_cup(frame=frame, model=cup_detection_model)
                callback_cup_detection(cup_detected)
                print(f"len(consumer.drinks_information): {len(drinks_information_consumer.drinks_information)}")
                frame : np.ndarray = image_processor_builder_service \
                    .add_text_number_of_frames(frame=frame, start_time=start_fps_time, end_time=end_fps_time) \
                    .build()
                start_fps_time = end_fps_time
                cv2.imshow(WINDOW_NAME, frame)
                cv2.waitKey(1)
                success, frame = camera.read()
                if drink_finished_callback():
                    drink_finished_callback(False)
                    break
            camera.release()
            cv2.destroyAllWindows() 
            main_thread_terminated_event.set()
            print(f"Number of running threads before join: {active_count()}")
            background_create_coffee_drink_thread.join()
            print(f"Number of running threads after join: {active_count()}")
            main_thread_terminated_event.clear()
