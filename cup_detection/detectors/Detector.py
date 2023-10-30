from typing import Tuple, List
import numpy as np
from abc import ABC, abstractmethod
from ultralytics import YOLO, yolo
import torch

class Detector(ABC):
    @staticmethod
    @abstractmethod
    def detect(frame : np.ndarray = None, model : YOLO = None, path : str = None) -> YOLO | Tuple[YOLO, np.ndarray, bool, \
                                                                                                  List[yolo.engine.results.Boxes]]:
        pass

    @staticmethod
    @abstractmethod
    def is_cup_in_correct_position(cup_coordinates : torch.Tensor, box_coordinates : torch.Tensor, tolerance : int) -> bool:
        pass