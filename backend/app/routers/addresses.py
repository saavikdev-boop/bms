from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..core.database import get_db
from ..models import Address, User
from ..schemas.address import AddressCreate, AddressUpdate, AddressResponse
from uuid import uuid4

router = APIRouter()


@router.post("/{user_id}", response_model=AddressResponse, status_code=status.HTTP_201_CREATED)
def create_address(user_id: str, address: AddressCreate, db: Session = Depends(get_db)):
    # Check if user exists
    db_user = db.query(User).filter(User.uid == user_id).first()
    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    # If this is set as default, unset all other default addresses
    if address.is_default:
        db.query(Address).filter(Address.user_id == user_id).update({"is_default": False})

    db_address = Address(id=str(uuid4()), user_id=user_id, **address.dict())
    db.add(db_address)
    db.commit()
    db.refresh(db_address)
    return db_address


@router.get("/{user_id}", response_model=List[AddressResponse])
def list_user_addresses(user_id: str, db: Session = Depends(get_db)):
    addresses = db.query(Address).filter(Address.user_id == user_id).all()
    return addresses


@router.get("/{user_id}/{address_id}", response_model=AddressResponse)
def get_address(user_id: str, address_id: str, db: Session = Depends(get_db)):
    db_address = db.query(Address).filter(
        Address.id == address_id,
        Address.user_id == user_id
    ).first()
    if not db_address:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Address not found"
        )
    return db_address


@router.put("/{user_id}/{address_id}", response_model=AddressResponse)
def update_address(
    user_id: str,
    address_id: str,
    address_update: AddressUpdate,
    db: Session = Depends(get_db)
):
    db_address = db.query(Address).filter(
        Address.id == address_id,
        Address.user_id == user_id
    ).first()
    if not db_address:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Address not found"
        )

    update_data = address_update.dict(exclude_unset=True)

    # If setting as default, unset all other default addresses
    if update_data.get("is_default"):
        db.query(Address).filter(
            Address.user_id == user_id,
            Address.id != address_id
        ).update({"is_default": False})

    for field, value in update_data.items():
        setattr(db_address, field, value)

    db.commit()
    db.refresh(db_address)
    return db_address


@router.delete("/{user_id}/{address_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_address(user_id: str, address_id: str, db: Session = Depends(get_db)):
    db_address = db.query(Address).filter(
        Address.id == address_id,
        Address.user_id == user_id
    ).first()
    if not db_address:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Address not found"
        )

    db.delete(db_address)
    db.commit()
    return None
