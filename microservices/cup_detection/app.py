from typing import Dict, Any, Optional
import numpy as np
import cv2
from time import time
from threading import Thread, Event 
from kafka import KafkaProducer

from utils.constants import (
    CAMERA_INDEX,
    WINDOW_NAME_CUP_DETECTION,
    WINDOW_NAME_PIPE_DETECTION,
    TABLE_NAME
)
from utils.logger import LOGGER
from utils.firebase_rtd_url import DATABASE_OPTIONS
from utils.mappers.coffee import COFFEE_NAME_MAPPER
from utils.mappers.cup_sizes import CUP_SIZE_MAPPER
from utils.constants import (
    BOOTSTRAP_SERVERS, 
    TOPIC_NAME
)
from utils.exceptions import MethodNotPassedToBuilderException
from utils.helpers.shared_resource_singleton import SharedResourceSingleton
from utils.helpers.desired_cup_size_detected import DesiredCupSizeDetected
from utils.helpers.pipe_detected import PipeDetected
from utils.helpers.drink_finished import DrinkFinished
from enums.cup_detection_model import CupDetectionModel
from detectors.Detector import Detector
from messaging.drink_information_consumer import DrinkInformationConsumer
from services.drink_creation_service import DrinkCreationSevice
from services.image_processor_service import ImageProcessorBuilderService
from services.pipe_detector_service import PipeDetectorBuilderService
from simple_factories.recipe_simple_factory import RecipeSimpleFactory
from simple_factories.cup_detection_factory import CupDetectionFactory

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
    LOGGER.info("-----Coffee creation process is running on Raspberry Pi 4-----")
    drinks_information_consumer : DrinkInformationConsumer = DrinkInformationConsumer(table_name=TABLE_NAME, options=DATABASE_OPTIONS)
    main_thread_terminated_event : Event = Event()
    background_firebase_table_update_thread : Thread = Thread(target=drinks_information_consumer.listen_for_updates_on_drink_message_broker)
    background_firebase_table_update_thread.daemon = True
    background_firebase_table_update_thread.start()
    cup_detection_model : Detector = CupDetectionFactory.create(cup_detection_model=CupDetectionModel.YOLOV8)

    while True: # should run till the process is stopped (automatically would like to stop the camera)
        if len(drinks_information_consumer.drinks_information) > 0:
            
            coffee_information : Dict[str, Any] = drinks_information_consumer.drinks_information[0]
            customer_name : str = coffee_information["customerName"]
            coffee_name : str = COFFEE_NAME_MAPPER.get(coffee_information["coffeeName"], None)
            recipe_type : str = coffee_information["recipeType"]
            cup_size : str = CUP_SIZE_MAPPER.get(coffee_information["coffeeCupSize"], None)

            if coffee_name is None or cup_size is None:
                drinks_information_consumer.drinks_information.pop(0)
                drinks_information_consumer.order_ids.pop(0)
                LOGGER.error(f"Error: Coffee {coffee_name} does not exist.")
                continue

            customer_data : Dict[str, Any] = {
                "customer_name" : customer_name,
                "coffee_name" : coffee_name
            }
            
            coffee_ingredients_response : str = RecipeSimpleFactory.create(recipe_type=recipe_type, customer_data=customer_data)
            drinks_information_consumer.drinks_information[0] = { 
                **drinks_information_consumer.drinks_information[0], 
                **coffee_ingredients_response
            } 

            print(f"new drinks information consumer : {drinks_information_consumer.drinks_information}")
            LOGGER.info(f"app.py: drink information received from client: {drinks_information_consumer.drinks_information}")

            # camera : object = cv2.VideoCapture(index=CAMERA_INDEX)
            camera : object = cv2.VideoCapture(index=0)
            if not camera.isOpened():
                LOGGER.error("Error when trying to open the camera")
                break

            success, frame = camera.read()
            if not success or frame is None:
                LOGGER.error(f"Error when trying to read the frame: {frame}")
                break

            frame, detected_classes, _, _, _ = cup_detection_model(frame=frame)

            desired_cup_size_detected : SharedResourceSingleton = DesiredCupSizeDetected()
            pipe_detected : SharedResourceSingleton = PipeDetected()
            drink_finished : SharedResourceSingleton = DrinkFinished()

            drink_creation_service : DrinkCreationSevice = DrinkCreationSevice(drink_finished_callback=drink_finished.set_state)
            background_create_coffee_drink_thread : Thread = Thread( 
                target=drink_creation_service.simulate_creation, 
                args=( 
                    drinks_information_consumer,
                    desired_cup_size_detected.get_state, 
                    pipe_detected.get_state, 
                    main_thread_terminated_event
                )
            )
            background_create_coffee_drink_thread.daemon = True
            background_create_coffee_drink_thread.start()

            start_fps_time : float = time()
            end_fps_time : float = start_fps_time
            image_processor_builder_service : ImageProcessorBuilderService = ImageProcessorBuilderService()
            pipe_detector_builder_service : PipeDetectorBuilderService = PipeDetectorBuilderService()

            producer : KafkaProducer = KafkaProducer(
                bootstrap_servers=BOOTSTRAP_SERVERS,
            )

            while success:
                end_fps_time = time()
                frame, detected_classes, cup_detected, _, classes_coordinates = cup_detection_model(frame=frame)
                
                desired_cup_size_detected.set_state( \
                    customer_selected_cup_size=cup_size, \
                    detected_cup_sizes=detected_classes \
                )

                frame : np.ndarray = image_processor_builder_service \
                    .add_text_number_of_frames(frame=frame, start_time=start_fps_time, end_time=end_fps_time) \
                    .build()
                
                roi_frame : Optional[np.ndarray] = None
                if len(classes_coordinates) == 1:
                    detected_pipe, frame, roi_frame, ignore_frame = pipe_detector_builder_service \
                        .create_roi_subwindow(frame=frame, classes_coordinates=classes_coordinates) \
                        .find_white_pipe(draw=True) \
                        .collect()
                    
                    if ignore_frame:
                        continue

                    if detected_pipe is None or frame is None or roi_frame is None:
                        raise MethodNotPassedToBuilderException()

                    pipe_detected.set_state(detected_pipe)

                    if roi_frame is not None:
                        roi_w, roi_h, roi_c = roi_frame.shape
                        if roi_w == 0 or roi_h == 0 or roi_c == 0:
                            continue

                if roi_frame is not None:
                    cv2.imshow(WINDOW_NAME_PIPE_DETECTION, roi_frame)
                else:
                    if int(cv2.getWindowProperty(WINDOW_NAME_PIPE_DETECTION, cv2.WND_PROP_VISIBLE)) > 0:
                        cv2.destroyWindow(WINDOW_NAME_PIPE_DETECTION)
                
                _, encoded_frame = cv2.imencode(".jpg", frame)
                image_bytes : bytes = encoded_frame.tobytes()

                producer.send(topic=TOPIC_NAME, value=image_bytes)
                producer.flush()

                start_fps_time = end_fps_time
                
                cv2.imshow(WINDOW_NAME_CUP_DETECTION, frame)
                cv2.waitKey(1)
                
                success, frame = camera.read()
                if drink_finished.get_state():
                    drink_finished.set_state(False)
                    break

            camera.release()
            main_thread_terminated_event.set()
            background_create_coffee_drink_thread.join()
            main_thread_terminated_event.clear()
            if len(drinks_information_consumer.drinks_information) <= 0:
               cv2.destroyAllWindows() 