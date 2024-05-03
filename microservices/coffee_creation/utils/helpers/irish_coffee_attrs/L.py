import RPi.GPIO as GPIO 
from time import sleep
from utils.helpers.irish_coffee_attrs.ingredients_quantity import ingredients_quantity
from utils.enums.size_factors import SizeFactors

L : int = SizeFactors.LARGE.value

# coffee process
def coffee(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("coffee", 0)*L)
    GPIO.output(pin, GPIO.HIGH)

# coffee process
def brewed_espresso(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("brewed_espresso", 0)*L) 
    GPIO.output(pin, GPIO.HIGH)

# irish whiskey process
def irish_whiskey(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("irish_whiskey", 0)*L)
    GPIO.output(pin, GPIO.HIGH)

# whiskey process
def whiskey(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("whiskey", 0)*L)
    GPIO.output(pin, GPIO.HIGH)

# sugar process
def sugar(pin : int) -> None:
    GPIO.output(pin, GPIO.LOW)
    sleep(ingredients_quantity.get("sugar", 0)*L)
    GPIO.output(pin, GPIO.HIGH)