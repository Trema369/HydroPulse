import time

device_file = '/sys/bus/w1/devices/28-000000b2ee5e/w1_slave'

def read_temp_raw():
    try:
        with open(device_file, 'r') as f:
            return f.readlines()
    except Exception:
        return []

def read_temp_c():
    lines = read_temp_raw()

    if not lines or len(lines) < 2:
        return None  # Sensor not ready

    if "YES" not in lines[0]:
        return None  # Bad CRC

    equals_pos = lines[1].find('t=')
    if equals_pos != -1:
        temp_string = lines[1][equals_pos+2:]
        return float(temp_string) / 1000.0

    return None
