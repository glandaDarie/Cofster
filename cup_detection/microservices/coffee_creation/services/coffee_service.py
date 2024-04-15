from typing import Dict, Any
from pydantic_types.coffee_creation.coffee_creation_response import Response
from patterns.factories.coffee_creator.coffee_creator_factory import CoffeeCreatorFactory
from interfaces.coffee_creator import CoffeeCreator
from interfaces.type_coffee_creator_service import TypeCoffeeCreatorService

class CoffeeService:
    def create_coffee(self, body : Dict[str, Any]) -> Response:
        coffee_creator : CoffeeCreator = CoffeeCreatorFactory.create(coffee_type=body["coffeeName"])
        coffee_creation_message, history = coffee_creator.do(body)
        return Response(message=coffee_creation_message, information=history)