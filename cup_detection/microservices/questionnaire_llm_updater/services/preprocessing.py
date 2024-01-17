from pyspark.sql import SparkSession
from typing import Any
from data_access.database_strategies.database_strategy import DatabaseStrategy
# import sys

# sys.path.append("../")

class SparkPreprocessorStrategy:
    def __init__(self, session_name : str, data : Any, db_strategy : DatabaseStrategy):
        self.session_name : str = session_name
        self.data : Any = data
        self.db_strategy = db_strategy
        self.spark_session : None | SparkSession = None

    def start_session(self):
        self.spark_session : SparkSession = SparkSession.builder \
            .appName(self.session_name) \
            .getOrCreate()
        return self
    
    def transform(self):
        pass