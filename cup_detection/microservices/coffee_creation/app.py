import uvicorn
from fastapi import (
    FastAPI,
)
from controllers.coffee_controller import CoffeeController
from services.coffee_service import CoffeeService 
from routes.coffee_router import router as coffee_router

app : FastAPI = FastAPI()

app.include_router(coffee_router, prefix="/coffee")
app.dependency_overrides[CoffeeController] = lambda: CoffeeController(CoffeeService()) 

if __name__ == "__main__":
    uvicorn.run(app, host="192.168.0.192", port=5000)