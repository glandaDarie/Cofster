from typing import Tuple, List, Dict
from abc import ABC, abstractmethod
import numpy as np
from ultralytics.engine.results import Boxes

from inference.utils.enums import CupClasses

class Detector(ABC):
    @abstractmethod
    def detect(self, frame : np.ndarray) -> Tuple[np.ndarray, List[str], bool, List[Boxes], List[float]]:
        pass

    @abstractmethod
    def get_cup_class_name(self, cup_height : float, thresholds : Dict[int, CupClasses]) -> str:
        pass

    @abstractmethod
    def get_cup_height(self, y_start : int, y_end : int) -> float:
        pass

    @abstractmethod
    def is_cup_in_correct_position(self, object1_boxes : List[Boxes], object2_boxes : List[Boxes], tolerance : int = 0) -> bool:
        pass