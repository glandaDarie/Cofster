from typing import Dict, Any
from json.decoder import JSONDecodeError
from fastapi import (
    Request,
    HTTPException,
    status
)
import sys

sys.path.append("../")

from pydantic_types.coffee_creation.coffee_service_type import CoffeeServiceType
from pydantic_types.coffee_creation.coffee_creation_response import Response

class CoffeeController:
    def __init__(self, coffee_service : CoffeeServiceType):
        self.coffee_service : CoffeeServiceType = coffee_service
    
    async def create_coffee(self, request : Request) -> Response: 
        try:
            body: Dict[str, Any] = await request.json()
        except JSONDecodeError as error:
            return HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"Invalid JSON payload. Error: {error}")
        
        if body is None:
            return HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Client did not pass payload")
        
        coffee_service_response : Response = self.coffee_service.create_coffee(body=body)
        
        if not "success" in coffee_service_response.message:
            return HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to create coffee")
        return coffee_service_response