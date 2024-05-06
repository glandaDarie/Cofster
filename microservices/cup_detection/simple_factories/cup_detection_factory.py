import torch
import sys

sys.path.append("../")

from detectors.YOLO import YOLODetector
from detectors.Detector import Detector
from enums.cup_detection_model import CupDetectionModel
from utils.paths import PATH_MODEL_CUP_DETECTION_YOLOV8
from utils.paths import PATH_MODEL_CUP_DETECTION_YOLOV9
from utils.exceptions import NoSuchCupDetector

class CupDetectionFactory:
    def create(cup_detection_model : CupDetectionModel) -> Detector:
        if cup_detection_model == CupDetectionModel.YOLOV8:
            path_weights : str = PATH_MODEL_CUP_DETECTION_YOLOV8
        elif cup_detection_model == CupDetectionModel.YOLOV9:
            path_weights : str = PATH_MODEL_CUP_DETECTION_YOLOV9
        else:
            raise NoSuchCupDetector()
        
        return YOLODetector(path_weights=path_weights, device=torch.device("cuda"))
