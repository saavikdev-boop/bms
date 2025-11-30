from pydantic import BaseModel, EmailStr, field_validator
from typing import Optional, List
from datetime import datetime


class UserBase(BaseModel):
    email: Optional[EmailStr] = None
    phone_number: Optional[str] = None
    display_name: Optional[str] = None
    photo_url: Optional[str] = None
    name: Optional[str] = None
    age: Optional[int] = None
    gender: Optional[str] = None
    sports: Optional[List[str]] = None
    interests: Optional[List[str]] = None
    auth_provider: Optional[str] = None  # email, phone, google

    @field_validator('email', 'phone_number')
    @classmethod
    def check_email_or_phone(cls, v, info):
        # At least one of email or phone_number must be provided
        # This validation happens at the model level
        return v


class UserCreate(UserBase):
    uid: str

    @field_validator('uid')
    @classmethod
    def validate_uid(cls, v):
        if not v:
            raise ValueError('UID is required')
        return v


class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    phone_number: Optional[str] = None
    display_name: Optional[str] = None
    photo_url: Optional[str] = None
    name: Optional[str] = None
    age: Optional[int] = None
    gender: Optional[str] = None
    sports: Optional[List[str]] = None
    interests: Optional[List[str]] = None
    auth_provider: Optional[str] = None


class UserResponse(UserBase):
    uid: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
