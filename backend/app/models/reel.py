from sqlalchemy import Column, String, Integer, DateTime, Float, ForeignKey, Boolean, Text, ARRAY
from sqlalchemy.orm import relationship
from datetime import datetime
from ..core.database import Base


class Reel(Base):
    """
    Reel model for short-form video content (like Instagram Reels/TikTok).
    Users can post sports-related videos.
    """
    __tablename__ = "reels"

    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.uid"), nullable=False, index=True)

    # Video file stored as file path (e.g., 'reels/20240101_video.mp4')
    video_url = Column(String, nullable=False)
    thumbnail_url = Column(String, nullable=True)  # Video thumbnail

    # Content details
    caption = Column(Text, nullable=True)
    sport = Column(String, nullable=True, index=True)
    location = Column(String, nullable=True)

    # Video metadata
    duration = Column(Integer, nullable=False)  # in seconds
    width = Column(Integer, nullable=True)
    height = Column(Integer, nullable=True)
    file_size = Column(Integer, nullable=True)  # in bytes

    # Engagement metrics
    views_count = Column(Integer, default=0)
    likes_count = Column(Integer, default=0)
    comments_count = Column(Integer, default=0)
    shares_count = Column(Integer, default=0)

    # Tags and hashtags
    hashtags = Column(ARRAY(String), default=[], nullable=True)
    tagged_users = Column(ARRAY(String), default=[], nullable=True)  # User IDs

    # Visibility
    is_public = Column(Boolean, default=True)
    is_active = Column(Boolean, default=True)  # Can be hidden by user or admin

    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, index=True)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    user = relationship("User", foreign_keys=[user_id])
    likes = relationship("ReelLike", back_populates="reel", cascade="all, delete-orphan")
    comments = relationship("ReelComment", back_populates="reel", cascade="all, delete-orphan")


class ReelLike(Base):
    """
    Tracks likes on reels.
    """
    __tablename__ = "reel_likes"

    id = Column(String, primary_key=True, index=True)
    reel_id = Column(String, ForeignKey("reels.id"), nullable=False, index=True)
    user_id = Column(String, ForeignKey("users.uid"), nullable=False, index=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    reel = relationship("Reel", back_populates="likes")
    user = relationship("User")


class ReelComment(Base):
    """
    Comments on reels.
    """
    __tablename__ = "reel_comments"

    id = Column(String, primary_key=True, index=True)
    reel_id = Column(String, ForeignKey("reels.id"), nullable=False, index=True)
    user_id = Column(String, ForeignKey("users.uid"), nullable=False, index=True)
    text = Column(Text, nullable=False)
    likes_count = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    reel = relationship("Reel", back_populates="comments")
    user = relationship("User")
