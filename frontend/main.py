# main.py
import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from sensor_controller import SensorController
from ai_controller import AIController

app = QApplication(sys.argv)
engine = QQmlApplicationEngine()

# Controllers
controller = SensorController()
ai_controller = AIController()

engine.rootContext().setContextProperty("controller", controller)
engine.rootContext().setContextProperty("aiController", ai_controller)

# Connect AI results to a QML Text element
def on_ai_result(data):
    root = engine.rootObjects()[0]
    # Make sure the Text item has objectName "aiOverview"
    overview_text = root.findChild(QObject, "aiOverview")
    if overview_text:
        overview_text.setProperty("text", data.get("overview", "No overview"))

ai_controller.resultReady.connect(on_ai_result)

engine.load("main.qml")

if not engine.rootObjects():
    sys.exit(-1)
sys.exit(app.exec())
