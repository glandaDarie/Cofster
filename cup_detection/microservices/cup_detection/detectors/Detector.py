from typing import Tuple, List
import numpy as np
from abc import ABC, abstractmethod
import torch

class Detector(ABC):
    @staticmethod
    @abstractmethod
    def detect(frame : np.ndarray = None, model : "Detector" = None, path : str = None) -> "Detector" | Tuple["Detector", np.ndarray, bool, \
                                                                                                  List["Detector"]]:
        pass

    @staticmethod
    @abstractmethod
    def is_cup_in_correct_position(cup_coordinates : torch.Tensor, box_coordinates : torch.Tensor, tolerance : int) -> bool:
        pass