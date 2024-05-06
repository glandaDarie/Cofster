from typing import Dict, Any, Optional
import argparse

from utils.exceptions.no_arguments_provided_exception import NoArgumentsProvidedException

class ArgumentParser:
    @staticmethod
    def parse(params : Dict[str, Any]) -> argparse.Namespace:
        """
        Returns parsed arguments related to recipe.

        Returns:
        - argparse.Namespace: Parsed arguments related to recipe.
        """
        parser : argparse.ArgumentParser = argparse.ArgumentParser(prog=params.get("prog", ""), description=params.get("desciption", ""))
        arguments : Optional[Dict[str, Any]] = params.get("arguments", None)
        if arguments is not None:
            for argument in arguments:
                parser.add_argument(argument.get("name"), action=argument.get("action", "store_false"), help=argument.get("help", ""))
        else:
            raise NoArgumentsProvidedException()
        return parser.parse_args()