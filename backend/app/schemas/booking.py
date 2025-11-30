from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from ..models.booking import BookingStatus


class BookingBase(BaseModel):
    sport: str
    venue_name: str
    venue_address: str
    date: datetime
    start_time: str
    end_time: str
    duration: int
    price: float


class BookingCreate(BookingBase):
    pass


class BookingUpdate(BaseModel):
    status: Optional[BookingStatus] = None


class BookingResponse(BookingBase):
    id: str
    user_id: str
    status: BookingStatus
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
