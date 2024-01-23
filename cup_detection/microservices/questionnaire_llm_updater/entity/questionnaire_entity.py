from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String

Base = declarative_base()

class QuestionnaireEntity(Base):
    __tablename__ = "questionnaire"

    id : Column = Column(Integer, primary_key=True)
    question_1 : Column = Column(String)
    question_2 : Column = Column(String)
    user_name : Column = Column(String)

    def __str__(self):
        return f"Person(id={self.id}, user_name={self.user_name}, question_1={self.question_1}, question_2={self.question_2})"