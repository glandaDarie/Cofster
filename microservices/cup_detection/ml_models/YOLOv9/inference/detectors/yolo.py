from typing import List, Tuple, Dict
import numpy as np
from ultralytics import YOLO
from ultralytics.utils.plotting import Annotator
from ultralytics.engine.results import Boxes, Results
import torch

from inference.utils.constants import (
    THRESHOLD_SCORE, 
    AVERGE_CUP_HEIGHT, 
    CUP_ERROR_TOLERANCE_PERCENTAGE,
    UNKNOWN_CLASS
)
from inference.utils.thresholds import thresholds
from inference.utils.enums import CupClasses
from inference.detectors.Detector import Detector

class YOLOv8Detector(Detector):
    def __init__(self, path_weights : str, device : torch.device = torch.device("cuda")):
        """
        Initialize the YOLOv8Detector.

        Args:
            path_weights (str): Path to the weights of the YOLO model.
            device (torch.device, optional): Device to use for inference. Defaults to torch.device("cuda").
        """
        self.model : YOLO = YOLO(path_weights)
        self.model.to(device=device)

    def __call__(self, frame : np.ndarray) -> YOLO | Tuple[YOLO, List[np.ndarray], bool, List[Boxes]]:
        """
        Call the YOLOv8Detector instance to detect objects in a frame.

        Args:
            frame (np.ndarray): Input frame.

        Returns:
            Tuple[np.ndarray, List[str], bool, List[Boxes], List[float]]: Annotated frame, detected classes, boolean indicating if bounding box 
            is present, list of bounding boxes, list of box coordinates.
        """
        return self.detect(frame=frame)

    def detect(self, frame : np.ndarray) -> YOLO | Tuple[YOLO, List[np.ndarray], bool, List[Boxes]]:
        """
        Detect objects in a frame using YOLOv8 model.

        Args:
            frame (np.ndarray): Input frame.

        Returns:
            Tuple[np.ndarray, bool, List[Boxes], List[float]]: Annotated frame, boolean indicating if bounding box 
            is present, list of bounding boxes, list of box coordinates.
        """
        has_bounding_box : bool = False
        boxes : List[Boxes] | None = None
        boxes_coordinates : List[float] = []
        detected_classes : List[str] = []

        results : List[Results] = self.model.predict(frame)
        for result in results:
            annotator : Annotator = Annotator(frame)
            bounding_boxes : Boxes = result.boxes
            for bounding_box in bounding_boxes:
                box_coordinates : torch.Tensor = bounding_box.xyxy[0].detach().tolist()
                score : float = float(bounding_box.conf)
                if score > THRESHOLD_SCORE:
                    cup_height : float = self.get_cup_height(y_start=box_coordinates[1], y_end=box_coordinates[3])
                    detected_class : str = self.get_cup_class_name(cup_height=cup_height, thresholds=thresholds)
                    if detected_class == UNKNOWN_CLASS:
                        continue
                    detected_classes.append(detected_class)
                    has_bounding_box : bool = True
                    boxes_coordinates.append(box_coordinates)
                    annotator.box_label(box_coordinates, f"{detected_class}:{score:.2f}")
        
        return annotator.result() if has_bounding_box else frame, detected_classes, has_bounding_box, boxes, boxes_coordinates     
    
    def get_cup_class_name(self, cup_height : float, thresholds : Dict[int, CupClasses]) -> str:
        """
        Get the cup class name based on the cup height.

        Args:
            cup_height (float): Height of the cup.
            thresholds (Dict[int, CupClasses]): Thresholds mapping to cup classes.

        Returns:
            str: Cup class name.
        """
        low_bound_error : float = cup_height - (CUP_ERROR_TOLERANCE_PERCENTAGE / 100) * cup_height
        high_bound_error : float = cup_height + (CUP_ERROR_TOLERANCE_PERCENTAGE / 100) * cup_height

        for threshold, cup_class in thresholds.items():
             if low_bound_error <= threshold <= high_bound_error:
                return cup_class.value
             
        return UNKNOWN_CLASS

    def get_cup_height(self, y_start : int, y_end : int) -> float:
        """
        Calculate cup height based on bounding box coordinates.

        Args:
            y_start (int): Y-coordinate of the top-left corner of the bounding box.
            y_end (int): Y-coordinate of the bottom-right corner of the bounding box.

        Returns:
            float: Calculated cup height.
        """
        return (y_start - y_end)**2 / AVERGE_CUP_HEIGHT

    def is_cup_in_correct_position(self, object1_boxes : List[Boxes], object2_boxes : List[Boxes], tolerance: int = 0) -> bool:
        """
        Check if two objects are in correct position relative to each other.

        Args:
            object1_boxes (List[Boxes]): List of bounding boxes for object 1.
            object2_boxes (List[Boxes]): List of bounding boxes for object 2.
            tolerance (int, optional): Tolerance to allow slight deviations in positions. Defaults to 0.

        Returns:
            bool: True if objects are in correct position, False otherwise.
            
        Raises:
            AssertionError: If there are multiple bounding boxes for either object 1 or object 2.
        """
        assert len(object1_boxes) == 1, "There are multiple bounding boxes for object 1"
        assert len(object2_boxes) == 1, "There are multiple bounding boxes for object 2"
        
        object1_box : Boxes = object1_boxes[-1]
        object2_box : Boxes = object2_boxes[-1]
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