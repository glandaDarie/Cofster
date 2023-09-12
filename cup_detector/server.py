from typing import List, Dict, Callable
import cv2
from ultralytics import YOLO
from utils.constants import CAMERA_INDEX, WINDOW_NAME
from utils.paths import PATH_MODEL_CUP_DETECTION
from detectors.YOLOv8 import YOLOv8Detector
from utils.firebase_rtd_url import DATABASE_OPTIONS
from message_broker.drinks_information_consumer import DrinksInformationConsumer
from threading import Thread, Lock
from utils.logger import LOGGER
from utils.constants import TABLE_NAME
from services.DrinkCreationService import DrinkCreationSevice
# from utils.paths import PATH_MODEL_PLACEMENT_DETECTION

if __name__ == "__main__":
    drinks_information_consumer : DrinksInformationConsumer = DrinksInformationConsumer(table_name=TABLE_NAME, options=DATABASE_OPTIONS)
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

            cup_detection_model : YOLO = YOLOv8Detector.detect_cup(path=PATH_MODEL_CUP_DETECTION)
            # cup_detection_placement_model : YOLO = YOLOv8_detector.detect_cup_placement(path=PATH_MODEL_PLACEMENT_DETECTION)

            cup_detection_lock : Lock = Lock()
            cup_detection_state : List[bool] = [False]

            def callback_cup_detection(new_cup_detection_state : bool|None = None):
                with cup_detection_lock:
                    if new_cup_detection_state is not None:
                        cup_detection_state[0] = new_cup_detection_state
                    return cup_detection_state[0]

            background_create_coffee_drink_thread : Thread = Thread(target=DrinkCreationSevice.create_drink, \
                                                                    args=(drinks_information_consumer.drinks_information, callback_cup_detection))
            background_create_coffee_drink_thread.daemon = True
            background_create_coffee_drink_thread.start()

            while success:
                cup_detection_model, frame, cup_detected = YOLOv8Detector.detect_cup(frame=frame, model=cup_detection_model)
                callback_cup_detection(cup_detected)
                print(f"len(consumer.drinks_information): {len(drinks_information_consumer.drinks_information)}")
                cv2.imshow(WINDOW_NAME, frame)
                cv2.waitKey(1)
                frame_captured_successfully, frame = camera.read()
            camera.release()
            cv2.destroyAllWindows()

               
