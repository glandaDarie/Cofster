from detectors import Detector
from typing import Tuple, List
import numpy as np
import torch

class FasterRCNN(Detector):
    @staticmethod
    def detect(frame : np.ndarray = None, model : 'FasterRCNN' = None, path_weights : str = None) -> 'FasterRCNN' | Tuple['FasterRCNN', np.ndarray, bool, \
                                                                                                    List['FasterRCNN']]:
        pass

    @staticmethod
    def is_cup_in_correct_position(object1_boxes : List['FasterRCNN'], object2_boxes : List['FasterRCNN'], tolerance: int = 0) -> bool:
        assert len(object1_boxes) == 1, "There are multiple bounding boxes for object 1"
        assert len(object2_boxes) == 1, "There are multiple bounding boxes for object 2"
        object1_box = object1_boxes[-1]
        object2_box = object2_boxes[-1]
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