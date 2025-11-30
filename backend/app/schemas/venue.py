from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class VenueBase(BaseModel):
    name: str
    description: Optional[str] = None
    address: str
    city: str
    state: str
    pincode: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    image_urls: List[str] = []
    thumbnail_url: Optional[str] = None
    sports_available: List[str] = []
    amenities: List[str] = []
    price_per_hour: float
    opening_time: Optional[str] = None
    closing_time: Optional[str] = None
    total_courts: int = 1
    contact_phone: Optional[str] = None
    contact_email: Optional[str] = None


class VenueCreate(VenueBase):
    pass


class VenueUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    pincode: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    image_urls: Optional[List[str]] = None
    thumbnail_url: Optional[str] = None
    sports_available: Optional[List[str]] = None
    amenities: Optional[List[str]] = None
    price_per_hour: Optional[float] = None
    opening_time: Optional[str] = None
    closing_time: Optional[str] = None
    is_active: Optional[bool] = None
    total_courts: Optional[int] = None
    contact_phone: Optional[str] = None
    contact_email: Optional[str] = None


class VenueResponse(VenueBase):
    id: str
    rating: float
    total_reviews: int
    is_active: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
