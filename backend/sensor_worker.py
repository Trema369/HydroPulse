from PySide6.QtCore import QObject, Signal
import time
from sensors.ph import read_ph
from sensors.tubi import read_turbidity
from sensors.temp import read_temp_c

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

            except Exception as e:
                print("Sensor read error:", e)

            time.sleep(1)  # adjust your polling interval

    def stop(self):
        self.running = False
