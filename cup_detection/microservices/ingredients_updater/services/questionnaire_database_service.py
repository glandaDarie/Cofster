from typing import Tuple
from sqlalchemy import create_engine, MetaData, Table, Engine, desc, String, DateTime
from sqlalchemy.exc import NoSuchTableError
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.orm.query import Query

class QuestionnaireDatabaseService:
    def __init__(self, database_url : str, table_name : str):
        """
        Initializes the QuestionnaireDatabaseService.

        Args:
            database_url (str): The URL to connect to the database.
            table_name (str): The name of the table in the database.
        """
        self.engine : Engine = create_engine(url=database_url, echo=True)
        self.table_name : str  = table_name
        self.metadata : MetaData = MetaData()
        self.session : Session = self.create_session()

    def create_session(self) -> Session:
        """
        Creates and returns a sessionmaker for the database engine.

        Returns:
            sessionmaker: An instance of sessionmaker.
        """
        Session : sessionmaker = sessionmaker(bind=self.engine)
        return Session()

    def __get_questionnaire_table(self) -> Table:
        """
        Retrieves the questionnaire table from the reflected metadata.

        Returns:
            Table: The questionnaire table.
        """
        self.metadata.reflect(bind=self.engine)
        return self.metadata.tables.get(self.table_name)

    def get_customer_responses(self, customer_name : str, coffee_name : str, limit_nr_responses : int = 10) -> Query[Tuple[DateTime, String, String]]:
        """
        Retrieves the customer responses from the questionnaire table.

        Args:
            customer_name (str): The name of the customer.
            limit_nr_responses (int): The maximum number of responses to retrieve (default is 10).

        Returns:
            List[Tuple[DateTime, String, String]]: A list of tuples containing responses.
        """
        try:
            questionnaire_table = self.__get_questionnaire_table()

            if questionnaire_table is None:
                raise NoSuchTableError(f"Table {self.table_name} could not be found in the reflected metadata.")
            
            person_query : Query[Tuple[DateTime, String, String]] = self.session.query(
                questionnaire_table.c.timestamp,
                questionnaire_table.c.question_1,
                questionnaire_table.c.question_2
            ).filter(
                questionnaire_table.c.user_name == customer_name,
                questionnaire_table.c.user_coffee == coffee_name,
            ).order_by(desc(questionnaire_table.c.timestamp))\
            .limit(limit_nr_responses)
            return person_query.all()
        except NoSuchTableError as table_error:
            raise table_error