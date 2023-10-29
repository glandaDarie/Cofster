from typing import Dict, List, Any
import threading
import firebase_admin
from firebase_admin import db, credentials
import json
from enum import Enum
from enums.methods import Methods
from models.order import Order

class DrinkInformationConsumer:
    """
    A class for consuming and managing drink information from a Firebase Realtime Database.

    Args:
        table_name (str): The name of the database table to monitor.
        options (dict): Firebase options for initialization.

    Attributes:
        table_name (str): The name of the database table being monitored.
        drinks_information (list): A list to store drink response data.
        data_lock (threading.Lock): A lock to ensure thread-safe access to data.

    Methods:
        _fetch_content_from_message_broker(endpoint): Fetch content from the message broker.
        delete_order_from_message_broker(endpoint): Delete an order from the message broker.
        listen_for_updates_on_drink_message_broker(endpoint): Listen for updates on the drink message broker.
    """
    def __init__(self, table_name : str, options : Dict[str, str]):
        self.table_name : str = table_name
        cred : credentials.Certificate = credentials.Certificate(cert=r"messaging/credentials_firebase.json")
        firebase_admin.initialize_app(credential=cred, options=options)
        self.drinks_information : List[Dict] = []
        self.order_ids : List[str] = []
        self.data_lock : threading.Lock() = threading.Lock() 

    def __fetch_order_from_message_broker(self, endpoint : str = "/") -> Dict | str:
        """
        Fetch content from the message broker.

        Args:
            endpoint (str): The endpoint to fetch data from.

        Returns:
            tuple | Any: A tuple or data fetched from the endpoint or an error message.
        """
        try:
            order = db.reference(endpoint).get()
        except Exception as exception:
            return f"Error when fetching the order/orders: {exception}"
        return order

    def delete_order_from_message_broker(self, endpoint : str = "/") -> str | None:
        """
        Delete an order from the message broker.

        Args:
            endpoint (str): The endpoint used for deleting the order.

        Returns:
            str: A message indicating the status of the delete operation.
        """
        try:
            db.reference(endpoint).delete()
        except Exception as exception:
            return f"Error when deleting the order/orders {exception}"
        
    def update_order_in_message_broker(self, new_value : str, endpoint : str = "/") -> str | None:
        """
        Update the coffeeStatus of an order in the Firebase Realtime Database.

        Args:
            new_value (str): The new value to set for the coffeeStatus.
            endpoint (str, optional): The endpoint path within the database.

        Returns:
            str: A message indicating the status of the update operation.
        """
        try:
            db.reference(endpoint).set(new_value)
        except Exception as exception:
            return f"Error when trying to update the the coffeeStatus of the order: {exception}"

    def listen_for_updates_on_drink_message_broker(self, endpoint: str = "/"):
        """
        Listen for updates on the drink message broker.

        Args:
            endpoint (str): The endpoint to listen for updates on.
        """
        reference : firebase_admin.Reference = db.reference(endpoint)

        def on_data_change_broker_listenable(event : json) -> None: 
            """
            Listens for data changes on the Firebase Realtime Database and handles the respective method responses.

            Args:
                event (json): The event data triggered by a data change in the Firebase Realtime Database.
            """
            def handle_method_response(data : Any) -> Enum:  
                """
                Handles the respective methods response from the firebase real time database.

                Args:
                    data (Any): The respective content returned from the real time database 
                                that will help distinguish the methods type.
                """
                if self.table_name in data: 
                    return Methods.GET
                elif data == "null": 
                    return Methods.DELETE
                elif self.table_name not in data and len(data.split(" ")) != 1:
                    return Methods.POST
                return Methods.PUT

            if event.event_type != "put":
                print(f"Changes while listening on the data couldn't be tracked, type is: {event.event_type}")
                return 
            
            method : str = handle_method_response(json.dumps(event.data, indent=4)) 
            if method.value == Methods.POST:
                with self.data_lock:
                    response_data_change : json = json.loads(json.dumps(event.data, indent=4))
                    order_id : str = self.__get_order_id(order_information=response_data_change)
                    if order_id is None:
                        print("Respective order id could not be found")
                        return
                    self.drinks_information.append(response_data_change) 
                    self.order_ids.append(order_id)
        
        reference.listen(on_data_change_broker_listenable)
    
    def __get_order_id(self, order_information : Dict[str, Any]) -> str | None:
        """
        Retrieves the order ID that matches the provided order information.

        Args:
            order_information (Dict[str, Any]): A dictionary containing order information to match against.

        Returns:
            str | None: The order ID if a matching order is found; None if no matching order is found.
        """
        all_orders_fetched : Dict | str = json.loads(json.dumps(self.__fetch_order_from_message_broker(f"/{self.table_name}"), indent=4))
        if isinstance(all_orders_fetched, str):
            print(all_orders_fetched)
            return
        for order_id, order_fetched in all_orders_fetched.items():
            order_information_fetched : Order = Order(*list(order_fetched.values()))
            if order_information_fetched.coffee_cup_size.strip() == order_information["coffeeCupSize"].strip() and \
               order_information_fetched.coffee_finish_time_estimation.strip() == order_information["coffeeFinishTimeEstimation"].strip() and \
               order_information_fetched.coffee_name.strip() == order_information["coffeeName"].strip() and \
               order_information_fetched.coffee_order_time.strip() == order_information["coffeeOrderTime"].strip() and \
               order_information_fetched.coffee_price.strip() == order_information["coffeePrice"].strip() and \
               order_information_fetched.coffee_status == order_information["coffeeStatus"] and \
               order_information_fetched.coffee_temperature.strip() == order_information["coffeeTemperature"].strip() and \
               order_information_fetched.communication.strip() == order_information["communication"].strip() and \
               order_information_fetched.has_cream == order_information["hasCream"] and \
               order_information_fetched.number_of_ice_cubes == order_information["numberOfIceCubes"] and \
               order_information_fetched.number_of_sugar_cubes == order_information["numberOfSugarCubes"] and \
               order_information_fetched.quantity == order_information["quantity"]:
                return order_id