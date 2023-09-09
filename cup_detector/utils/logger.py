import logging


logging.basicConfig(filename="assets/error.log",
                    format="%(asctime)s %(message)s",
                    filemode="w")

LOGGER  : logging.Logger = logging.getLogger(__name__)

