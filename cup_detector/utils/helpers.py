import os
from typing import List

def create_path(paths : List[str] = None) -> str:
    assert not (paths is None or len(paths) == 0), \
        "Incorrect parameters given to the path list"
    fullpath : str = paths[0]
    paths : List[str] = paths[1:]
    for path in paths:
        fullpath : str = os.path.join(fullpath, path) 
    return fullpath