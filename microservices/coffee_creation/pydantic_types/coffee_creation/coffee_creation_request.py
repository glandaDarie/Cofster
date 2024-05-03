from typing import Dict, Any
from pydantic import BaseModel

class Request(BaseModel):
    payload : Dict[str, Any]