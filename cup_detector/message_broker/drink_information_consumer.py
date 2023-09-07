from typing import Dict, List
import threading
import firebase_admin
from firebase_admin import db, credentials
import json

class DrinksInformationConsumer:
    """
    A class for consuming and managing drink information from a Firebase Realtime Database.

    Args:
        table_name (str): The name of the database table to monitor.
        options (dict): Firebase options for initialization.

    Attributes:
        table_name (str): The name of the database table being monitored.
        drink_response (list): A list to store drink response data.
        data_lock (threading.Lock): A lock to ensure thread-safe access to data.

    Methods:
        _fetch_content_from_message_broker(endpoint): Fetch content from the message broker.
        _delete_order_from_message_broker(endpoint): Delete an order from the message broker.
        listen_for_updates_on_drink_message_broker(endpoint): Listen for updates on the drink message broker.
    """
    def __init__(self, table_name : str, options : Dict[str, str]):
        self.table_name = table_name
        cred : credentials.Certificate = credentials.Certificate(cert=r"message_broker/credentials_firebase.json")
        firebase_admin.initialize_app(credential=cred, options=options)
        self.drink_response = []
        self.data_lock = threading.Lock() 

    def _fetch_order_from_message_broker(self, endpoint : str = "/") -> Dict:
        """
        Fetch content from the message broker.

        Args:
            endpoint (str): The endpoint to fetch data from.

        Returns:
            tuple | Any: A tuple or data fetched from the endpoint or an error message.
        """
        try:
            db.reference(endpoint).get()
        except Exception as exception:
            return f"Error when fetching the order/orders: {exception}"
    
    def _delete_order_from_message_broker(self, endpoint : str = "/") -> str:
        """
        Delete an order from the message broker.

        Args:
            order_id (str): The ID of the order to be deleted.

        Returns:
            str: A message indicating the status of the delete operation.
        """
        try:
            db.reference(endpoint).delete()
        except Exception as exception:
            return f"Error when deleting the order/orders {exception}"

    def listen_for_updates_on_drink_message_broker(self, endpoint: str = "/"):
        """
        Listen for updates on the drink message broker.

        Args:
            endpoint (str): The endpoint to listen for updates on.
        """
        reference : firebase_admin.Reference = db.reference(endpoint)

        def on_data_change_on_broker_listenable(event : Dict) -> None:
            print(f"event type: {event.event_type}")
            if event.event_type in ["post", "put"]:
                with self.data_lock:
                    response_data_change : json = json.loads(json.dumps(event.data, indent=4))
                    order_ids : List[str] = list(response_data_change[self.table_name].keys())

                    response_get_order = self._fetch_order_from_message_broker(f"/{self.table_name}/{order_ids[0]}")
                    if response_get_order is not None:
                        print(response_get_order)
                        return
                    self.drink_response.append(response_get_order) 
                    
                    response_delete_order = self._delete_order_from_message_broker(f"/{self.table_name}/{order_ids[0]}")
                    if response_delete_order is not None:
                        print(response_delete_order)
                        return 

        reference.listen(on_data_change_on_broker_listenable)
