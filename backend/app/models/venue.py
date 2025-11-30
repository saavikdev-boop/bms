from sqlalchemy import Column, String, Float, Integer, DateTime, ARRAY, Text, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime
from ..core.database import Base


class Venue(Base):
    """
    Venue model for sports facilities/locations.
    Stores venue information with images and amenities.
    """
    __tablename__ = "venues"

    id = Column(String, primary_key=True, index=True)
    name = Column(String, nullable=False, index=True)
    description = Column(Text, nullable=True)
    address = Column(String, nullable=False)
    city = Column(String, nullable=False, index=True)
    state = Column(String, nullable=False)
    pincode = Column(String, nullable=False)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)

    # Images stored as file paths (e.g., 'venue_images/file.jpg')
    image_urls = Column(ARRAY(String), default=[], nullable=False)
    thumbnail_url = Column(String, nullable=True)

    # Venue details
    sports_available = Column(ARRAY(String), default=[], nullable=False)
    amenities = Column(ARRAY(String), default=[], nullable=True)  # parking, washroom, cafe, etc.
    price_per_hour = Column(Float, nullable=False)
    rating = Column(Float, default=0.0)
    total_reviews = Column(Integer, default=0)

    # Operating hours
    opening_time = Column(String, nullable=True)  # e.g., "06:00"
    closing_time = Column(String, nullable=True)  # e.g., "22:00"

    # Availability
    is_active = Column(Boolean, default=True)
    total_courts = Column(Integer, default=1)

    # Contact info
    contact_phone = Column(String, nullable=True)
    contact_email = Column(String, nullable=True)

    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    games = relationship("Game", back_populates="venue", cascade="all, delete-orphan")
