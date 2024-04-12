from typing import Dict, Any
from abc import abstractmethod
from pydantic import BaseModel

import sys

sys.path.append("../")

from pydantic_types.coffee_creation.coffee_creation_response import Response

class CoffeeServiceType(BaseModel):
    @abstractmethod
    def create_coffee(body : Dict[str, Any]) -> Response:
        pass