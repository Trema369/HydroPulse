from PySide6.QtCore import QObject, Signal, QThread
from sensor_worker import SensorWorker

class SensorController(QObject):
    phChanged = Signal(float)
    turbidityChanged = Signal(float)
    tempChanged = Signal(float)

    def __init__(self):
        super().__init__()

        self.worker = SensorWorker()
        self.thread = QThread()
        self.worker.moveToThread(self.thread)

        self.worker.phRead.connect(self.phChanged.emit)
        self.worker.turbidityRead.connect(self.turbidityChanged.emit)
        self.worker.tempRead.connect(self.tempChanged.emit)

        self.thread.started.connect(self.worker.start)
        self.thread.start()

    def stop(self):
        self.worker.stop()
        self.thread.quit()
        self.thread.wait()
