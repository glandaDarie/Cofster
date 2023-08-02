from typing import Dict, List
import numpy as np
import json
import torch
import cv2
from flask import Flask
from utils.helpers import create_path
from utils.data import window_name
import ultralytics
from ultralytics import YOLO
from ultralytics.yolo.utils.plotting import Annotator 

app : object = Flask(__name__)

@app.route("/cup_detection", methods=["GET"])
def detect_cup() -> Dict[str, str]:
    camera : object = cv2.VideoCapture(0)
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
    while success or frame is not None:
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        results : List[ultralytics.yolo.engine.results.Results] = model.predict(frame)
        for r in results:
            annotator : Annotator = Annotator(frame)
            boxes : ultralytics.yolo.engine.results.Boxes = r.boxes
            for box in boxes:
                box_coordinates : torch.Tensor = box.xyxy[0]
                classes_index : int = int(box.cls)
                annotator.box_label(box_coordinates, model.names[classes_index])
        frame : np.ndarray = annotator.result()  
        cv2.imshow(window_name, frame)
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
