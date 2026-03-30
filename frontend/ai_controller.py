import httpx
import asyncio
import threading
from PySide6.QtCore import QObject, Slot, Signal
from backend.api import analyze_sensor_data

VPS_RESULT_URL  = "https://hydro-api.tremaz.dev/result"
VPS_READING_URL = "https://hydro-api.tremaz.dev/reading"


class AIController(QObject):
    resultReady   = Signal(dict)
    errorOccurred = Signal(str)

    def __init__(self):
        super().__init__()

    @Slot()
    def calculate_ai(self):
        print("calculate_ai called — starting background thread")
        thread = threading.Thread(target=self._run_in_thread, daemon=True)
        thread.start()

    def _run_in_thread(self):
        """Runs in a background thread — keeps Qt main thread responsive."""
        asyncio.run(self._run_analysis())

    async def _run_analysis(self):
        try:
            async with httpx.AsyncClient() as client:
                resp = await client.get(VPS_READING_URL, timeout=5)
                reading = resp.json()
                print("Reading from VPS:", reading)

            ph          = reading.get("ph")          or 0
            turbidity   = reading.get("turbidity")   or 0
            temperature = reading.get("temperature") or 0

            result = await analyze_sensor_data(
                ph=ph,
                turbidity=turbidity,
                temperature=temperature
            )

            print("AI result:", result)

            # Qt automatically marshals cross-thread signal emission
            self.resultReady.emit(result)

            async with httpx.AsyncClient() as client:
                await client.post(VPS_RESULT_URL, json=result, timeout=10)
            print("AI result pushed to VPS")

        except Exception as e:
            print(f"AI analysis failed: {e}")
            self.errorOccurred.emit(str(e))

