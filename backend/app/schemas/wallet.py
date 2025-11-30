from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from ..models.wallet import TransactionType, TransactionStatus


class WalletResponse(BaseModel):
    id: str
    user_id: str
    balance: float
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class TransactionBase(BaseModel):
    amount: float
    type: TransactionType
    description: Optional[str] = None
    reference_id: Optional[str] = None


class TransactionCreate(TransactionBase):
    pass


class TransactionResponse(TransactionBase):
    id: str
    wallet_id: str
    status: TransactionStatus
    created_at: datetime

    class Config:
        from_attributes = True
