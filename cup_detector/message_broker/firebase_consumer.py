from typing import Dict, Any
# import threading
import firebase_admin
from firebase_admin import db, credentials
# from utils.firebase_rtd_url import DATABASE_OPTIONS

DATABASE_OPTIONS : Dict[str, str] = {
    "databaseURL" : "https://coffeemachinegatewaybroker-default-rtdb.europe-west1.firebasedatabase.app/"
}

# class DrinksInformationConsumer(threading.Thread):
class DrinksInformationConsumer:
    def __init__(self):
        cred : credentials.Certificate = credentials.Certificate(cert="credentials_firebase.json")
        firebase_admin.initialize_app(credential=cred, options=DATABASE_OPTIONS)
    
    def get_content(self, endpoint : str = "/") -> tuple | Any:
        return db.reference(endpoint).get()
    
    def listen_for_updates(self, endpoint: str = "/"):
        reference : firebase_admin.Reference = db.reference(endpoint)
        
        def on_data_change_listenable(event : Dict):
            if event.event_type == "put" or event.event_type == "post":
                print(event.data)

        reference.listen(on_data_change_listenable)

if __name__ == "__main__":
    consumer = DrinksInformationConsumer()
    consumer.listen_for_updates("/")