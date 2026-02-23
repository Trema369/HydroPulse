from PySide6.QtCore import QObject, Signal, QTimer
import random

class SensorController(QObject):
    phChanged = Signal(float)
    turbidityChanged = Signal(float)
    tempChanged = Signal(float)

    def __init__(self):
        super().__init__()
        self.timer = QTimer()
        self.timer.timeout.connect(self.generate_fake_data)
        self.timer.start(1000)  # every 1 second

    def generate_fake_data(self):
        ph = random.uniform(0, 14)
        turbidity = random.uniform(0, 100)
        temp = random.uniform(20, 100)
        self.phChanged.emit(ph)
        self.turbidityChanged.emit(turbidity)
        self.tempChanged.emit(temp)
