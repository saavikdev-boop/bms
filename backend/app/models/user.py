from sqlalchemy import Column, String, Integer, DateTime, ARRAY
from sqlalchemy.orm import relationship
from datetime import datetime
from ..core.database import Base


class User(Base):
    __tablename__ = "users"

    uid = Column(String, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=True)  # Nullable for phone auth
    phone_number = Column(String, unique=True, index=True, nullable=True)  # For phone auth
    display_name = Column(String, nullable=True)
    photo_url = Column(String, nullable=True)
    name = Column(String, nullable=True)
    age = Column(Integer, nullable=True)
    gender = Column(String, nullable=True)
    sports = Column(ARRAY(String), nullable=True)
    interests = Column(ARRAY(String), nullable=True)
    auth_provider = Column(String, default='email', nullable=True)  # email, phone, google
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    addresses = relationship("Address", back_populates="user", cascade="all, delete-orphan")
    cart_items = relationship("CartItem", back_populates="user", cascade="all, delete-orphan")
    bookings = relationship("Booking", back_populates="user", cascade="all, delete-orphan")
    wallet = relationship("Wallet", back_populates="user", uselist=False, cascade="all, delete-orphan")
