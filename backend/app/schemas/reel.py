from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class ReelBase(BaseModel):
    video_url: str
    thumbnail_url: Optional[str] = None
    caption: Optional[str] = None
    sport: Optional[str] = None
    location: Optional[str] = None
    duration: int
    width: Optional[int] = None
    height: Optional[int] = None
    file_size: Optional[int] = None
    hashtags: List[str] = []
    tagged_users: List[str] = []
    is_public: bool = True


class ReelCreate(ReelBase):
    pass


class ReelUpdate(BaseModel):
    caption: Optional[str] = None
    sport: Optional[str] = None
    location: Optional[str] = None
    hashtags: Optional[List[str]] = None
    is_public: Optional[bool] = None
    is_active: Optional[bool] = None


class ReelResponse(ReelBase):
    id: str
    user_id: str
    views_count: int
    likes_count: int
    comments_count: int
    shares_count: int
    is_active: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class CommentCreate(BaseModel):
    text: str


class CommentResponse(BaseModel):
    id: str
    reel_id: str
    user_id: str
    text: str
    likes_count: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
