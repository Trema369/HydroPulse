from PySide6.QtCore import QObject, Signal
import time
import requests
from sensors.ph import read_ph
from sensors.tubi import read_turbidity
from sensors.temp import read_temp_c

VPS_URL = "https://hydro-api.tremaz.dev/reading"

class SensorWorker(QObject):
    phRead = Signal(float)
    turbidityRead = Signal(float)
    tempRead = Signal(float)

    def __init__(self):
        super().__init__()
        self.running = True

    def start(self):
        while self.running:
            try:
                ph = read_ph()
                turbidity = read_turbidity()
                temp = read_temp_c()

                self.phRead.emit(ph)
                self.turbidityRead.emit(turbidity)
                self.tempRead.emit(temp)

                try:
                    requests.post(VPS_URL, json={
                        "ph": ph,
                        "turbidity": turbidity,
                        "temperature": temp,
                        "tds": 0  # wire up when TDS sensor is ready
                    }, timeout=3)
                except Exception as e:
                    print("VPS push error:", e)

            except Exception as e:
                print("Sensor read error:", e)

            time.sleep(5)  # push every 5s

    def stop(self):
        self.running = False
