from typing import List

CAMERA_INDEX : int = 1 # set camera for coffee machine, the one connected to my pc as of now (new iteration should be a surveillance camera)
WINDOW_NAME_CUP_DETECTION : str = "Detect cup"
WINDOW_NAME_PIPE_DETECTION : str = "Detect pipe"
TABLE_NAME : str = "Orders"
THRESHOLD_SCORE : float = 0.5
PROMPT_TEMPLATE : str = "Given the coffee drink that I provided: {}, please generate a JSON with the ingredients necessary to make that respective drink."

CUP_DETECTION_DURATION_SECONDS : int = 10

AVERGE_CUP_HEIGHT : int = 197
CUP_ERROR_TOLERANCE_PERCENTAGE : int = 15
THRESHOLD_SMALL_CUP_HEIGHT : int = 140
THRESHOLD_MEDIUM_CUP_HEIGHT : int = 185
THRESHOLD_BIG_CUP_HEIGHT : int = 275
UNKNOWN_CLASS : str = "Unknown"

Y_COORD_OFFSET : int = 200
H_COORD_OFFSET : int = Y_COORD_OFFSET - 50
W_COORD_OFFSET : int = 325
MIN_AREA_PIPE : int = 1000
MIN_ASPECT_RATION_PIPE : int = 0.1
THRESHOLD_MEAN_WHITE : int = 170
COORDINATE_NAMES : List[str] = ["x", "y", "w", "h"]