from typing import Dict
import json
import cv2
from flask import Flask
from ultralytics import YOLO
from utils.model_data import CAMERA_INDEX, WINDOW_NAME
from utils.paths import PATH_MODEL_CUP_DETECTION, PATH_MODEL_TARGET_DETECTION
from detectors import Detectors
from message_broker.producer import kafka_producer
from message_broker.consumer import kafka_consumer 
import threading

app : object = Flask(__name__)

@app.route("/cup_detection", methods=["GET"])
def environment() -> json:
    camera : object = cv2.VideoCapture(CAMERA_INDEX) 
    if not camera.isOpened():
        return json.dumps(
            {
                "statusCode": 500,
                "body": "Failed to open the Raspberry Pi Camera" 
            }
        )
    success, frame = camera.read()
    if not success or frame is None:
        return json.dumps(
            {
                "statusCode": 500,
                "body": "Failed to read the frame from OpenCV Camera"
            }
        ) 
    frame_number : int = 1
    print(f"PATH_MODEL_CUP_DETECTION: {PATH_MODEL_CUP_DETECTION}")
    cup_detection_model : YOLO = Detectors().detector(path=PATH_MODEL_CUP_DETECTION)
    # target_detection_model : YOLO = Detectors.detector(path=PATH_MODEL_TARGET_DETECTION)
    
    # test if the consumer subscribed to the topic recieves messages back
    consumer_thread : threading.Thread = threading.Thread(target=kafka_consumer)
    consumer_thread.start()
    while success:
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        cup_detection_model, frame, has_bounding_box = Detectors().detector(frame=frame, model=cup_detection_model) 
        # target_detection_model, frame = Detectors().detector(frame=frame, model=target_detection_model) 
        frame_data : str = "Bounding box for cup present" if has_bounding_box else "Bounding box for cup isn't present"
        kafka_body : Dict[str, str] = {
            "frame_data": frame_data,
            "frame_number": str(frame_number)
        }
        kafka_producer(body=kafka_body, topic="cup-detector", bootstrap_servers="localhost:9092")
        cv2.imshow(WINDOW_NAME, frame)
        success, frame = camera.read()
        frame_number += 1
    camera.release()
    cv2.destroyAllWindows()
    return json.dumps(
        {
            "statusCode": 200,
            "body": "Successfully returned the state of the cup"
        }
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)

