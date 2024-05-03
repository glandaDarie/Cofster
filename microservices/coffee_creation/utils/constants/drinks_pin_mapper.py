from typing import Dict, Tuple
from utils.enums.coffee_types import CoffeeTypes
from utils.constants.pin_ingredient_mapper import (
    COFFEE, 
    MILK, 
    SUGAR,
    WATER, 
    VANILLA_SYRUP, 
    SAMBUCA, 
    WHISKEY
)

drinks_pin_mapper : Dict[str, Tuple[int]] = {
    CoffeeTypes.CORTADO.value : (COFFEE, MILK, SUGAR, WATER),
    CoffeeTypes.AMERICANO.value : (COFFEE, MILK, SUGAR, WATER, VANILLA_SYRUP),
    CoffeeTypes.CAPPUCCINO.value : (COFFEE, MILK, SUGAR, WATER, VANILLA_SYRUP),
    CoffeeTypes.LATTE_MACHIATTO.value : (COFFEE, MILK),
    CoffeeTypes.FLAT_WHITE.value : (COFFEE, MILK),
    CoffeeTypes.COLD_ESPRESSO.value : (COFFEE,),
    CoffeeTypes.MOCHA.value : (COFFEE, MILK, VANILLA_SYRUP),  
    CoffeeTypes.COLD_BREW.value : (COFFEE, WATER, MILK),  
    CoffeeTypes.CORETTO.value : (COFFEE, SAMBUCA), 
    CoffeeTypes.IRISH_COFFEE.value : (COFFEE, WHISKEY, SUGAR)
}