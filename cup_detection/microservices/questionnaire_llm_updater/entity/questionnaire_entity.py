from sqlalchemy.ext.declarative import declarative_base, DeclarativeMeta
from sqlalchemy import Column, Integer, String, DateTime, func

Base : DeclarativeMeta = declarative_base()

class QuestionnaireEntity(Base):
    __tablename__ : str = "questionnaire"

    id : Column = Column(Integer, primary_key=True)
    question_1 : Column = Column(String)
    question_2 : Column = Column(String)
    user_coffee : Column = Column(String)
    user_name : Column = Column(String)
    timestamp : Column = Column(DateTime, server_default=func.now())

    def __str__(self) -> str:
        return (
            f"Person(id={self.id}, "
            f"question_1={self.question_1}, "
            f"question_2={self.question_2}, "
            f"user_coffee={self.user_coffee}, "
            f"user_name={self.user_name}, "
            f"created_timestamp={self.timestamp})"
        )