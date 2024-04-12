from typing import Dict, Any
import sys

sys.path.append("../")

from pydantic_types.coffee_creation.coffee_creation_response import Response

class CoffeeService:
    def create_coffee(self, body : Dict[str, Any]) -> Response:
        return Response(message="Coffee was created successfully!")