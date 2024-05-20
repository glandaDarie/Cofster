import torch
import sys

sys.path.append("../")

from detectors.YOLO import YOLODetector
from dtos.cup_detection import DetectorDTO
from enums.cup_detection_model import CupDetectionModelType
from utils.paths import PATH_MODEL_CUP_DETECTION_YOLOV8
from utils.paths import PATH_MODEL_CUP_DETECTION_YOLOV9
from utils.exceptions import NoSuchCupDetector

class CupDetectionFactory:
    @staticmethod
    def create(cup_detection_model : CupDetectionModelType) -> DetectorDTO:
        """
        Factory method to create a cup detector based on the model type.
        
        Args:
            cup_detection_model (CupDetectionModelType): The type of cup detection model to use.
        
        Returns:
            DetectorDTO: A data transfer object containing the model name and the detector instance.
        
        Raises:
            NoSuchCupDetector: If the provided model type is not supported.
        """
        if cup_detection_model == CupDetectionModelType.YOLOV8:
            path_weights : str = PATH_MODEL_CUP_DETECTION_YOLOV8
            model_name : str = CupDetectionModelType.YOLOV8.value
        elif cup_detection_model == CupDetectionModelType.YOLOV9:
            path_weights : str = PATH_MODEL_CUP_DETECTION_YOLOV9
            model_name : str = CupDetectionModelType.YOLOV9.value
        else:
            raise NoSuchCupDetector()
        
        return DetectorDTO(model_name=model_name, detector=YOLODetector(path_weights=path_weights, device=torch.device("cuda")))
