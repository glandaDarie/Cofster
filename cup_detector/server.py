from typing import Dict
from flask import Flask
import cv2
import json
from utils import window_name

app : object = Flask(__name__)

@app.route('/cup_detection', methods=['GET'])
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
    while success or frame is not None:
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
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


