import os

PATH_MODEL_CUP_DETECTION_YOLOV8 : str = os.path.join(os.path.join(os.getcwd(), "weights"), "cup_detection_params_yolov8.pt")
PATH_MODEL_CUP_DETECTION_YOLOV9 : str = os.path.join(os.path.join(os.getcwd(), "weights"), "cup_detection_params_yolov9.pt")
PATH_MODEL_PLACEMENT_DETECTION : str = os.path.join(os.path.join(os.getcwd(), "weights"), "target_detection_params.pt")
PATH_THREAD_INFORMATION_LOGGER : str = os.path.join(os.getcwd(), "assets", "thread_termination_info.log")
PATH_COFFEE_CREATION : str = os.path.join(os.path.dirname(os.getcwd()), "assets", "coffee_creation_data.txt")
PATH_FILENAME : str = os.path.join(os.getcwd(), "assets", "logging_information.log") 
PATH_FPS_RESULTS : str = os.path.join(os.path.join(os.getcwd(), "assets"), "fps_results.txt")