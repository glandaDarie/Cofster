from typing import List, Tuple
import numpy as np
from ultralytics import yolo
from ultralytics import YOLO
from ultralytics.yolo.utils.plotting import Annotator 
import torch
from utils.constants import THRESHOLD_SCORE
from detectors.Detector import Detector

class YOLOv8Detector(Detector):
    def __init__(self):
        pass

    @staticmethod
    def detect(frame : np.ndarray = None, model : YOLO = None, path_weights : str = None) -> YOLO | Tuple[YOLO, np.ndarray, bool, \
                                                                                                    List[yolo.engine.results.Boxes]]:
        if model is None:
            model : YOLO = YOLO(path_weights)
            return model
        has_bounding_box : bool = False
        results : List[yolo.engine.results.Results] = model.predict(frame)
        boxes : List[yolo.engine.results.Boxes] | None = None
        for r in results:
            annotator : Annotator = Annotator(frame)
            boxes = r.boxes
            for box in boxes:
                box_coordinates : torch.Tensor = box.xyxy[0]
                classes_index : int = int(box.cls)
                score : float = float(box.conf)
                if score > THRESHOLD_SCORE:
                    has_bounding_box : bool = True
                    annotator.box_label(box_coordinates, f"{model.names[classes_index]}:{score:.2f}")
        return (model, annotator.result(), has_bounding_box, boxes) if has_bounding_box else (model, frame, has_bounding_box, boxes)    

    @staticmethod
    def is_cup_in_correct_position(object1_boxes : List[yolo.engine.results.Boxes], object2_boxes : List[yolo.engine.results.Boxes], tolerance: int = 0) -> bool:
        assert len(object1_boxes) == 1, "There are multiple bounding boxes for object 1"
        assert len(object2_boxes) == 1, "There are multiple bounding boxes for object 2"
        object1_box : yolo.engine.results.Boxes = object1_boxes[-1]
        object2_box : yolo.engine.results.Boxes = object2_boxes[-1]
        object1_coordinates : torch.Tensor = object1_box.xyxy[0]
        object2_coordinates : torch.Tensor = object2_box.xyxy[0]
        object1_x, object1_y, object1_width, object1_height = object1_coordinates
        object2_x, object2_y, object2_width, object2_height = object2_coordinates
        if (object1_x + object1_width + tolerance >= object2_x and
            object2_x + object2_width + tolerance >= object1_x and
            object1_y + object1_height + tolerance >= object2_y and
            object2_y + object2_height + tolerance >= object1_y):
            return True
        return False
    