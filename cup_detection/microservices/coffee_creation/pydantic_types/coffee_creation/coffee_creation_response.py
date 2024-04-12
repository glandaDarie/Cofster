from typing import Dict, Any
from pydantic import BaseModel

class Response(BaseModel):
    message : str
    information : Dict[str, Any] = {}