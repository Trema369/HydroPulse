import asyncio
import websockets
import json
from PySide6.QtCore import QObject, Signal

class WebSocketWorker(QObject):
    phChanged = Signal(float)
    tempChanged = Signal(float)
    turbidityChanged = Signal(float)

    def __init__(self):
        super().__init__()
        self._running = True

    async def listen(self):
        uri = "ws://127.0.0.1:8000/ws"
        while self._running:
            try:
                async with websockets.connect(uri) as websocket:
                    while self._running:
                        data = await websocket.recv()
                        reading = json.loads(data)
                        self.phChanged.emit(float(reading.get("ph", 0)))
                        self.tempChanged.emit(float(reading.get("temperature") or 0))
                        self.turbidityChanged.emit(float(reading.get("turbidity", 0)))
            except Exception as e:
                print(f"WebSocket error: {e}, reconnecting in 3s...")
                await asyncio.sleep(3)

    def start(self):
        asyncio.run(self.listen())

    def stop(self):
        self._running = False
