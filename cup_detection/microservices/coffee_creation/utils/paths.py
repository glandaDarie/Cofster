import os

PATH_MODEL_CUP_DETECTION : str = os.path.join(os.path.join(os.getcwd(), "weights"), "best_cup_detection.pt")
PATH_MODEL_PLACEMENT_DETECTION : str = os.path.join(os.path.join(os.getcwd(), "weights"), "best_target_detection.pt")