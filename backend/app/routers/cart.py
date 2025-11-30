from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..core.database import get_db
from ..models import CartItem, User, Product
from ..schemas.cart import CartItemCreate, CartItemUpdate, CartItemResponse
from uuid import uuid4

router = APIRouter()


@router.post("/{user_id}", response_model=CartItemResponse, status_code=status.HTTP_201_CREATED)
def add_to_cart(user_id: str, cart_item: CartItemCreate, db: Session = Depends(get_db)):
    # Check if user exists
    db_user = db.query(User).filter(User.uid == user_id).first()
    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    # Check if product exists
    db_product = db.query(Product).filter(Product.id == cart_item.product_id).first()
    if not db_product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )

    # Check if item already in cart
    existing_item = db.query(CartItem).filter(
        CartItem.user_id == user_id,
        CartItem.product_id == cart_item.product_id,
        CartItem.size == cart_item.size
    ).first()

    if existing_item:
        # Update quantity
        existing_item.quantity += cart_item.quantity
        db.commit()
        db.refresh(existing_item)
        return existing_item

    # Create new cart item
    db_cart_item = CartItem(
        id=str(uuid4()),
        user_id=user_id,
        **cart_item.dict()
    )
    db.add(db_cart_item)
    db.commit()
    db.refresh(db_cart_item)
    return db_cart_item


@router.get("/{user_id}", response_model=List[CartItemResponse])
def get_cart(user_id: str, db: Session = Depends(get_db)):
    cart_items = db.query(CartItem).filter(CartItem.user_id == user_id).all()
    return cart_items


@router.put("/{user_id}/{cart_item_id}", response_model=CartItemResponse)
def update_cart_item(
    user_id: str,
    cart_item_id: str,
    cart_item_update: CartItemUpdate,
    db: Session = Depends(get_db)
):
    db_cart_item = db.query(CartItem).filter(
        CartItem.id == cart_item_id,
        CartItem.user_id == user_id
    ).first()
    if not db_cart_item:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Cart item not found"
        )

    update_data = cart_item_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_cart_item, field, value)

    db.commit()
    db.refresh(db_cart_item)
    return db_cart_item


@router.delete("/{user_id}/{cart_item_id}", status_code=status.HTTP_204_NO_CONTENT)
def remove_from_cart(user_id: str, cart_item_id: str, db: Session = Depends(get_db)):
    db_cart_item = db.query(CartItem).filter(
        CartItem.id == cart_item_id,
        CartItem.user_id == user_id
    ).first()
    if not db_cart_item:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Cart item not found"
        )

    db.delete(db_cart_item)
    db.commit()
    return None


@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
def clear_cart(user_id: str, db: Session = Depends(get_db)):
    db.query(CartItem).filter(CartItem.user_id == user_id).delete()
    db.commit()
    return None
