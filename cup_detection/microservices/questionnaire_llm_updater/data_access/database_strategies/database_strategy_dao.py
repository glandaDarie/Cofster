from abc import ABC, abstractmethod
from typing import Dict, Any

class DatabaseStrategyDAO(ABC):
    """
    Abstract base class for database strategies.

    This class defines a set of methods that should be implemented by concrete database strategy classes.
    """
    
    @abstractmethod
    def connect(self) -> None:
        """
        Abstract method to connect to the database.
        
        Returns:
        - None: nothing.
        """
        pass

    @abstractmethod
    def create_table(self) -> None:
        """
        Abstract method to create a table in the database.

        Parameters:
        - table_name (str): The name of the table to be created.

        Returns:
        - None: nothing.
        """
        pass

    @abstractmethod
    def insert(self, entity, **params : Dict[str, Any]) -> None:
        """
        Abstract method to insert a new entity into the database.

        Parameters:
        - entity: The SQLAlchemy entity class.
        - params (Dict[str, Any]): Keyword arguments representing the attributes of the entity.

        Returns:
        - None: nothing.
        """
        pass

    @abstractmethod
    def disconnect() -> None:
        """
        Abstract method to disconnect from the database.

        Returns:
        - None: nothing.
        """
        pass
