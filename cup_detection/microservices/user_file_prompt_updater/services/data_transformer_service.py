from typing import Dict, Any, Self

# Temporary workaround: Adding the parent directory to the sys.path
# This is necessary for relative imports to work in the current project structure.
# Please consider restructuring the project to eliminate the need for this workaround.
import sys
sys.path.append("../")

from daos.data_transformer_dao import DataTransformerDAO

class DataTransformerService:
    """
    A service for fetching and transforming data.
    """

    def __init__(self, data_transformer_dao : DataTransformerDAO):
        """
        Initializes DataTransformerDAO class and sets data to None
        """
        self.data_transformer_dao = data_transformer_dao
        self.data : dict | None = None
    
    def fetch(self, base_url : str, endpoint : str, params : Dict[str, Any] | None = None) -> Self:
        """
        Fetches data from the specified URL endpoint.

        Args:
            base_url (str): The base URL.
            endpoint (str): The endpoint to fetch data from.
            params (Dict[str, Any] | None, optional): Parameters for the request. Defaults to None.

        Returns:
            DataTransformerService: The DataTransformerService object.
        """
        self.data = self.data_transformer_dao.fetch(base_url=base_url, endpoint=endpoint, params=params)  
        return self

    def transform(self) -> Self:
        """
        Transforms data to extract users' information.

        Returns:
            DataTransformerService: The DataTransformerService object.
        """
        self.data = self.data_transformer_dao.transform(data=self.data)
        return self
    
    def collect(self) -> Dict[str, Any] | None:
        """
        Property representing the fetched data.

        Returns:
            Dict: The fetched data.
        """
        return self.data
