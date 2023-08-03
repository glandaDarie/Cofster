from typing import Dict, List
import json
import torch
import cv2
import numpy as np
from flask import Flask
import ultralytics
from ultralytics import YOLO
from ultralytics.yolo.utils.plotting import Annotator 
from utils.helpers import create_path
from utils.model_data import CAMERA_INDEX, WINDOW_NAME, THRESHOLD_SCORE

app : object = Flask(__name__)

# need to change the code to work in my raspberry pi for cup detection and use instead of a http request, rabbitMQ or Kafka to send data in real time

@app.route("/cup_detection", methods=["GET"])
def detect_cup() -> Dict[str, str]:
    camera : object = cv2.VideoCapture(CAMERA_INDEX) 
    if not camera.isOpened():
        return json.dumps(
            {
                "statusCode": "500",
                "body": "Failed to open the camera" 
            }
        )
    success, frame = camera.read()
    if not success or frame is None:
        return json.dumps(
            {
                "statusCode": "500",
                "body": "Failed to read the frame from OpenCV camera"
            }
        ) 
    model : YOLO = YOLO(create_path(["C:\\", "Users", "darie", "Downloads", "best.pt"]))
    while success:
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        results : List[ultralytics.yolo.engine.results.Results] = model.predict(frame)
        has_bounding_box : bool = False
        for r in results:
            annotator : Annotator = Annotator(frame)
            boxes : ultralytics.yolo.engine.results.Boxes = r.boxes
            for box in boxes:
                box_coordinates : torch.Tensor = box.xyxy[0]
                classes_index : int = int(box.cls)
                score : float = float(box.conf)
                if score > THRESHOLD_SCORE:
                    has_bounding_box : bool = True
                    annotator.box_label(box_coordinates, f"{model.names[classes_index]}:{score:.2f}")
        if has_bounding_box:
            frame : np.ndarray = annotator.result()  
        cv2.imshow(WINDOW_NAME, frame)
        success, frame = camera.read()
    camera.release()
    cv2.destroyAllWindows()
    return json.dumps(
        {
            "statusCode": "200",
            "body": "Successfully returned the state of the cup"
        }
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
