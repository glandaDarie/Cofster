import RPi.GPIO as GPIO 
from time import sleep

# coffee process
def brewed_espresso(pin : int) -> None:
    GPIO.output(pin, GPIO.HIGH)
    sleep(4)
    GPIO.output(pin, GPIO.LOW)

# milk process
def milk(pin : int) -> None:
    GPIO.output(pin, GPIO.HIGH)
    sleep(7)
    GPIO.output(pin, GPIO.LOW)

# sugar process
def sugar(pin : int) -> None:
    GPIO.output(pin, GPIO.HIGH)
    sleep(3)
    GPIO.output(pin, GPIO.LOW)

# water process
def water(pin : int) -> None:
    GPIO.output(pin, GPIO.HIGH)
    sleep(2)
    GPIO.output(pin, GPIO.LOW)