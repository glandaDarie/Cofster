from typing import Dict, Optional
import json
import cv2
from flask import Flask
from ultralytics import YOLO
from utils.model_data import CAMERA_INDEX, WINDOW_NAME
from utils.paths import PATH_MODEL_CUP_DETECTION, PATH_MODEL_PLACEMENT_DETECTION
from detectors import YOLOv8_detector
from utils.firebase_rtd_url import DATABASE_OPTIONS
from message_broker.drink_information_consumer import Drinks_information_consumer
from threading import Thread
from utils.logger import LOGGER

def create_coffee_drink(drink_information : Dict[str, str]) -> str:
    print(drink_information)

if __name__ == "__main__":
    consumer : Drinks_information_consumer = Drinks_information_consumer(table_name="Orders", options=DATABASE_OPTIONS)
    background_firebase_table_update_thread : Thread = Thread(target=consumer.listen_for_updates_on_drink_message_broker)
    background_firebase_table_update_thread.daemon = True
    background_firebase_table_update_thread.start()
    while True:
        with consumer.data_lock:
            if len(consumer.drinks_information) > 0:
                camera : object = cv2.VideoCapture(CAMERA_INDEX) 
                if not camera.isOpened():
                    LOGGER.error("Error when trying to open the camera")
                    break
                success, frame = camera.read()
                if not success or frame is None:
                    LOGGER.error(f"Error when trying to read the frame: {frame}")
                    break
                cup_detection_model : YOLO = YOLOv8_detector.detect_cup(path=PATH_MODEL_CUP_DETECTION)
                # cup_detection_placement_model : YOLO = YOLOv8_detector.detect_cup_placement(path=PATH_MODEL_PLACEMENT_DETECTION)
                drink_creation_in_progress : bool = False
                while success:
                    if cv2.waitKey(1) & 0xFF == ord('q'):
                        break
                    cup_detection_model, frame, cup_detected = YOLOv8_detector.detect_cup(frame=frame, model=cup_detection_model)
                    # cup_detection_placement_model, frame, cup_placed_in_correct_position = YOLOv8_detector.detect_cup(frame=frame, model=cup_detection_model)
                    
                    # if cup_detected and cup_placed_in_correct_position: # while instead of if because we want the brewing to stop if it isn't alright
                    #     drink_information : Optional[Dict[str, str]] = None
                    #     while cup_detected and cup_placed_in_correct_position
                                        
                    # print(f"Drinks information length: {len(consumer.drinks_information)}")
                    # if cup_detected:
                    #     drink_information : Dict[str, str] = consumer.drinks_information.pop(0)

                    if cup_detected:
                        if drink_creation_in_progress is False:
                            drink_information : Optional[Dict[str, str]] = None
                            background_create_coffee_thread : Thread = Thread(target=create_coffee_drink, args=(drink_information))
                            background_create_coffee_thread.daemon = True
                            background_create_coffee_thread.start()
                            drink_creation_in_progress = not drink_creation_in_progress

                        while cup_detected:
                            if drink_information is None:
                                drink_information = consumer.drinks_information.pop(0)
                            # make coffee
                        # stop making the drink because some error appeard (the cup is moved from the initial position where the coffee was okay to start)
                        # if cup is again moved okay resume the coffee making (should create a function that creates that coffee drink)

                    cv2.imshow(WINDOW_NAME, frame)
                    success, frame = camera.read()
                camera.release()
                cv2.destroyAllWindows()

               
