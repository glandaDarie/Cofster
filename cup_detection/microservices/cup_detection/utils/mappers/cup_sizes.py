from typing import Dict
import sys

sys.path.append("../")

from enums.cup_classes import CupClasses

CUP_SIZE_MAPPER : Dict[str, str] = {
    "S" : CupClasses.SMALL.value,
    "M" : CupClasses.MEDIUM.value,
    "L" : CupClasses.BIG.value
}
