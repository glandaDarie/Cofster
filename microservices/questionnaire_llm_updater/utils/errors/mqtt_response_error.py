class MqttResponseError(Exception):
    def __init__(self, error_message : str, status_code : int = 500):
        super().__init__(error_message)
        self._status_code : int = status_code
    
    @property
    def status_code(self):
        return self._status_code