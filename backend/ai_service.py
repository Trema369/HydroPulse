def analyze_readings(payload):
    score = 100

    # pH scoring
    if payload.ph < 6.5 or payload.ph > 8.5:
        score -= 25

    # turbidity scoring
    if payload.turbidity > 5:
        score -= 30

    # temperature scoring
    if payload.temperature > 35:
        score -= 10

    overview = generate_overview(payload, score)

    return {
        "ph": payload.ph,
        "temperature": payload.temperature,
        "turbidity": payload.turbidity,
        "score": max(score, 0),
        "overview": overview,
    }


def generate_overview(payload, score):
    if score > 80:
        return "Water quality is excellent."
    elif score > 60:
        return "Water quality is acceptable but needs monitoring."
    else:
        return "Water quality is poor. Immediate attention required."
