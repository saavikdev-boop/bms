from pydantic import BaseModel
from typing import Optional
from ..models.address import AddressType


class AddressBase(BaseModel):
    name: str
    mobile: str
    pincode: str
    house_number: str
    address: str
    locality: str
    city: str
    state: str
    type: AddressType = AddressType.home
    is_default: bool = False


class AddressCreate(AddressBase):
    pass


class AddressUpdate(BaseModel):
    name: Optional[str] = None
    mobile: Optional[str] = None
    pincode: Optional[str] = None
    house_number: Optional[str] = None
    address: Optional[str] = None
    locality: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    type: Optional[AddressType] = None
    is_default: Optional[bool] = None


class AddressResponse(AddressBase):
    id: str
    user_id: str

    class Config:
        from_attributes = True
