import logging
import os

# PATH_FILENAME : str = os.path.join(os.path.dirname(os.getcwd()), "app", "assets", "logging_information.log") 

# without docker
PATH_FILENAME : str = os.path.join(os.getcwd(), "assets", "logging_information.log") 

logging.basicConfig(filename=PATH_FILENAME,
                    format="%(asctime)s %(message)s",
                    filemode="w",
                    level=logging.DEBUG)

LOGGER : logging.Logger = logging.getLogger(__name__)