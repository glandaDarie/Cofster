class Order:
    def __init__(self, 
        coffee_cup_size : str, 
        coffee_finish_time_estimation : str, 
        coffee_name : str, 
        coffee_order_time : str, 
        coffee_price : str, 
        coffee_status : int, 
        coffee_temperature : str, 
        communication : str,
        has_cream : bool,
        number_of_ice_cubes : int,
        number_of_sugar_cubes : int, 
        quantity : int):

        self._coffee_cup_size : str = coffee_cup_size
        self._coffee_finish_time_estimation : str = coffee_finish_time_estimation
        self._coffee_name : str = coffee_name
        self._coffee_order_time : str = coffee_order_time
        self._coffee_price : str = coffee_price
        self._coffee_status : int = coffee_status
        self._coffee_temperature : str = coffee_temperature
        self._communication : str = communication
        self._has_cream : bool = has_cream
        self._number_of_ice_cubes : int = number_of_ice_cubes
        self._number_of_sugar_cubes : int = number_of_sugar_cubes
        self._quantity : int = quantity

    @property
    def coffee_cup_size(self) -> str:
        return self._coffee_cup_size

    @coffee_cup_size.setter
    def coffee_cup_size(self, value : str) -> None:
        self._coffee_cup_size : str = value

    @property
    def coffee_finish_time_estimation(self) -> str:
        return self._coffee_finish_time_estimation

    @coffee_finish_time_estimation.setter
    def coffee_finish_time_estimation(self, value : str) -> None:
        self._coffee_finish_time_estimation : str = value

    @property
    def coffee_name(self) -> str:
        return self._coffee_name

    @coffee_name.setter
    def coffee_name(self, value : str) -> None:
        self._coffee_name : str = value

    @property
    def coffee_order_time(self) -> str:
        return self._coffee_order_time

    @coffee_order_time.setter
    def coffee_order_time(self, value : str) -> None:
        self._coffee_order_time : str = value

    @property
    def coffee_price(self) -> str:
        return self._coffee_price

    @coffee_price.setter
    def coffee_price(self, value : str) -> None:
        self._coffee_price : str = value

    @property
    def coffee_status(self) -> int:
        return self._coffee_status

    @coffee_status.setter
    def coffee_status(self, value : int) -> None:
        self._coffee_status : int = value

    @property
    def coffee_temperature(self) -> str:
        return self._coffee_temperature

    @coffee_temperature.setter
    def coffee_temperature(self, value : str) -> None:
        self._coffee_temperature : str = value

    @property
    def communication(self) -> str:
        return self._communication

    @communication.setter
    def communication(self, value : str) -> None:
        self._communication : str = value

    @property
    def has_cream(self) -> bool:
        return self._has_cream    

    @has_cream.setter
    def has_cream(self, has_cream : bool) -> None:
        self._has_cream : bool = has_cream

    @property
    def number_of_ice_cubes(self) -> int:
        return self._number_of_ice_cubes

    @number_of_ice_cubes.setter
    def number_of_ice_cubes(self, value : int) -> None:
        self._number_of_ice_cubes : int = value

    @property
    def number_of_sugar_cubes(self) -> int:
        return self._number_of_sugar_cubes

    @number_of_sugar_cubes.setter
    def number_of_sugar_cubes(self, value : int) -> None:
        self._number_of_sugar_cubes : int = value

    @property
    def quantity(self) -> int:
        return self._quantity

    @quantity.setter
    def quantity(self, value : int) -> None:
        self._quantity : int = value