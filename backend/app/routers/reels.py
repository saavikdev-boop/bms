"""
Reels Management Router
Handles short-form video content (like Instagram Reels)
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime
import uuid

from ..core.database import get_db
from ..models.reel import Reel, ReelLike, ReelComment
from ..models.user import User
from ..schemas.reel import ReelCreate, ReelUpdate, ReelResponse, CommentCreate, CommentResponse

router = APIRouter()


@router.post("/{user_id}", response_model=ReelResponse, status_code=201)
def create_reel(user_id: str, reel: ReelCreate, db: Session = Depends(get_db)):
    """
    Create a new reel.
    """
    # Verify user exists
    user = db.query(User).filter(User.uid == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    reel_id = str(uuid.uuid4())

    db_reel = Reel(
        id=reel_id,
        user_id=user_id,
        **reel.dict()
    )

    db.add(db_reel)
    db.commit()
    db.refresh(db_reel)

    return db_reel


@router.get("/{reel_id}", response_model=ReelResponse)
def get_reel(reel_id: str, db: Session = Depends(get_db)):
    """
    Get reel by ID and increment view count.
    """
    reel = db.query(Reel).filter(Reel.id == reel_id).first()

    if not reel:
        raise HTTPException(status_code=404, detail="Reel not found")

    # Increment view count
    reel.views_count += 1
    db.commit()
    db.refresh(reel)

    return reel


@router.get("/", response_model=List[ReelResponse])
def list_reels(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    sport: Optional[str] = None,
    user_id: Optional[str] = None,
    is_public: bool = True,
    db: Session = Depends(get_db)
):
    """
    List reels with filtering (for feed).
    """
    query = db.query(Reel).filter(Reel.is_active == True)

    if sport:
        query = query.filter(Reel.sport == sport)

    if user_id:
        query = query.filter(Reel.user_id == user_id)

    if is_public:
        query = query.filter(Reel.is_public == True)

    # Order by created_at desc (most recent first)
    query = query.order_by(Reel.created_at.desc())
    reels = query.offset(skip).limit(limit).all()

    return reels


@router.get("/user/{user_id}", response_model=List[ReelResponse])
def get_user_reels(user_id: str, db: Session = Depends(get_db)):
    """
    Get all reels by a specific user.
    """
    reels = db.query(Reel).filter(
        Reel.user_id == user_id,
        Reel.is_active == True
    ).order_by(Reel.created_at.desc()).all()

    return reels


@router.put("/{reel_id}", response_model=ReelResponse)
def update_reel(reel_id: str, reel_update: ReelUpdate, db: Session = Depends(get_db)):
    """
    Update reel details.
    """
    reel = db.query(Reel).filter(Reel.id == reel_id).first()

    if not reel:
        raise HTTPException(status_code=404, detail="Reel not found")

    # Update only provided fields
    update_data = reel_update.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(reel, key, value)

    reel.updated_at = datetime.utcnow()

    db.commit()
    db.refresh(reel)

    return reel


@router.delete("/{reel_id}/{user_id}")
def delete_reel(reel_id: str, user_id: str, db: Session = Depends(get_db)):
    """
    Delete a reel (soft delete).
    """
    reel = db.query(Reel).filter(Reel.id == reel_id).first()

    if not reel:
        raise HTTPException(status_code=404, detail="Reel not found")

    # Verify ownership
    if reel.user_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this reel")

    # Soft delete
    reel.is_active = False
    db.commit()

    return {"message": "Reel deleted successfully", "reel_id": reel_id}


# --- Like endpoints ---

@router.post("/{reel_id}/like/{user_id}")
def like_reel(reel_id: str, user_id: str, db: Session = Depends(get_db)):
    """
    Like a reel.
    """
    reel = db.query(Reel).filter(Reel.id == reel_id).first()
    if not reel:
        raise HTTPException(status_code=404, detail="Reel not found")

    # Check if already liked
    existing_like = db.query(ReelLike).filter(
        ReelLike.reel_id == reel_id,
        ReelLike.user_id == user_id
    ).first()

    if existing_like:
        raise HTTPException(status_code=400, detail="Already liked")

    # Create like
    like = ReelLike(
        id=str(uuid.uuid4()),
        reel_id=reel_id,
        user_id=user_id
    )

    db.add(like)

    # Increment like count
    reel.likes_count += 1

    db.commit()

    return {"message": "Reel liked successfully", "likes_count": reel.likes_count}


@router.delete("/{reel_id}/like/{user_id}")
def unlike_reel(reel_id: str, user_id: str, db: Session = Depends(get_db)):
    """
    Unlike a reel.
    """
    like = db.query(ReelLike).filter(
        ReelLike.reel_id == reel_id,
        ReelLike.user_id == user_id
    ).first()

    if not like:
        raise HTTPException(status_code=404, detail="Like not found")

    reel = db.query(Reel).filter(Reel.id == reel_id).first()

    # Delete like
    db.delete(like)

    # Decrement like count
    if reel:
        reel.likes_count = max(0, reel.likes_count - 1)

    db.commit()

    return {"message": "Reel unliked successfully"}


# --- Comment endpoints ---

@router.post("/{reel_id}/comments/{user_id}", response_model=CommentResponse, status_code=201)
def create_comment(reel_id: str, user_id: str, comment: CommentCreate, db: Session = Depends(get_db)):
    """
    Add a comment to a reel.
    """
    reel = db.query(Reel).filter(Reel.id == reel_id).first()
    if not reel:
        raise HTTPException(status_code=404, detail="Reel not found")

    comment_id = str(uuid.uuid4())

    db_comment = ReelComment(
        id=comment_id,
        reel_id=reel_id,
        user_id=user_id,
        text=comment.text
    )

    db.add(db_comment)

    # Increment comment count
    reel.comments_count += 1

    db.commit()
    db.refresh(db_comment)

    return db_comment


@router.get("/{reel_id}/comments", response_model=List[CommentResponse])
def get_comments(reel_id: str, skip: int = 0, limit: int = 50, db: Session = Depends(get_db)):
    """
    Get comments for a reel.
    """
    comments = db.query(ReelComment).filter(
        ReelComment.reel_id == reel_id
    ).order_by(ReelComment.created_at.desc()).offset(skip).limit(limit).all()

    return comments


@router.delete("/{reel_id}/comments/{comment_id}/{user_id}")
def delete_comment(reel_id: str, comment_id: str, user_id: str, db: Session = Depends(get_db)):
    """
    Delete a comment.
    """
    comment = db.query(ReelComment).filter(ReelComment.id == comment_id).first()

    if not comment:
        raise HTTPException(status_code=404, detail="Comment not found")

    # Verify ownership
    if comment.user_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this comment")

    reel = db.query(Reel).filter(Reel.id == reel_id).first()

    # Delete comment
    db.delete(comment)

    # Decrement comment count
    if reel:
        reel.comments_count = max(0, reel.comments_count - 1)

    db.commit()

    return {"message": "Comment deleted successfully"}


@router.post("/{reel_id}/share/{user_id}")
def share_reel(reel_id: str, user_id: str, db: Session = Depends(get_db)):
    """
    Increment share count when a reel is shared.
    """
    reel = db.query(Reel).filter(Reel.id == reel_id).first()

    if not reel:
        raise HTTPException(status_code=404, detail="Reel not found")

    # Increment share count
    reel.shares_count += 1

    db.commit()

    return {"message": "Reel shared successfully", "shares_count": reel.shares_count}
