from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from ..core.database import get_db
from ..models import Booking, User
from ..schemas.booking import BookingCreate, BookingUpdate, BookingResponse
from uuid import uuid4

router = APIRouter()


@router.post("/{user_id}", response_model=BookingResponse, status_code=status.HTTP_201_CREATED)
def create_booking(user_id: str, booking: BookingCreate, db: Session = Depends(get_db)):
    # Check if user exists
    db_user = db.query(User).filter(User.uid == user_id).first()
    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    db_booking = Booking(id=str(uuid4()), user_id=user_id, **booking.dict())
    db.add(db_booking)
    db.commit()
    db.refresh(db_booking)
    return db_booking


@router.get("/{user_id}", response_model=List[BookingResponse])
def list_user_bookings(
    user_id: str,
    status_filter: Optional[str] = None,
    db: Session = Depends(get_db)
):
    query = db.query(Booking).filter(Booking.user_id == user_id)
    if status_filter:
        query = query.filter(Booking.status == status_filter)
    bookings = query.all()
    return bookings


@router.get("/{user_id}/{booking_id}", response_model=BookingResponse)
def get_booking(user_id: str, booking_id: str, db: Session = Depends(get_db)):
    db_booking = db.query(Booking).filter(
        Booking.id == booking_id,
        Booking.user_id == user_id
    ).first()
    if not db_booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )
    return db_booking


@router.put("/{user_id}/{booking_id}", response_model=BookingResponse)
def update_booking(
    user_id: str,
    booking_id: str,
    booking_update: BookingUpdate,
    db: Session = Depends(get_db)
):
    db_booking = db.query(Booking).filter(
        Booking.id == booking_id,
        Booking.user_id == user_id
    ).first()
    if not db_booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )

    update_data = booking_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_booking, field, value)

    db.commit()
    db.refresh(db_booking)
    return db_booking


@router.delete("/{user_id}/{booking_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_booking(user_id: str, booking_id: str, db: Session = Depends(get_db)):
    db_booking = db.query(Booking).filter(
        Booking.id == booking_id,
        Booking.user_id == user_id
    ).first()
    if not db_booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )

    db.delete(db_booking)
    db.commit()
    return None
