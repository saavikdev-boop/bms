"""
Game Management Router
Handles game creation, joining, and management
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime
import uuid

from ..core.database import get_db
from ..models.game import Game, GameType, GameStatus, SkillLevel
from ..models.user import User
from ..models.venue import Venue
from ..schemas.game import GameCreate, GameUpdate, GameResponse

router = APIRouter()


@router.post("/{user_id}", response_model=GameResponse, status_code=201)
def create_game(user_id: str, game: GameCreate, db: Session = Depends(get_db)):
    """
    Create a new game (host a game).
    """
    # Verify user exists
    user = db.query(User).filter(User.uid == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Verify venue exists
    venue = db.query(Venue).filter(Venue.id == game.venue_id).first()
    if not venue:
        raise HTTPException(status_code=404, detail="Venue not found")

    game_id = str(uuid.uuid4())

    db_game = Game(
        id=game_id,
        host_id=user_id,
        player_ids=[user_id],  # Host is automatically added
        current_players=1,
        **game.dict()
    )

    db.add(db_game)
    db.commit()
    db.refresh(db_game)

    return db_game


@router.get("/{game_id}", response_model=GameResponse)
def get_game(game_id: str, db: Session = Depends(get_db)):
    """
    Get game details by ID.
    """
    game = db.query(Game).filter(Game.id == game_id).first()

    if not game:
        raise HTTPException(status_code=404, detail="Game not found")

    return game


@router.get("/", response_model=List[GameResponse])
def list_games(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    sport: Optional[str] = None,
    status: Optional[GameStatus] = None,
    skill_level: Optional[SkillLevel] = None,
    game_type: Optional[GameType] = None,
    db: Session = Depends(get_db)
):
    """
    List games with filtering.
    """
    query = db.query(Game)

    if sport:
        query = query.filter(Game.sport == sport)

    if status:
        query = query.filter(Game.status == status)

    if skill_level:
        query = query.filter(Game.skill_level == skill_level)

    if game_type:
        query = query.filter(Game.game_type == game_type)

    # Order by date (upcoming games first)
    query = query.filter(Game.date >= datetime.utcnow()).order_by(Game.date.asc())
    games = query.offset(skip).limit(limit).all()

    return games


@router.post("/{game_id}/join/{user_id}")
def join_game(game_id: str, user_id: str, db: Session = Depends(get_db)):
    """
    Join a game.
    """
    game = db.query(Game).filter(Game.id == game_id).first()
    if not game:
        raise HTTPException(status_code=404, detail="Game not found")

    user = db.query(User).filter(User.uid == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Check if game is full
    if game.current_players >= game.max_players:
        raise HTTPException(status_code=400, detail="Game is full")

    # Check if already joined
    if user_id in game.player_ids:
        raise HTTPException(status_code=400, detail="Already joined this game")

    # Check if game is accepting players
    if game.status not in [GameStatus.upcoming]:
        raise HTTPException(status_code=400, detail="Cannot join this game")

    # Add player
    game.player_ids.append(user_id)
    game.current_players += 1

    # Update status if full
    if game.current_players >= game.max_players:
        game.status = GameStatus.full

    game.updated_at = datetime.utcnow()

    db.commit()
    db.refresh(game)

    return {"message": "Joined game successfully", "game": game}


@router.post("/{game_id}/leave/{user_id}")
def leave_game(game_id: str, user_id: str, db: Session = Depends(get_db)):
    """
    Leave a game.
    """
    game = db.query(Game).filter(Game.id == game_id).first()
    if not game:
        raise HTTPException(status_code=404, detail="Game not found")

    # Check if user is the host
    if game.host_id == user_id:
        raise HTTPException(status_code=400, detail="Host cannot leave the game. Cancel it instead.")

    # Check if user is in the game
    if user_id not in game.player_ids:
        raise HTTPException(status_code=400, detail="Not part of this game")

    # Remove player
    game.player_ids.remove(user_id)
    game.current_players -= 1

    # Update status
    if game.status == GameStatus.full:
        game.status = GameStatus.upcoming

    game.updated_at = datetime.utcnow()

    db.commit()

    return {"message": "Left game successfully"}


@router.put("/{game_id}", response_model=GameResponse)
def update_game(game_id: str, game_update: GameUpdate, db: Session = Depends(get_db)):
    """
    Update game details (host only).
    """
    game = db.query(Game).filter(Game.id == game_id).first()

    if not game:
        raise HTTPException(status_code=404, detail="Game not found")

    # Update only provided fields
    update_data = game_update.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(game, key, value)

    game.updated_at = datetime.utcnow()

    db.commit()
    db.refresh(game)

    return game


@router.delete("/{game_id}/{user_id}")
def cancel_game(game_id: str, user_id: str, db: Session = Depends(get_db)):
    """
    Cancel a game (host only).
    """
    game = db.query(Game).filter(Game.id == game_id).first()

    if not game:
        raise HTTPException(status_code=404, detail="Game not found")

    # Verify user is the host
    if game.host_id != user_id:
        raise HTTPException(status_code=403, detail="Only host can cancel the game")

    # Update status to cancelled
    game.status = GameStatus.cancelled
    game.updated_at = datetime.utcnow()

    db.commit()

    return {"message": "Game cancelled successfully", "game_id": game_id}


@router.get("/user/{user_id}", response_model=List[GameResponse])
def get_user_games(
    user_id: str,
    include_past: bool = False,
    db: Session = Depends(get_db)
):
    """
    Get all games a user is part of (hosting or joined).
    """
    query = db.query(Game).filter(
        (Game.host_id == user_id) | (Game.player_ids.contains([user_id]))
    )

    if not include_past:
        query = query.filter(Game.date >= datetime.utcnow())

    games = query.order_by(Game.date.asc()).all()

    return games
