from database_strategy import DatabaseStrategy
from utils.logger import LOGGER
from entity.questionnaire_entity import Base, QuestionnaireEntity
from sqlalchemy import Table, MetaData, create_engine, inspect, Engine, inspect
from sqlalchemy.orm import sessionmaker, Session
from typing import Self, Dict, Any

class PostgresStrategyDAO(DatabaseStrategy):
    """
    Concrete implementation of DatabaseStrategy for PostgreSQL databases.

    This class provides methods to connect to a PostgreSQL database, create tables, insert entities,
    and disconnect from the database.
    """
    
    def __init__(self, database, username : str, password : str, host : str = "localhost", port : int = 5432):
        """
        Initialize a PostgresStrategyDAO instance.

        Parameters:
        - database (str): The name of the database.
        - username (str): The username for database authentication.
        - password (str): The password for database authentication.
        - host (str): The database server hostname (default is "localhost").
        - port (int): The database server port number (default is 5432).
        """
        self.host : str = host
        self.port : int = port
        self.database : str = database
        self.username : str = username
        self.password : str = password
        self.inspector = None
        self.engine : Engine | None = None
        self.session : Session | None = None
        
    def connect(self) -> Self:
        """
        Connect to the PostgreSQL database.

        Returns:
        - Self: Returns the instance of the class.
        """
        LOGGER.info(f"Connecting to PostgreSQL database as {self.username}@{self.host}:{self.port}.")
        database_url : str = f"postgresql://{self.username}:{self.password}@{self.host}:{self.port}/{self.database}"
        self.engine = create_engine(database_url, echo=True)
        self.inspector = inspect(subject=self.engine)
        Session = sessionmaker(bind=self.engine)
        self.session = Session()
        return self

    def create_table(self, table_name : str) -> Self:
        """
        Create a table in the PostgreSQL database.

        Parameters:
        - table_name (str): The name of the table to be created.
        
        Returns:
        - Self: Returns the instance of the class.
        """
        table_exists : bool = self.inspector.has_table(table_name=table_name)
        if table_exists:
            LOGGER.info(f"Table: {table_name} exists in database: {self.database}")
        else:
            LOGGER.info(f"Table: {table_name} does not exist in database: {self.database}")
            metadata : MetaData = MetaData(self.engine)
            table : Table = Table(name=table_name, metadata=metadata, autoload_with=self.engine)
            table.create()
        return self
    
    @staticmethod
    def __is_entity(cls: Any) -> bool:
        """
        Check if a class is a valid SQLAlchemy entity.

        Parameters:
        - cls (Type): The class to be checked.

        Returns:
        - bool: True if cls is a valid entity, False otherwise.
        """
        return isinstance(cls, type) and issubclass(cls, Base)

    def insert(self, entity : QuestionnaireEntity, **params : Dict[str, Any]) -> Self:
        """
        Insert a new entity into the database.

        Parameters:
        - entity (QuestionnaireEntity): The SQLAlchemy entity class.
        - params (Dict[str, Any]): Keyword arguments representing the attributes of the entity.

        Returns:
        - Self: Returns the instance of the class.
        """
        error_msg : str | None
        if not self.__is_entity(entity):
            error_msg = f"{entity} is not a valid SQLAlchemy entity."
            LOGGER.error(error_msg)
            raise ValueError(error_msg)
        entity_instance = entity(*params.values())
        self.session.add(entity_instance)
        self.session.commit()
        return self
    
    def disconnect(self) -> Self:
        """
        Disconnect from the PostgreSQL database.

        Returns:
        - PostgresStrategyDAO: Returns the instance of the class.
        """
        self.session.close()
        self.engine.dispose()
        return self