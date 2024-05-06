import cv2
import torch

from inference.detectors.yolo import YOLOv8Detector
from inference.detectors.Detector import Detector
from inference.utils.paths import CUP_DETECTION_PATH
from inference.utils.constants import YOLOV8_WINDOW_NAME

def main():
    """
    Main function to capture video from the camera and perform object detection using YOLOv8.

    Opens the default camera, initializes the YOLOv8 object detection model,
    captures frames from the camera, and displays the frames with object detection results.
    """
    cap = cv2.VideoCapture(index=1)

    if not cap.isOpened():
        print("Error: Unable to open camera.")
        return

    cup_detection_model : Detector = YOLOv8Detector(path_weights=CUP_DETECTION_PATH, device=torch.device("cuda"))

    fps_counter : float = cv2.getTickFrequency()
    frame_counter : int = 0

    success : bool = True
    while success:
        success, frame = cap.read()

        frame, detected_classes, _, _, _ = cup_detection_model(frame=frame)

        if not success:
            print("Error: Unable to read frame.")
            break

        frame_counter += 1

        if cv2.getTickCount() - fps_counter >= cv2.getTickFrequency():
            fps : float = frame_counter / ((cv2.getTickCount() - fps_counter) / cv2.getTickFrequency())
            frame_counter = 0
            fps_counter = cv2.getTickCount()

        if len(detected_classes) > 0:
            cv2.putText(frame, f"Detected classes: {','.join(detected_classes)}", (10, 420), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        cv2.putText(frame, f"FPS: {int(fps)}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        
        cv2.imshow(YOLOV8_WINDOW_NAME, frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()