from typing import Dict, Any
import sys

sys.path.append("../")

from controllers.coffee_creation_controller import CoffeeCreationController
from services.coffee_creation_service import CoffeeCreationService

class CoffeeCreationFacadeService:
    @staticmethod
    def create(payload : Dict[str, Any]) -> str:
        coffee_creation_service_response : str = CoffeeCreationController(CoffeeCreationService()) \
            .create_coffee(
                base_url="http://192.168.0.192:5000/coffee", 
                endpoint="/create", 
                payload=payload
        )
        return coffee_creation_service_response