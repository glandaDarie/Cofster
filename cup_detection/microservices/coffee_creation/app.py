from typing import List, Dict, Any
import numpy as np
import cv2
from time import time
from threading import Event
from threading import Thread
from threading import Lock
from utils.constants import CAMERA_INDEX, WINDOW_NAME, TABLE_NAME
from utils.logger import LOGGER
from utils.firebase_rtd_url import DATABASE_OPTIONS
from utils.paths import PATH_MODEL_CUP_DETECTION
from detectors.Detector import Detector
# from utils.paths import PATH_MODEL_PLACEMENT_DETECTION
from detectors.YOLOv8 import YOLOv8Detector
from messaging.drink_information_consumer import DrinkInformationConsumer
from services.drink_creation_service import DrinkCreationSevice
from services.image_processor_service import ImageProcessorBuilderService
from simple_factories.recipe_simple_factory import RecipeSimpleFactory
import torch
# debugging now with this
from time import sleep

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
    print("-----Coffee creation process is running on Raspberry Pi 4-----")
    drinks_information_consumer : DrinkInformationConsumer = DrinkInformationConsumer(table_name=TABLE_NAME, options=DATABASE_OPTIONS)
    main_thread_terminated_event : Event = Event()
    background_firebase_table_update_thread : Thread = Thread(target=drinks_information_consumer.listen_for_updates_on_drink_message_broker)
    background_firebase_table_update_thread.daemon = True
    background_firebase_table_update_thread.start()
    cup_detection_model : Detector = YOLOv8Detector(path_weights=PATH_MODEL_CUP_DETECTION, device=torch.device("cuda"))

    while True:
        if len(drinks_information_consumer.drinks_information) > 0:
            
            coffee_information : Dict[str, Any] = drinks_information_consumer.drinks_information[0]
            customer_name : str = coffee_information["customerName"]
            coffee_name : str = coffee_information["coffeeName"]
            recipe_type : str = coffee_information["recipeType"]

            print(f"{customer_name = } | {coffee_name = } | {recipe_type}")

            customer_data : Dict[str, Any] = {
                "customer_name" : customer_name,
                "coffee_name" : coffee_name
            }
            
            coffee_ingredients_response : str = RecipeSimpleFactory.create(recipe_type=recipe_type, customer_data=customer_data)
            print(f"coffee_ingredients_response: {coffee_ingredients_response}")
            drinks_information_consumer.drinks_information[0] = { 
                **drinks_information_consumer.drinks_information[0], 
                **coffee_ingredients_response
            } 

            print(f"drinks_information_consumer.drinks_information[0]: {drinks_information_consumer.drinks_information[0]}")

            sleep(10)

            print(f"new drinks information consumer : {drinks_information_consumer.drinks_information}")
            
            camera : object = cv2.VideoCapture(CAMERA_INDEX) 
            if not camera.isOpened():
                LOGGER.error("Error when trying to open the camera")
                break
            success, frame = camera.read()
            if not success or frame is None:
                LOGGER.error(f"Error when trying to read the frame: {frame}")
                break

            frame, detected_classes, _, _, _ = cup_detection_model(frame=frame)

            # cup_detection_model : YOLO = YOLOv8Detector.detect(path_weights=PATH_MODEL_CUP_DETECTION)
            # cup_detection_placement_model : YOLO = YOLOv8Detector.detect(path_weights=PATH_MODEL_PLACEMENT_DETECTION)

            cup_detection_lock : Lock = Lock()
            cup_detection_state : List[bool] = [False]

            def cup_detection_callback(new_cup_detection_state : bool | None = None) -> bool:
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
                                                                    args=(drinks_information_consumer, cup_detection_callback, main_thread_terminated_event))
            background_create_coffee_drink_thread.daemon = True
            background_create_coffee_drink_thread.start()
            
            start_fps_time : float = time()
            end_fps_time : float = start_fps_time
            image_processor_builder_service : ImageProcessorBuilderService = ImageProcessorBuilderService()
            while success:
                end_fps_time = time()
                frame, detected_classes, cup_detected, _, _ = cup_detection_model(frame=frame)
                # cup_detection_model, frame, cup_detected, cup_bounding_boxes = YOLOv8Detector.detect(frame=frame, model=cup_detection_model)
                # cup_detection_placement_model, frame, cup_placement_detected, placement_bounding_boxes = YOLOv8Detector.detect(frame=frame, \
                #                                                                                                                model=cup_detection_placement_model)
                # cup_position_valid : bool = YOLOv8Detector.is_cup_in_correct_position(object1_boxes=cup_bounding_boxes, object2_boxes=placement_bounding_boxes, tolerance=6)
                cup_detection_callback(cup_detected)
                print(f"len(consumer.drinks_information): {len(drinks_information_consumer.drinks_information)}") # testing the message queue
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
            main_thread_terminated_event.set()
            background_create_coffee_drink_thread.join()
            main_thread_terminated_event.clear()
            if len(drinks_information_consumer.drinks_information) <= 0:
               cv2.destroyAllWindows() 

