from typing import List
import numpy as np
import cv2
from ultralytics import YOLO
from utils.constants import CAMERA_INDEX, WINDOW_NAME
from utils.paths import PATH_MODEL_CUP_DETECTION
# from utils.paths import PATH_MODEL_PLACEMENT_DETECTION
from detectors.YOLOv8 import YOLOv8Detector
from utils.firebase_rtd_url import DATABASE_OPTIONS
from messaging.drinkInformationConsumer import DrinkInformationConsumer
from threading import Thread
from threading import Lock
from utils.logger import LOGGER
from utils.constants import TABLE_NAME
from services.drinkCreationService import DrinkCreationSevice
from services.imageProcessorService import ImageProcessorBuilderService
from time import time

if __name__ == "__main__":
    drinks_information_consumer : DrinkInformationConsumer = DrinkInformationConsumer(table_name=TABLE_NAME, options=DATABASE_OPTIONS)
    background_firebase_table_update_thread : Thread = Thread(target=drinks_information_consumer.listen_for_updates_on_drink_message_broker)
    background_firebase_table_update_thread.daemon = True
    background_firebase_table_update_thread.start()
    while True:
        if len(drinks_information_consumer.drinks_information) > 0:
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
                                                                    args=(drinks_information_consumer, callback_cup_detection))
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


               
