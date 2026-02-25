from PySide6.QtCore import QObject, Signal, QThread
from wsclient import WebSocketWorker


class SensorController(QObject):
    phChanged = Signal(float)
    turbidityChanged = Signal(float)
    tempChanged = Signal(float)

    def __init__(self):
        super().__init__()

        self.worker = WebSocketWorker()
        self.thread = QThread()
        self.worker.moveToThread(self.thread)

        self.worker.phChanged.connect(self.phChanged.emit)
        self.worker.turbidityChanged.connect(self.turbidityChanged.emit)
        self.worker.tempChanged.connect(self.tempChanged.emit)

        self.thread.started.connect(self.worker.start)
        self.thread.start()

    def stop(self):
        self.worker.stop()
        self.thread.quit()
        self.thread.wait()
