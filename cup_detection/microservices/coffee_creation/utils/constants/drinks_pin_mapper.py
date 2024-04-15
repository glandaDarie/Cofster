from typing import Dict, Tuple
from utils.enums.coffee_types import CoffeeTypes
from utils.constants.pin_ingredient_mapper import (
    COFFEE, MILK, SUGAR, WATER
)

drinks_pin_mapper : Dict[str, Tuple[int]] = {
    CoffeeTypes.CORTADO.value : (COFFEE, MILK, SUGAR, WATER),
    CoffeeTypes.AMERICANO.value : (COFFEE, MILK),
    CoffeeTypes.CAPPUCCINO.value : (COFFEE, MILK),
    CoffeeTypes.LATTE_MACHIATTO.value : (COFFEE, MILK),
    CoffeeTypes.FLAT_WHITE.value : (COFFEE, MILK),
    CoffeeTypes.COLD_ESPRESSO.value : (COFFEE, MILK),
    CoffeeTypes.MOCHA.value : (COFFEE, MILK),
    CoffeeTypes.COLD_BREW.value : (COFFEE, MILK),
    CoffeeTypes.CORETTO.value : (COFFEE, MILK),
    CoffeeTypes.IRISH_COFFEE.value : (COFFEE, MILK),
}