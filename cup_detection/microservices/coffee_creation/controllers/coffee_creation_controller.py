from typing import Dict, Any
import sys

sys.path.append("../")

from services.coffee_creation_service import CoffeeCreationService

class CoffeeCreationController:
    """
    Controller class responsible for handling coffee creation requests.

    Args:
        coffee_creation_service (CoffeeCreationService): An instance of CoffeeCreationService for coffee creation.

    Attributes:
        coffee_creation_service (CoffeeCreationService): An instance of CoffeeCreationService for coffee creation.

    Methods:
        create_coffee: Method to create coffee using the CoffeeCreationService.
    """
    def __init__(self, coffee_creation_service : CoffeeCreationService):
        """
        Initialize the CoffeeCreationController.

        Args:
            coffee_creation_service (CoffeeCreationService): An instance of CoffeeCreationService for coffee creation.
        """
        self.coffee_creation_service : CoffeeCreationService = coffee_creation_service
    
    def create_coffee(self, 
        base_url: str, 
        endpoint: str, 
        payload : Dict[str, Any],   
        headers : Dict[str, Any] = {"Content-Type" : "application/json"}, 
        timeout : float = 7 
    ) -> str | None:
        """
        Create coffee using the CoffeeCreationService.

        Args:
            base_url (str): The base URL for the coffee creation endpoint.
            endpoint (str): The specific endpoint for coffee creation.
            payload (Dict[str, Any]): The payload data for creating coffee.

        Returns:
            str | None: A string indicating the status of coffee creation or None if successful.
        
        Raises:
            CoffeeNotCreatedError: If coffee creation fails.
        """
        response_coffee_creation : str = self.coffee_creation_service.create_coffee(
            base_url=base_url, 
            endpoint=endpoint, 
            payload=payload,
            headers=headers,
            timeout=timeout
        )
        return response_coffee_creation