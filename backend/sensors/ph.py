import board
import busio
from adafruit_ads1x15.ads1115 import ADS1115
from adafruit_ads1x15.analog_in import AnalogIn
from time import sleep

i2c = busio.I2C(board.SCL, board.SDA)
ads = ADS1115(i2c)
chan = AnalogIn(ads, ADS1115.P0)

# ⚠️ Replace with real calibration values
SLOPE = -5.7
INTERCEPT = 21.34

def read_voltage_avg(samples=10):
    readings = []
    for _ in range(samples):
        readings.append(chan.voltage)
        sleep(0.02)
    readings.sort()
    middle = readings[2:8]
    return sum(middle) / len(middle)

def read_ph():
    voltage = read_voltage_avg()
    return SLOPE * voltage + INTERCEPT
