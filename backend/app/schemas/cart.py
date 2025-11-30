from pydantic import BaseModel
from typing import Optional
from .product import ProductResponse


class CartItemBase(BaseModel):
    product_id: str
    quantity: int = 1
    size: Optional[str] = None


class CartItemCreate(CartItemBase):
    pass


class CartItemUpdate(BaseModel):
    quantity: Optional[int] = None
    size: Optional[str] = None


class CartItemResponse(BaseModel):
    id: str
    user_id: str
    product_id: str
    quantity: int
    size: Optional[str] = None
    product: ProductResponse

    class Config:
        from_attributes = True
