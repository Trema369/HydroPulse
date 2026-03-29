import asyncio
import websockets
import json
from PySide6.QtCore import QObject, Signal

VPS_WS_URL = "wss://hydro-api.tremaz.dev/ws"

class WebSocketWorker(QObject):
    phChanged = Signal(float)
    tempChanged = Signal(float)
    turbidityChanged = Signal(float)
    analysisReady = Signal(dict)
    analyzeRequested = Signal()

    def __init__(self):
        super().__init__()
        self._running = True

    async def listen_local(self):
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
            except Exception as e:
                print(f"Local WS error: {e}, reconnecting in 3s...")
                await asyncio.sleep(3)

    async def listen_vps(self):
        while self._running:
            try:
                async with websockets.connect(VPS_WS_URL) as websocket:
                    print("Connected to VPS WebSocket")
                    while self._running:
                        data = await websocket.recv()
                        msg = json.loads(data)
                        print("VPS message:", msg.get("type"))
                        if msg.get("type") == "analyze_request":
                            print("analyze_request received from VPS")
                            self.analyzeRequested.emit()
                        elif msg.get("type") == "analysis":
                            self.analysisReady.emit(msg)
            except Exception as e:
                print(f"VPS WS error: {e}, reconnecting in 3s...")
                await asyncio.sleep(3)

    async def run(self):
        await asyncio.gather(
            self.listen_local(),
            self.listen_vps()
        )

    def start(self):
        asyncio.run(self.run())

    def stop(self):
        self._running = False
