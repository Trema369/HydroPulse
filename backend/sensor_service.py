import asyncio
import time
from .sensors.ph import read_ph
from .sensors.temp import read_temp_c
from .sensors.tubi import read_turbidity


async def sensor_loop(broadcast_callback):
    while True:
        ph = read_ph()
        temp = read_temp_c()
        turbidity = read_turbidity()

        data = {
            "ph": ph,
            "temperature": temp,
            "turbidity": turbidity,
            "timestamp": time.time()
        }

        await broadcast_callback(data)

        await asyncio.sleep(1)
