from fastapi import (
    APIRouter,
    Request,
    status,
    Depends
)

router : APIRouter = APIRouter()

from controllers.coffee_controller import CoffeeController
from pydantic_types.coffee_creation.coffee_creation_response import Response

@router.post("/create", status_code=status.HTTP_201_CREATED, response_model=None)
async def create_coffee(request : Request, coffee_controller : CoffeeController = Depends()) -> Response:
    return await coffee_controller.create_coffee(request=request)