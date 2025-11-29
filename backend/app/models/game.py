from sqlalchemy import Column, String, Integer, DateTime, Float, ForeignKey, Enum, ARRAY, Text, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
from ..core.database import Base


class GameType(str, enum.Enum):
    """Type of game organization"""
    public = "public"  # Anyone can join
    private = "private"  # Invite only
    tournament = "tournament"  # Tournament format


class GameStatus(str, enum.Enum):
    """Current status of the game"""
    upcoming = "upcoming"  # Scheduled, accepting players
    full = "full"  # All slots filled
    in_progress = "in_progress"  # Currently being played
    completed = "completed"  # Game finished
    cancelled = "cancelled"  # Game cancelled


class SkillLevel(str, enum.Enum):
    """Skill level requirement"""
    beginner = "beginner"
    intermediate = "intermediate"
    advanced = "advanced"
    any = "any"


class Game(Base):
    """
    Game model for organized sports events/matches.
    Users can host games and other users can join.
    """
    __tablename__ = "games"

    id = Column(String, primary_key=True, index=True)

    # Host information
    host_id = Column(String, ForeignKey("users.uid"), nullable=False, index=True)

    # Venue information
    venue_id = Column(String, ForeignKey("venues.id"), nullable=False, index=True)

    # Game details
    sport = Column(String, nullable=False, index=True)
    title = Column(String, nullable=False)  # e.g., "Sunday Morning Cricket Match"
    description = Column(Text, nullable=True)

    # Scheduling
    date = Column(DateTime, nullable=False, index=True)
    start_time = Column(String, nullable=False)  # e.g., "10:00"
    end_time = Column(String, nullable=False)  # e.g., "12:00"
    duration = Column(Integer, nullable=False)  # in minutes

    # Participants
    min_players = Column(Integer, nullable=False)
    max_players = Column(Integer, nullable=False)
    current_players = Column(Integer, default=1)  # Host counts as 1
    player_ids = Column(ARRAY(String), default=[], nullable=False)  # List of joined user IDs

    # Game settings
    game_type = Column(Enum(GameType), default=GameType.public, nullable=False)
    skill_level = Column(Enum(SkillLevel), default=SkillLevel.any, nullable=False)
    gender_preference = Column(String, nullable=True)  # male, female, mixed, null=any
    age_group = Column(String, nullable=True)  # "18-25", "25-35", etc.

    # Pricing
    price_per_person = Column(Float, nullable=False)
    total_cost = Column(Float, nullable=False)  # Venue booking cost
    split_cost = Column(Boolean, default=True)  # Whether to split venue cost among players

    # Status
    status = Column(Enum(GameStatus), default=GameStatus.upcoming, nullable=False, index=True)

    # Additional info
    rules = Column(Text, nullable=True)
    required_equipment = Column(ARRAY(String), default=[], nullable=True)

    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    host = relationship("User", foreign_keys=[host_id])
    venue = relationship("Venue", back_populates="games")
