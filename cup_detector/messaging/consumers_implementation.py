from abc import ABC, abstractmethod

class Consumer(ABC):
    @abstractmethod
    def get(self):
        pass

    @abstractmethod
    def post(self):
        pass

    @abstractmethod
    def put(self):
        pass
    
    @abstractmethod
    def delete(self):
        pass
    

