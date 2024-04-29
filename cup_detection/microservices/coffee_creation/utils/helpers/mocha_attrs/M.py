import RPi.GPIO as GPIO 
from time import sleep
from utils.helpers.mocha_attrs.ingredients_quantity import ingredients_quantity
from utils.enums.size_factors import SizeFactors

M : int = SizeFactors.MEDIUM.value

# coffee process
def coffee(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("coffee", 0)*M)
    GPIO.output(pin, GPIO.HIGH)

# coffee process
def brewed_espresso(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("brewed_espresso", 0)*M) 
    GPIO.output(pin, GPIO.HIGH)

# chocolate syrup process
def chocolate_syrup(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("chocolate_syrup", 0)*M)
    GPIO.output(pin, GPIO.HIGH)

# vanilla syrup process
def vanilla_syrup(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("vanilla_syrup", 0)*M)
    GPIO.output(pin, GPIO.HIGH)

# milk process
def milk(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("milk", 0)*M)
    GPIO.output(pin, GPIO.HIGH)