from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..core.database import get_db
from ..models import Wallet, Transaction, User, TransactionStatus
from ..schemas.wallet import WalletResponse, TransactionCreate, TransactionResponse
from uuid import uuid4

router = APIRouter()


@router.get("/{user_id}", response_model=WalletResponse)
def get_wallet(user_id: str, db: Session = Depends(get_db)):
    # Check if user exists
    db_user = db.query(User).filter(User.uid == user_id).first()
    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    db_wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not db_wallet:
        # Create wallet if it doesn't exist
        db_wallet = Wallet(id=str(uuid4()), user_id=user_id, balance=0.0)
        db.add(db_wallet)
        db.commit()
        db.refresh(db_wallet)

    return db_wallet


@router.post("/{user_id}/transactions", response_model=TransactionResponse, status_code=status.HTTP_201_CREATED)
def create_transaction(user_id: str, transaction: TransactionCreate, db: Session = Depends(get_db)):
    # Get wallet
    db_wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not db_wallet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Wallet not found"
        )

    # Create transaction
    db_transaction = Transaction(
        id=str(uuid4()),
        wallet_id=db_wallet.id,
        **transaction.dict()
    )

    # Update wallet balance
    if transaction.type == "credit":
        db_wallet.balance += transaction.amount
    else:  # debit
        if db_wallet.balance < transaction.amount:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Insufficient balance"
            )
        db_wallet.balance -= transaction.amount

    # Mark transaction as success
    db_transaction.status = TransactionStatus.success

    db.add(db_transaction)
    db.commit()
    db.refresh(db_transaction)
    return db_transaction


@router.get("/{user_id}/transactions", response_model=List[TransactionResponse])
def get_transactions(
    user_id: str,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    db_wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not db_wallet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Wallet not found"
        )

    transactions = db.query(Transaction).filter(
        Transaction.wallet_id == db_wallet.id
    ).order_by(Transaction.created_at.desc()).offset(skip).limit(limit).all()

    return transactions


@router.get("/{user_id}/transactions/{transaction_id}", response_model=TransactionResponse)
def get_transaction(user_id: str, transaction_id: str, db: Session = Depends(get_db)):
    db_wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not db_wallet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Wallet not found"
        )

    db_transaction = db.query(Transaction).filter(
        Transaction.id == transaction_id,
        Transaction.wallet_id == db_wallet.id
    ).first()
    if not db_transaction:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Transaction not found"
        )

    return db_transaction
