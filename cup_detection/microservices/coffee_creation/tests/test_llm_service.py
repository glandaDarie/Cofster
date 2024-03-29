from typing import Dict, Any
import sys
sys.path.append("../")

from services.recipe_service.recipe_llm_service import RecipeLlmService        

if __name__ == "__main__":
    recipe_llm_service : RecipeLlmService = RecipeLlmService()

    container_service_ip : str = "127.0.0.1"
    container_service_port : str = "8030"

    mock_params : Dict[str, Any] = {
        "coffee_name" : "cortado",
        "customer_name": "cristiano"
    }
    recipe_llm_service_response : Dict[str, Any] = recipe_llm_service.get_recipe(
        base_url=f"http://{container_service_ip}:{container_service_port}", \
        endpoint="/coffee_recipe", \
        **mock_params
    )
    print(f"recipe_llm_service_response: {recipe_llm_service_response}")