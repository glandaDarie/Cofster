from typing import Dict

from patterns.factories.coffee_creator.cortado_creator import CortadoCreator
from patterns.factories.coffee_creator.americano_creator import AmericanoCreator
from patterns.factories.coffee_creator.cappuccino_creator import CappuccinoCreator
from patterns.factories.coffee_creator.latte_macchiato_creator import LatteMacchiatoCreator
from patterns.factories.coffee_creator.flat_white_creator import FlatWhiteCreator
from patterns.factories.coffee_creator.cold_espresso_creator import ColdEspressoCreator
from patterns.factories.coffee_creator.mocha_creator import MochaCreator
from patterns.factories.coffee_creator.cold_brew_creator import ColdBrewCreator
from patterns.factories.coffee_creator.coretto_creator import CorettoCreator
from patterns.factories.coffee_creator.irish_coffee_creator import IrishCoffeeCreator

from interfaces.coffee_creator import CoffeeCreator
from utils.enums.coffee_types import CoffeeTypes
from utils.exceptions.no_such_coffee_type_error import NoSuchCoffeeTypeError
from services.parallel_coffee_creator_service import ParallelCoffeeCreatorService

class CoffeeCreatorFactory:
    _creators : Dict[str, CoffeeCreator] = {
        CoffeeTypes.CORTADO.value: CortadoCreator,
        CoffeeTypes.AMERICANO.value: AmericanoCreator,
        CoffeeTypes.CAPPUCCINO.value: CappuccinoCreator,
        CoffeeTypes.LATTE_MACHIATTO.value: LatteMacchiatoCreator,
        CoffeeTypes.FLAT_WHITE.value: FlatWhiteCreator,
        CoffeeTypes.COLD_ESPRESSO.value: ColdEspressoCreator,
        CoffeeTypes.MOCHA.value: MochaCreator,
        CoffeeTypes.COLD_BREW.value: ColdBrewCreator,
        CoffeeTypes.CORETTO.value: CorettoCreator,
        CoffeeTypes.IRISH_COFFEE.value: IrishCoffeeCreator
    }

    @classmethod
    def create(cls : type['CoffeeCreatorFactory'], coffee_type: str) -> CoffeeCreator:
        creator_class : CoffeeCreator = cls._creators.get(coffee_type)
        if creator_class:
            return creator_class(ParallelCoffeeCreatorService())
        else:
            raise NoSuchCoffeeTypeError(status_code=500)