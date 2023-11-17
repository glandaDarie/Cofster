import logging
import os
from typing import Dict
import concurrent.futures
from utils.paths import PATH_THREAD_INFORMATION_LOGGER
from utils.paths import PATH_ROOT

PATH_FILENAME : str = os.path.join(PATH_ROOT, "assets", "logging_information.log") 

logging.basicConfig(filename=PATH_FILENAME,
                    format="%(asctime)s %(message)s",
                    filemode="w",
                    level=logging.DEBUG)

LOGGER : logging.Logger = logging.getLogger(__name__)

def thread_information_logger(futures : Dict[concurrent.futures.ThreadPoolExecutor, str]):
    with open(PATH_THREAD_INFORMATION_LOGGER, "w") as file:
        for future_object, future_name in futures.items():
            file.write(f"Thread with name {future_name} is still running? {future_object.running()}\n")