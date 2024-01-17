from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String

Base = declarative_base()

class QuestionnaireEntity(Base):
    __table__ = "questionnaire"

    id : Column = Column(Integer)
    question_1 : Column = Column(String)
    question_2 : Column = Column(String)

    def __str__(self):
        return f"Person(id={self.id}, question_1={self.question_1}, question_2={self.question_2})"