from PySide6.QtCore import QObject, Signal, QTimer

from backend.sensors.tubi import read_turbidity
from backend.sensors.temp import read_temp_c
from backend.sensors.ph import read_ph


class SensorController(QObject):
    phChanged = Signal(float)
    turbidityChanged = Signal(float)
    tempChanged = Signal(float)

    def __init__(self):
        super().__init__()

        self.timer = QTimer()
        self.timer.timeout.connect(self.update_sensors)
        self.timer.start(1000)  # every 1 second

    def update_sensors(self):
        try:
            ph = read_ph()
            turbidity = read_turbidity()
            temp = read_temp_c()

            self.phChanged.emit(ph)
            self.turbidityChanged.emit(turbidity)
            self.tempChanged.emit(temp)

        except Exception as e:
            print("Sensor read error:", e)
