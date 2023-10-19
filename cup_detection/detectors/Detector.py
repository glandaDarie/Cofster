from typing import Tuple
import numpy as np
from abc import ABC, abstractmethod
from ultralytics import YOLO

class Detector(ABC):
    @staticmethod
    @abstractmethod
    def detect_cup(frame : np.ndarray = None, model : YOLO = None, path : str = None) -> YOLO | Tuple[YOLO, np.ndarray, bool]:
        pass
    
    @staticmethod
    @abstractmethod
    def detect_cup_placement(frame : np.ndarray = None, model : YOLO = None, path : str = None) -> YOLO | Tuple[YOLO, np.ndarray, bool]:
        pass