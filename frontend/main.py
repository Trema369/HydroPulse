import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from sensor_controller import SensorController

app = QApplication(sys.argv)

engine = QQmlApplicationEngine()

controller = SensorController()
engine.rootContext().setContextProperty("controller", controller)

engine.load("main.qml")

if not engine.rootObjects():
    sys.exit(-1)

sys.exit(app.exec())

