from attr import define

@define
class Order:
    coffee_cup_size: str
    coffee_finish_time_estimation: str
    coffee_name: str
    coffee_order_time: str
    coffee_price: str
    coffee_status: int
    communication: str
    customer_name: str
    has_cream: bool
    number_of_ice_cubes: int
    number_of_sugar_cubes: int
    quantity: int
    recipe_type: str