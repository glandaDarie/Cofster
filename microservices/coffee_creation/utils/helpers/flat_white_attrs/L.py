import RPi.GPIO as GPIO 
from time import sleep
from utils.helpers.flat_white_attrs.ingredients_quantity import ingredients_quantity
from utils.enums.size_factors import SizeFactors

L : int = SizeFactors.LARGE.value

# coffee process
def coffee(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("coffee", 0)*L)
    GPIO.output(pin, GPIO.HIGH)

# coffee process
def double_shot_of_espresso(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("double_shot_of_espresso", 0)*L) 
    GPIO.output(pin, GPIO.HIGH)

# milk process
def milk(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("milk", 0)*L)
    GPIO.output(pin, GPIO.HIGH)