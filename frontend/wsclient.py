import asyncio
import websockets
import json
from PySide6.QtCore import QObject, Signal

class WebSocketWorker(QObject):
    phChanged = Signal(float)
    tempChanged = Signal(float)
    turbidityChanged = Signal(float)
    analysisReady = Signal(dict)
    analyzeRequested = Signal()

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
                        msg = json.loads(data)
                        if msg.get("type") == "reading":
                            self.phChanged.emit(float(msg.get("ph", 0)))
                            self.tempChanged.emit(float(msg.get("temperature") or 0))
                            self.turbidityChanged.emit(float(msg.get("turbidity", 0)))
                        elif msg.get("type") == "analysis":
                            self.analysisReady.emit(msg)
                        elif msg.get("type") == "analyze_request":
                            print("analyze_request received")
                            self.analyzeRequested.emit()
            except Exception as e:
                print(f"WebSocket error: {e}, reconnecting in 3s...")
                await asyncio.sleep(3)

    def start(self):
        asyncio.run(self.listen())

    def stop(self):
        self._running = False
