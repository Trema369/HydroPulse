import httpx
from PySide6.QtCore import QObject, Slot, Signal
from backend.sensor_state import get_latest_reading
from backend.api import analyze_sensor_data
import asyncio

VPS_RESULT_URL = "https://hydro-api.tremaz.dev/result"

class AIController(QObject):
    resultReady = Signal(dict)

    def __init__(self):
        super().__init__()

    @Slot()
    def calculate_ai(self):
        reading = get_latest_reading()
        if reading.get("ph") is None or reading.get("turbidity") is None:
            print("Sensor readings not yet stable.")
            return
        asyncio.run(self._run_analysis(reading))

    async def _run_analysis(self, reading: dict):
        try:
            result = await analyze_sensor_data(
                ph=reading["ph"],
                turbidity=reading["turbidity"],
                temperature=reading.get("temperature") or 0
            )
            self.resultReady.emit(result)
            async with httpx.AsyncClient() as client:
                await client.post(VPS_RESULT_URL, json=result, timeout=10)
            print("AI result pushed to VPS:", result)
        except Exception as e:
            print("AI analysis failed:", e)
