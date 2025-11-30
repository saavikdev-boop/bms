"""
Database initialization script
Run this to create all tables in the database
"""
from app.core.database import Base, engine
from app.models import (
    User, Product, Address, CartItem,
    Booking, Wallet, Transaction
)

def init_db():
    print("Creating database tables...")
    Base.metadata.create_all(bind=engine)
    print("Database tables created successfully!")

if __name__ == "__main__":
    init_db()
