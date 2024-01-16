from typing import Dict, Any

def parse_key_value_args(args : Any) -> Dict[str, Any]:
    """
    Parses key-value arguments.

    Args:
    - args (List[str]): List of string arguments in key=value format.

    Returns:
    - Dict[str, Any]: A dictionary containing parsed key-value pairs.
    """
    parsed_args : Dict[str, Any] = {}
    for arg in args:
        key, value = arg.split('=')
        parsed_args[key] : str = value
    return parsed_args