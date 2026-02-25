import board
import busio
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn
import time

i2c = busio.I2C(board.SCL, board.SDA)
ads = ADS.ADS1115(i2c)
chan = AnalogIn(ads, 1)

def calculate_ntu(voltage):
    ntu = (3.9 - voltage) * (1000 / 3.9)
    return max(0, min(1000, ntu))

def read_average(samples=10):
    total = 0
    for _ in range(samples):
        total += chan.voltage
        time.sleep(0.02)
    return total / samples

def read_turbidity():
    voltage = read_average()
    return calculate_ntu(voltage)
