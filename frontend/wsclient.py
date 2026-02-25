import asyncio
import websockets
import json
from PySide6.QtCore import QObject, Signal, QThread


class WebSocketWorker(QObject):
    phChanged = Signal(float)
    tempChanged = Signal(float)
    turbidityChanged = Signal(float)

    def __init__(self):
        super().__init__()
        self._running = True

    async def listen(self):
        uri = "ws://127.0.0.1:8000/ws"

        async with websockets.connect(uri) as websocket:
            while self._running:
                data = await websocket.recv()
                reading = json.loads(data)

                self.phChanged.emit(reading["ph"])
                self.tempChanged.emit(reading["temperature"])
                self.turbidityChanged.emit(reading["turbidity"])

    def start(self):
        asyncio.run(self.listen())

    def stop(self):
        self._running = False
