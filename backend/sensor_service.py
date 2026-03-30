import asyncio
import time
import httpx
from .sensors.ph import read_ph
from .sensors.temp import read_temp_c
from .sensors.tubi import read_turbidity
from .sensors.tds import read_tds

VPS_URL = "https://hydro-api.tremaz.dev/reading"

async def sensor_loop(broadcast_callback):
    async with httpx.AsyncClient() as client:
        while True:
            try:
                ph = read_ph()
                temp = read_temp_c()
                turbidity = read_turbidity()
                data = {
                    "type":"reading",
                    "ph": ph,
                    "temperature": temp,
                    "turbidity": turbidity,
                    "tds": read_tds(),
                    "timestamp": time.time()
                }
                await broadcast_callback(data)
                try:
                    await client.post(VPS_URL, json=data, timeout=3)
                except Exception as e:
                    print("VPS push error:", e)
            except Exception as e:
                print("Sensor read error:", e)
            await asyncio.sleep(5)
