# backend/ai_endpoint.py
from fastapi import FastAPI
from pydantic import BaseModel
from .api import analyze_sensor_data  # your AI module
from .database import save_result

app = FastAPI()

class SensorData(BaseModel):
    ph: float
    turbidity: float
    temperature: float

@app.post("/analyze")
async def analyze(data: SensorData):
    """
    Endpoint to send current sensor readings to AI.
    """
    result = await analyze_sensor_data(data.ph, data.turbidity, data.temperature)
    save_result(result)  # optional: persist
    return result
