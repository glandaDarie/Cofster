import os

PATH_MODEL_CUP_DETECTION : str = os.path.join(os.path.join(os.getcwd(), "weights"), "best_cup_detection.pt")
PATH_MODEL_PLACEMENT_DETECTION : str = os.path.join(os.path.join(os.getcwd(), "weights"), "best_target_detection.pt")
PATH_THREAD_INFORMATION_LOGGER : str = os.path.join(os.getcwd(), "assets", "thread_termination_info.log")
PATH_COFFEE_CREATION : str = os.path.join(os.path.dirname(os.getcwd()), "assets", "coffee_creation_data.txt")