# main_controller.py
import requests
from PySide6.QtCore import QObject, Slot, Signal
from backend.sensor_state import get_latest_reading  # should return {'ph': .., 'turbidity': .., 'temperature': ..}

class AIController(QObject):
    resultReady = Signal(dict)  # emits AI analysis back to QML

    def __init__(self):
        super().__init__()
        self.ai_url = "http://127.0.0.1:8000/analyze"

    @Slot()
    def calculate_ai(self):
        reading = get_latest_reading()
        if None in reading.values():
            print("Sensor readings not yet stable.")
            return

        try:
            resp = requests.post(self.ai_url, json=reading, timeout=15)
            resp.raise_for_status()
            data = resp.json()
            print("AI Result:", data)
            self.resultReady.emit(data)  # emit to QML
        except Exception as e:
            print("AI call failed:", e)
