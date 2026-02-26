# backend/sensor_state.py
latest_reading = {"ph": None, "turbidity": None, "temperature": None}

def update_reading(ph, turbidity, temperature):
    global latest_reading
    latest_reading = {
        "ph": ph,
        "turbidity": turbidity,
        "temperature": temperature
    }

def get_latest_reading():
    return latest_reading
