from typing import List, Tuple
import numpy as np
import ultralytics
from ultralytics import YOLO
from ultralytics.yolo.utils.plotting import Annotator 
import torch
from utils.model_data import THRESHOLD_SCORE

class YOLOv8_detector:
    def __init__(self):
        pass

    @staticmethod
    def detect_cup(frame : np.ndarray = None, model : YOLO = None, path : str = None) -> YOLO | Tuple[YOLO, np.ndarray, bool]:
        if model is None:
            model : YOLO = YOLO(path)
            return model
        has_bounding_box : bool = False
        results : List[ultralytics.yolo.engine.results.Results] = model.predict(frame)
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
        return (model, annotator.result(), has_bounding_box) if has_bounding_box else (model, frame, has_bounding_box)
    
    @staticmethod
    def detect_cup_placement(frame : np.ndarray = None, model : YOLO = None, path : str = None) -> YOLO | Tuple[YOLO, np.ndarray, bool]:
        pass