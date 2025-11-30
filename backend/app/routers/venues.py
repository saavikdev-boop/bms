"""
Venue Management Router
Handles CRUD operations for sports venues
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime
import uuid

from ..core.database import get_db
from ..models.venue import Venue
from ..schemas.venue import VenueCreate, VenueUpdate, VenueResponse

router = APIRouter()


@router.post("/", response_model=VenueResponse, status_code=201)
def create_venue(venue: VenueCreate, db: Session = Depends(get_db)):
    """
    Create a new venue.
    """
    venue_id = str(uuid.uuid4())

    db_venue = Venue(
        id=venue_id,
        **venue.dict()
    )

    db.add(db_venue)
    db.commit()
    db.refresh(db_venue)

    return db_venue


@router.get("/{venue_id}", response_model=VenueResponse)
def get_venue(venue_id: str, db: Session = Depends(get_db)):
    """
    Get venue by ID.
    """
    venue = db.query(Venue).filter(Venue.id == venue_id).first()

    if not venue:
        raise HTTPException(status_code=404, detail="Venue not found")

    return venue


@router.get("/", response_model=List[VenueResponse])
def list_venues(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    city: Optional[str] = None,
    sport: Optional[str] = None,
    is_active: bool = True,
    db: Session = Depends(get_db)
):
    """
    List venues with filtering.
    """
    query = db.query(Venue)

    if city:
        query = query.filter(Venue.city.ilike(f"%{city}%"))

    if sport:
        query = query.filter(Venue.sports_available.contains([sport]))

    if is_active is not None:
        query = query.filter(Venue.is_active == is_active)

    query = query.order_by(Venue.rating.desc())
    venues = query.offset(skip).limit(limit).all()

    return venues


@router.put("/{venue_id}", response_model=VenueResponse)
def update_venue(venue_id: str, venue_update: VenueUpdate, db: Session = Depends(get_db)):
    """
    Update venue details.
    """
    venue = db.query(Venue).filter(Venue.id == venue_id).first()

    if not venue:
        raise HTTPException(status_code=404, detail="Venue not found")

    # Update only provided fields
    update_data = venue_update.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(venue, key, value)

    venue.updated_at = datetime.utcnow()

    db.commit()
    db.refresh(venue)

    return venue


@router.delete("/{venue_id}")
def delete_venue(venue_id: str, db: Session = Depends(get_db)):
    """
    Delete a venue (soft delete by setting is_active=False).
    """
    venue = db.query(Venue).filter(Venue.id == venue_id).first()

    if not venue:
        raise HTTPException(status_code=404, detail="Venue not found")

    # Soft delete
    venue.is_active = False
    db.commit()

    return {"message": "Venue deactivated successfully", "venue_id": venue_id}


@router.post("/{venue_id}/images")
def add_venue_images(venue_id: str, image_urls: List[str], db: Session = Depends(get_db)):
    """
    Add images to a venue.
    """
    venue = db.query(Venue).filter(Venue.id == venue_id).first()

    if not venue:
        raise HTTPException(status_code=404, detail="Venue not found")

    # Append new images to existing list
    venue.image_urls = venue.image_urls + image_urls

    # Set first image as thumbnail if not set
    if not venue.thumbnail_url and image_urls:
        venue.thumbnail_url = image_urls[0]

    db.commit()
    db.refresh(venue)

    return {"message": "Images added successfully", "image_urls": venue.image_urls}
