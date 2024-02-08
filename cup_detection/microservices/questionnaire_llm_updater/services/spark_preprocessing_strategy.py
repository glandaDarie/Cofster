from pyspark.sql import SparkSession
from typing import List, Dict, Any
from re import sub

import sys
sys.path.append("../")

from data_access.database_strategies.database_strategy_dao import DatabaseStrategyDAO
from entity.questionnaire_entity import QuestionnaireEntity

class SparkPreprocessorStrategy:
    def __init__(self, session_name : str, data : Any, table_save_data : str, loader_db_dao_strategy : DatabaseStrategyDAO):
        """
        Initializes a SparkPreprocessorStrategy instance.

        Parameters:
            - session_name (str): Name of the Spark session.
            - data (Any): Data to be processed.
            - table_save_data (str): Name of the table to save the processed data.
            - loader_db_dao_strategy (DatabaseStrategyDAO): Database strategy for loading data.

        Returns:
            None
        """
        self.session_name : str = session_name
        self.data : Any = data
        self.table_save_data : str = table_save_data
        self.loader_db_dao_strategy : DatabaseStrategyDAO = loader_db_dao_strategy
        self.spark_session : None | SparkSession = None

    def start_session(self) -> None:
        """
        Starts a Spark session.

        Returns:
            None
        """
        self.spark_session : SparkSession = SparkSession.builder \
            .appName(self.session_name) \
            .getOrCreate()
        self.loader_db_dao_strategy.connect()
    
    def transform(self) -> None:
        """
        Transforms the data in a List[Dict[str, Any]].

        Returns:
            None
        """
        qas : List[str] = self.data.split("\n")
        self.data : List[Dict[str, Any]] = [{"user_name" if index >= (len(qas) - 1) else f"question_{index+1}" : \
            sub(r'\s+', ' ', qa).replace("question: ", "").replace("Answer: ", "").split(" - ")[1].strip()} \
            for index, qa in enumerate(qas) \
        ]
    
    def update_prompt(self) -> None:
        pass

    def save(self) -> None:
        """
        Saves the transformed data to the specified database table.

        Returns:
            None
        """
        self.loader_db_dao_strategy.create_table(table_name=self.table_save_data)
        self.loader_db_dao_strategy.insert(entity=QuestionnaireEntity, params=self.data)

    def stop_session(self) -> None:
        """
        Stops the Spark session.

        Returns:
            None
        """
        self.spark_session.stop()