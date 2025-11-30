from sqlalchemy import Column, String, Integer, Float, ARRAY, Text
from sqlalchemy.orm import relationship
from ..core.database import Base


class Product(Base):
    __tablename__ = "products"

    id = Column(String, primary_key=True, index=True)
    name = Column(String, nullable=False)
    category = Column(String, nullable=True)
    rating = Column(Float, default=0.0)
    reviews = Column(String, default="")
    mrp = Column(Integer, nullable=False)
    price = Column(Integer, nullable=False)
    # Primary image (file path, e.g., 'product_images/file.jpg')
    image_url = Column(String, nullable=False)
    # Additional product images for gallery
    image_urls = Column(ARRAY(String), default=[], nullable=True)
    sizes = Column(ARRAY(String), default=[])
    description = Column(Text, default="")

    # Relationships
    cart_items = relationship("CartItem", back_populates="product", cascade="all, delete-orphan")
