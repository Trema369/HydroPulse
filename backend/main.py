from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
import asyncio
from .sensor_service import sensor_loop
from .ai_service import analyze_readings
from .database import init_db, save_result
from .models import ReadingPayload
from .sensor_state import update_reading


app = FastAPI()
init_db()

# Allow QML + Website access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

connected_clients = set()


@app.on_event("startup")
async def start_sensor_task():
    asyncio.create_task(sensor_loop(broadcast))


async def broadcast(data: dict):
    update_reading(data["ph"], data["turbidity"], data["temperature"])
    dead = []
    for ws in connected_clients:
        try:
            await ws.send_json(data)
        except:
            dead.append(ws)

    for ws in dead:
        connected_clients.remove(ws)


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    connected_clients.add(websocket)

    try:
        while True:
            await asyncio.sleep(1)
    except WebSocketDisconnect:
        connected_clients.remove(websocket)


@app.post("/analyze")
async def analyze(payload: ReadingPayload):
    result = analyze_readings(payload)
    save_result(result)
    return result
