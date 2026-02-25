from pydantic import BaseModel


class ReadingPayload(BaseModel):
    ph: float
    temperature: float
    turbidity: float
