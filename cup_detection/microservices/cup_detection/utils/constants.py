CAMERA_INDEX : int = 0 # should be changed with the new surveillance camera that will be set to the coffee machine
WINDOW_NAME : str = "Detect cup"
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
