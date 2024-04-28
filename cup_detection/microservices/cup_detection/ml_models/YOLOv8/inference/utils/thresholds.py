from typing import Dict
from .enums import CupClasses
from .constants import (
    THRESHOLD_SMALL_CUP_HEIGHT,
    THRESHOLD_MEDIUM_CUP_HEIGHT,
    THRESHOLD_BIG_CUP_HEIGHT
)

thresholds : Dict[int, CupClasses] = {
    THRESHOLD_SMALL_CUP_HEIGHT : CupClasses.SMALL,
    THRESHOLD_MEDIUM_CUP_HEIGHT : CupClasses.MEDIUM,
    THRESHOLD_BIG_CUP_HEIGHT : CupClasses.BIG
}