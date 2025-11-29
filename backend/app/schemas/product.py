from pydantic import BaseModel
from typing import Optional, List


class ProductBase(BaseModel):
    name: str
    category: Optional[str] = None
    rating: float = 0.0
    reviews: str = ""
    mrp: int
    price: int
    image_url: str
    sizes: List[str] = []
    description: str = ""


class ProductCreate(ProductBase):
    id: str


class ProductUpdate(BaseModel):
    name: Optional[str] = None
    category: Optional[str] = None
    rating: Optional[float] = None
    reviews: Optional[str] = None
    mrp: Optional[int] = None
    price: Optional[int] = None
    image_url: Optional[str] = None
    sizes: Optional[List[str]] = None
    description: Optional[str] = None


class ProductResponse(ProductBase):
    id: str
    discount: int

    class Config:
        from_attributes = True

    @property
    def discount(self) -> int:
        return int((self.mrp - self.price) / self.mrp * 100) if self.mrp > 0 else 0
