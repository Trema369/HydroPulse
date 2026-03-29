# main.py
import os
import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject # Added this for your findChild call later

# Use the full package path
from frontend.sensor_controller import SensorController
from frontend.ai_controller import AIController

# ... rest of your code ...

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
controller.analyzeRequested.connect(ai_controller.calculate_ai)
base_dir = os.path.dirname(os.path.abspath(__file__))
qml_file = os.path.join(base_dir, "main.qml")

# Load the file using the absolute path
engine.load(qml_file)

if not engine.rootObjects():
    sys.exit(-1)
sys.exit(app.exec())
