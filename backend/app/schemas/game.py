from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from ..models.game import GameType, GameStatus, SkillLevel


class GameBase(BaseModel):
    venue_id: str
    sport: str
    title: str
    description: Optional[str] = None
    date: datetime
    start_time: str
    end_time: str
    duration: int
    min_players: int
    max_players: int
    game_type: GameType = GameType.public
    skill_level: SkillLevel = SkillLevel.any
    gender_preference: Optional[str] = None
    age_group: Optional[str] = None
    price_per_person: float
    total_cost: float
    split_cost: bool = True
    rules: Optional[str] = None
    required_equipment: List[str] = []


class GameCreate(GameBase):
    pass


class GameUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    date: Optional[datetime] = None
    start_time: Optional[str] = None
    end_time: Optional[str] = None
    max_players: Optional[int] = None
    price_per_person: Optional[float] = None
    status: Optional[GameStatus] = None
    rules: Optional[str] = None


class GameResponse(GameBase):
    id: str
    host_id: str
    current_players: int
    player_ids: List[str]
    status: GameStatus
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
