import RPi.GPIO as GPIO 
from time import sleep
from utils.helpers.espresso_attrs.ingredients_quantity import ingredients_quantity
from utils.enums.size_factors import SizeFactors

S : int = SizeFactors.SMALL.value

# coffee process
def coffee(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("coffee", 0)*S)
    GPIO.output(pin, GPIO.HIGH)

# coffee process
def double_shot_of_espresso(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("double_shot_of_espresso", 0)*S) 
    GPIO.output(pin, GPIO.HIGH)

# milk process
def milk(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("milk", 0)*S)
    GPIO.output(pin, GPIO.HIGH)