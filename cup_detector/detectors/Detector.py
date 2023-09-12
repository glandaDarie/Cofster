from abc import ABC, abstractclassmethod
from typing import YOLO, Tuple, np

class Detector(ABC):
    @abstractclassmethod
    def detect_cup(frame : np.ndarray = None, model : YOLO = None, path : str = None) -> YOLO | Tuple[YOLO, np.ndarray, bool]:
        pass

    @abstractclassmethod
    def detect_cup_placement(frame : np.ndarray = None, model : YOLO = None, path : str = None) -> YOLO | Tuple[YOLO, np.ndarray, bool]:
        pass