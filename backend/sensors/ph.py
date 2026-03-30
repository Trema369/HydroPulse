import board
import busio
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn
from time import sleep

# Calibration — estimated from probe readings
# Re-calibrate with pH 4.0 and 7.0 buffer solutions for best accuracy
SLOPE = -4.37
INTERCEPT = 20.64

def read_voltage_avg(samples=10) -> float:
    i2c = busio.I2C(board.SCL, board.SDA)
    ads = ADS.ADS1115(i2c)
    chan = AnalogIn(ads, 0)
    readings = []
    for _ in range(samples):
        v = chan.voltage
        if v > 0.1:  # skip connection spike
            readings.append(v)
        sleep(0.02)
    readings.sort()
    middle = readings[2:min(8, len(readings))]
    if not middle:
        return 0.0
    return sum(middle) / len(middle)

def read_ph() -> float:
    try:
        voltage = read_voltage_avg()
        ph = SLOPE * voltage + INTERCEPT
        return round(max(0.0, min(14.0, ph)), 3)
    except Exception as e:
        print(f"pH read error: {e}")
        return 0.0
