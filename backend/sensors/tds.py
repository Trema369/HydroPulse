import busio
import board
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn

def read_tds() -> float:
    try:
        i2c = busio.I2C(board.SCL, board.SDA)
        ads = ADS.ADS1115(i2c)
        # TDS sensor on A1 — change to A2/A3 if wired differently
        chan = AnalogIn(ads, 2)
        voltage = chan.voltage
        # Convert voltage to TDS (ppm)
        # Standard formula for common TDS sensors (adjust factor for your probe)
        tds_value = (voltage / 3.3) * 1000
        return round(tds_value, 2)
    except Exception as e:
        print(f"TDS read error: {e}")
        return 0.0
