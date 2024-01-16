from typing import Callable, Any
import argparse
import sys
from utils.helpers import parse_key_value_args

def key_value(func: Callable[..., argparse.Namespace]) -> Callable[..., argparse.Namespace]:
    """
    Decorator to parse key-value arguments and merge them with existing arguments.

    Args:
    - func (Callable[..., argparse.Namespace]): Function that returns parsed arguments.

    Returns:
    - Callable[..., argparse.Namespace]: Decorated function that merges key-value arguments.
    """
    def wrapper(*args: Any, **kwargs: Any) -> argparse.Namespace:
        raw_args = sys.argv[1:] 
        key_value_args = parse_key_value_args(raw_args)
        args = argparse.Namespace(**key_value_args, **vars(func()))
        return args
    return wrapper
