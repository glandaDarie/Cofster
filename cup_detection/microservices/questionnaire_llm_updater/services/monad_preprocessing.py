from typing import Any

class MonadPreprocessing:
    """
    MonadPreprocessing class represents a monad for preprocessing operations.

    Args:
    - args (Any, optional): The initial value contained within the monad.

    Attributes:
    - args (Any): The value contained within the monad.

    Methods:
    - bind(callback: callable) -> MonadPreprocessing: Apply a callback function to the monad's value.
    """
    def __init__(self, args : Any = None):
        """
        Initialize the MonadPreprocessing instance.

        Args:
        - args (Any, optional): The initial value contained within the monad.
        """
        self.args : Any = args

    def bind(self, callback : callable) -> "MonadPreprocessing":
        """
        Apply a callback function to the monad's value.

        Args:
        - callback (callable): The function to be applied to the monad's value.

        Returns:
        - MonadPreprocessing: A new instance of MonadPreprocessing containing the updated value.
        """
        try:
            if self.args is None:
                self.args = callback()
            else:
                self.args = callback(*self.args)
        except Exception as error:
            raise Exception(f"Error in callback function: {callback.__name__} - {error}")
        return MonadPreprocessing(args=self.args)