# api.py
import json
from mistralai import Mistral
from dotenv import load_dotenv

load_dotenv()

api_key ="rqtkZkCk4gYJ96MTbyqzYxDnPsZlLvP9"
client = Mistral(api_key=api_key)

async def analyze_sensor_data(ph: float, turbidity: float, temperature: float) -> dict:
    """
    Analyze sensor readings and return a structured dict.
    """
    prompt = f"""
You are an environmental water quality analysis AI.

Sensor readings:
- pH: {ph}
- Turbidity (NTU): {turbidity}
- Temperature (°C): {temperature}

Evaluate the water condition.

Return STRICTLY valid JSON with this structure:

{{
  "score": float (0.0 to 10.0),
  "status": "Good" | "Moderate" | "Warning" | "Critical",
  "overview": "Short paragraph summary",
  "issues": ["list of detected problems"],
  "recommended_actions": ["list of general recommended actions"]
}}

Scoring Guide:
9–10   = Excellent
7–8.9  = Safe but monitor
4–6.9  = Problematic
0–3.9  = Dangerous

No markdown.
No explanations outside JSON.
"""

    response = client.chat.complete(
        model="ministral-14b-latest",
        messages=[
            {"role": "system", "content": "You are a precise water systems analysis AI."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.2,
        max_tokens=400,
        response_format={"type": "json_object"}
    )

    ai_json = response.choices[0].message.content
    return json.loads(ai_json)
