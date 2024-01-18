from abc import ABC, abstractmethod
from typing import Self, Dict, Any

class DatabaseStrategyDAO(ABC):
    """
    Abstract base class for database strategies.

    This class defines a set of methods that should be implemented by concrete database strategy classes.
    """
    
    @abstractmethod
    def connect(self) -> Self:
        """Abstract method to connect to the database."""
        pass

    @abstractmethod
    def create_table(self) -> Self:
        """
        Abstract method to create a table in the database.

        Parameters:
        - table_name (str): The name of the table to be created.

        Returns:
        - DatabaseStrategy: Returns the instance of the class.
        """
        pass

    @abstractmethod
    def insert(self, entity, **params : Dict[str, Any]) -> Self:
        """
        Abstract method to insert a new entity into the database.

        Parameters:
        - entity: The SQLAlchemy entity class.
        - params (Dict[str, Any]): Keyword arguments representing the attributes of the entity.

        Returns:
        - DatabaseStrategy: Returns the instance of the class.
        """
        pass

    @abstractmethod
    def disconnect() -> Self:
        """
        Abstract method to disconnect from the database.

        Returns:
        - DatabaseStrategy: Returns the instance of the class.
        """
        pass
    
