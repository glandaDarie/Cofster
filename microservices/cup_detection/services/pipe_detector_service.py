from typing import List, Tuple, Dict, Optional, Self
import cv2
import numpy as np
import sys

sys.path.append("../")

from utils.constants import (
    Y_COORD_OFFSET,
    W_COORD_OFFSET,
    H_COORD_OFFSET,
    MIN_AREA_PIPE,
    MIN_ASPECT_RATION_PIPE,
    THRESHOLD_WHITE_PIXELS,
    THRESHOLD_MEAN_WHITE,
    COORDINATE_NAMES
) 

class PipeDetectorBuilderService:
    def __init__(self):
        self.__frame : Optional[np.ndarray] = None
        self.__roi_frame : Optional[np.ndarray] = None
        self.__contours : Optional[np.ndarray] = None
        self.__white_pipe_found : Optional[bool] = None
        self.__ingore_frame : Optional[bool] = None

    def create_roi_subwindow(self, frame : np.ndarray, classes_coordinates : List[float]) -> Self:
        roi_subwindow : Dict[str, int] = {}

        COORDINATE_OFFSETS = {"y": Y_COORD_OFFSET, "w": W_COORD_OFFSET, "h": H_COORD_OFFSET}
        for class_coordinates in classes_coordinates:
            for class_coordinate, coordinate_name in zip(class_coordinates, COORDINATE_NAMES):
                offset : int = COORDINATE_OFFSETS.get(coordinate_name, 0)
                roi_subwindow[coordinate_name] = max(0, round(class_coordinate) - offset) 
        
        self.__frame : np.ndarray = frame.copy()
        self.__roi_frame = self.__frame[
            roi_subwindow.get("y", 0):roi_subwindow.get("y", 0)+roi_subwindow.get("h", 0), 
            roi_subwindow.get("x", 0):roi_subwindow.get("x", 0)+roi_subwindow.get("w", 0)
        ].copy()
        return self
    
    def find_white_pipe(self, draw : bool = False) -> Self:
        roi_w, roi_h, _ = self.__roi_frame.shape
        if roi_w == 0 or roi_h == 0:
            self.__ingore_frame = True
            return self
        
        gray_roi : np.ndarray = cv2.cvtColor(self.__roi_frame, cv2.COLOR_BGR2GRAY)

        _, binary_roi = cv2.threshold(gray_roi, THRESHOLD_WHITE_PIXELS, 255, cv2.THRESH_BINARY)
        kernel : np.ndarray = np.ones((3, 3), np.uint8)  
        binary_roi : np.ndarray = cv2.dilate(binary_roi, kernel, iterations=1)

        self.__contours, _ = cv2.findContours(binary_roi, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        self.__ingore_frame = False
        for contour in self.__contours:
            area : float = cv2.contourArea(contour)
            x, y, w, h = cv2.boundingRect(contour)
            aspect_ratio : float = float(w) / h
            if area > MIN_AREA_PIPE and aspect_ratio >= MIN_ASPECT_RATION_PIPE:
                roi_color : np.ndarray = self.__roi_frame[y:y+h, x:x+w]
                mean_color : np.float64 = np.mean(roi_color, axis=(0, 1))
                if np.any(mean_color > THRESHOLD_MEAN_WHITE):
                    if draw:
                        self.__roi_frame = cv2.rectangle(self.__roi_frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
                    self.__white_pipe_found = True
                    return self
        self.__white_pipe_found = False
        return self

    def collect(self) -> Tuple[bool, np.ndarray]:
        if self.__frame is not None:
            return self.__white_pipe_found, self.__frame, self.__roi_frame, self.__ingore_frame
        return None, None, None, True