from sqlalchemy import Column, String, Boolean, ForeignKey, Enum
from sqlalchemy.orm import relationship
import enum
from ..core.database import Base


class AddressType(str, enum.Enum):
    home = "home"
    office = "office"


class Address(Base):
    __tablename__ = "addresses"

    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.uid"), nullable=False)
    name = Column(String, nullable=False)
    mobile = Column(String, nullable=False)
    pincode = Column(String, nullable=False)
    house_number = Column(String, nullable=False)
    address = Column(String, nullable=False)
    locality = Column(String, nullable=False)
    city = Column(String, nullable=False)
    state = Column(String, nullable=False)
    type = Column(Enum(AddressType), default=AddressType.home)
    is_default = Column(Boolean, default=False)

    # Relationships
    user = relationship("User", back_populates="addresses")
