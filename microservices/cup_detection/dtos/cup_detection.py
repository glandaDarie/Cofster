from attr import define

import sys

sys.path.append("../")

from detectors.Detector import Detector

@define
class DetectorDTO:
    model_name : str
    detector : Detector