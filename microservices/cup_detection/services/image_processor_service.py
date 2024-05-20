from typing import Tuple, Self
import numpy as np
import cv2

class ImageProcessorBuilderService:
    def __init__(self):
        self.__frame : np.ndarray | None = None
        self.__fps : int = 0

    def add_text_number_of_frames(
        self, 
        frame : np.ndarray,
        start_time : int, 
        end_time : int,
        text : str = "Fps",
        org : Tuple[str] = (40, 40),
        fontFace : int = cv2.FONT_HERSHEY_COMPLEX,
        fontScale : float = 1.0, 
        color : tuple = (0, 255, 0), 
        thickness : int = 6
    ) -> Self:
        self.__fps : int = int(1 / (end_time - start_time)) if end_time != start_time else 0
        text : str = f"{text}: {self.__fps}"
        self.__frame = cv2.putText(img=frame, text=text, org=org, fontFace=fontFace,
                fontScale=fontScale, color=color, thickness=thickness)
        return self
    
    def build(self) -> Tuple[int, np.ndarray]:
        return self.__fps, self.__frame