from pydantic import BaseModel, Field
from datetime import datetime

class CardPayload(BaseModel):
    deck_id: int
    front: str
    back: str
    extra_data: dict = Field(default_factory=dict)

# Used for type hinting internally
class SrsUpdate(BaseModel):
    card_id: int
    quality: int # 0-5