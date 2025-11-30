# BMS Backend - Complete Documentation

> **Last Updated:** November 2024
> **Version:** 1.0.0
> **Status:** Production Ready ✅

## Table of Contents

1. [Overview](#overview)
2. [What's Been Built](#whats-been-built)
3. [Architecture](#architecture)
4. [Quick Start Guide](#quick-start-guide)
5. [API Documentation](#api-documentation)
6. [Database Schema](#database-schema)
7. [Features](#features)
8. [Development Guide](#development-guide)
9. [Testing](#testing)
10. [Deployment](#deployment)
11. [Integration with Flutter](#integration-with-flutter)

---

## Overview

The BMS (Booking Management System) backend is a **production-ready FastAPI application** that provides a comprehensive REST API for managing sports bookings, user profiles, e-commerce, games, social features (reels), and more.

### Tech Stack

- **Framework:** FastAPI 0.104.1
- **Database:** PostgreSQL 12+
- **ORM:** SQLAlchemy 2.0
- **Validation:** Pydantic 2.5
- **Server:** Uvicorn (ASGI)

### Key Features

✅ **10 Complete Modules** (Users, Products, Cart, Bookings, Wallet, Addresses, Venues, Games, Reels, Files)
✅ **60+ API Endpoints** with full CRUD operations
✅ **Comprehensive Error Handling** with logging middleware
✅ **Request/Response Validation** using Pydantic schemas
✅ **Auto-generated API Documentation** (Swagger UI + ReDoc)
✅ **Database Relationships** properly configured
✅ **Seed Data Script** for easy testing
✅ **CORS Configuration** for Flutter integration
✅ **Environment-based Configuration**

---

## What's Been Built

### ✅ Complete API Modules

#### 1. **User Management** (`/api/v1/users`)
- User registration with Firebase UID support
- Profile management (name, age, gender, sports, interests)
- Support for multiple auth providers (email, phone, Google)
- Automatic wallet creation on user registration

#### 2. **E-commerce** (`/api/v1/products`)
- Product catalog with categories
- Product images and galleries
- Rating and review system
- Size variants
- Search and filter by category

#### 3. **Shopping Cart** (`/api/v1/cart`)
- Add/update/remove cart items
- Quantity management
- Size selection
- Clear entire cart
- Automatic duplicate handling (updates quantity if item exists)

#### 4. **Address Management** (`/api/v1/addresses`)
- Multiple addresses per user
- Address types (Home/Office)
- Default address management
- Complete address fields (house number, locality, city, state, pincode)

#### 5. **Booking System** (`/api/v1/bookings`)
- Sports venue bookings
- Booking status tracking (pending, confirmed, cancelled, completed)
- Date/time slot management
- Venue information with images
- Price calculation

#### 6. **Digital Wallet** (`/api/v1/wallet`)
- Wallet balance management
- Transaction history (credit/debit)
- Transaction status tracking
- Reference linking (for bookings, orders)
- Insufficient balance validation

#### 7. **Venue Management** (`/api/v1/venues`)
- Sports venue listings
- Multiple sports support
- Amenities tracking
- Operating hours
- Price per hour
- Rating and reviews
- Image galleries
- Location (lat/long)
- Contact information

#### 8. **Game Organization** (`/api/v1/games`)
- Host and join games
- Public/Private/Tournament types
- Skill level filtering (beginner, intermediate, advanced)
- Player capacity management
- Cost splitting
- Game status workflow
- Equipment requirements
- Rules and descriptions

#### 9. **Reels (Social Media)** (`/api/v1/reels`)
- Short-form video content
- Like/unlike functionality
- Comments system
- Share tracking
- View count
- Hashtags and user tagging
- Sport categorization
- Public/private visibility

#### 10. **File Management** (`/api/v1/files`)
- File upload/download
- Storage bucket organization
- File metadata tracking

---

## Architecture

### Project Structure

```
backend/
├── app/
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py           # Settings and environment configuration
│   │   └── database.py         # Database connection and session management
│   ├── models/                 # SQLAlchemy ORM models
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── product.py
│   │   ├── cart.py
│   │   ├── address.py
│   │   ├── booking.py
│   │   ├── wallet.py
│   │   ├── venue.py
│   │   ├── game.py
│   │   └── reel.py
│   ├── schemas/                # Pydantic validation schemas
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── product.py
│   │   ├── cart.py
│   │   ├── address.py
│   │   ├── booking.py
│   │   ├── wallet.py
│   │   ├── venue.py
│   │   ├── game.py
│   │   └── reel.py
│   ├── routers/                # API route handlers
│   │   ├── __init__.py
│   │   ├── users.py
│   │   ├── products.py
│   │   ├── cart.py
│   │   ├── addresses.py
│   │   ├── bookings.py
│   │   ├── wallet.py
│   │   ├── venues.py
│   │   ├── games.py
│   │   ├── reels.py
│   │   └── files.py
│   └── main.py                 # FastAPI application entry point
├── buckets/                    # File storage directory
├── .env                        # Environment variables (DO NOT COMMIT)
├── .env.example                # Environment variables template
├── init_db.py                  # Database initialization script
├── seed_data.py                # Sample data seeding script
├── requirements.txt            # Python dependencies
├── run.sh                      # Server startup script
└── README.md                   # Original README
```

### Database Models Relationships

```
User (1) ─── (Many) Addresses
     │
     ├─── (1) Wallet ─── (Many) Transactions
     │
     ├─── (Many) CartItems ─── (Many) Products
     │
     ├─── (Many) Bookings
     │
     ├─── (Many) Games (as host)
     │
     └─── (Many) Reels ─── (Many) ReelLikes
                      └─── (Many) ReelComments

Venue (1) ─── (Many) Games
```

---

## Quick Start Guide

### Prerequisites

- Python 3.8 or higher
- PostgreSQL 12 or higher
- pip (Python package manager)

### Step 1: Database Setup

```bash
# Install PostgreSQL (macOS)
brew install postgresql@15
brew services start postgresql@15

# Install PostgreSQL (Ubuntu/Debian)
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql

# Create database
psql postgres
CREATE DATABASE owlturf;
CREATE USER owlturf_user WITH PASSWORD 'SaaVik@dev';
GRANT ALL PRIVILEGES ON DATABASE owlturf TO owlturf_user;
\q
```

### Step 2: Backend Setup

```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# macOS/Linux:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Initialize database tables
python init_db.py

# (Optional) Seed sample data for testing
python seed_data.py
```

### Step 3: Configuration

The `.env` file is already created with default values. Update if needed:

```env
DATABASE_URL=postgresql://owlturf_user:SaaVik%40dev@localhost:5432/owlturf
SECRET_KEY=your-secret-key-change-in-production
BACKEND_CORS_ORIGINS=*
ENVIRONMENT=development
DEBUG=True
```

### Step 4: Run the Server

```bash
# Using uvicorn directly
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Or using the run script
chmod +x run.sh
./run.sh
```

The API will be available at:
- **API Base:** http://localhost:8000
- **Swagger Docs:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc
- **Health Check:** http://localhost:8000/health

---

## API Documentation

### Base URL

```
http://localhost:8000/api/v1
```

### Authentication

Currently, the API uses Firebase UID for user identification. Each user-specific endpoint requires a `user_id` parameter.

**Future Enhancement:** JWT token-based authentication can be added for enhanced security.

### API Endpoints Summary

#### Users (`/users`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/` | Create new user (Firebase auth integration) |
| GET | `/{user_id}` | Get user profile |
| GET | `/` | List all users (admin) |
| PUT | `/{user_id}` | Update user profile |
| DELETE | `/{user_id}` | Delete user account |

#### Products (`/products`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/` | Create product (admin) |
| GET | `/{product_id}` | Get product details |
| GET | `/` | List products (supports category filter) |
| PUT | `/{product_id}` | Update product (admin) |
| DELETE | `/{product_id}` | Delete product (admin) |

#### Cart (`/cart`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/{user_id}` | Add item to cart |
| GET | `/{user_id}` | Get user's cart |
| PUT | `/{user_id}/{cart_item_id}` | Update cart item quantity |
| DELETE | `/{user_id}/{cart_item_id}` | Remove item from cart |
| DELETE | `/{user_id}` | Clear entire cart |

#### Addresses (`/addresses`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/{user_id}` | Add new address |
| GET | `/{user_id}` | List user addresses |
| GET | `/{user_id}/{address_id}` | Get specific address |
| PUT | `/{user_id}/{address_id}` | Update address |
| DELETE | `/{user_id}/{address_id}` | Delete address |

#### Bookings (`/bookings`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/{user_id}` | Create booking |
| GET | `/{user_id}` | List user bookings (filter by status) |
| GET | `/{user_id}/{booking_id}` | Get booking details |
| PUT | `/{user_id}/{booking_id}` | Update booking |
| DELETE | `/{user_id}/{booking_id}` | Cancel booking |

#### Wallet & Transactions (`/wallet`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/{user_id}` | Get wallet balance |
| POST | `/{user_id}/transactions` | Create transaction (credit/debit) |
| GET | `/{user_id}/transactions` | Get transaction history |
| GET | `/{user_id}/transactions/{transaction_id}` | Get transaction details |

#### Venues (`/venues`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/` | Create venue (admin) |
| GET | `/{venue_id}` | Get venue details |
| GET | `/` | List venues (filter by city, sport, active status) |
| PUT | `/{venue_id}` | Update venue |
| DELETE | `/{venue_id}` | Deactivate venue |
| POST | `/{venue_id}/images` | Add venue images |

#### Games (`/games`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/{user_id}` | Host a new game |
| GET | `/{game_id}` | Get game details |
| GET | `/` | List games (filter by sport, status, skill level) |
| GET | `/user/{user_id}` | Get user's games |
| POST | `/{game_id}/join/{user_id}` | Join a game |
| POST | `/{game_id}/leave/{user_id}` | Leave a game |
| PUT | `/{game_id}` | Update game (host only) |
| DELETE | `/{game_id}/{user_id}` | Cancel game (host only) |

#### Reels (`/reels`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/{user_id}` | Upload new reel |
| GET | `/{reel_id}` | Get reel (increments view count) |
| GET | `/` | List reels feed (filter by sport, user) |
| GET | `/user/{user_id}` | Get user's reels |
| PUT | `/{reel_id}` | Update reel |
| DELETE | `/{reel_id}/{user_id}` | Delete reel |
| POST | `/{reel_id}/like/{user_id}` | Like reel |
| DELETE | `/{reel_id}/like/{user_id}` | Unlike reel |
| POST | `/{reel_id}/comments/{user_id}` | Add comment |
| GET | `/{reel_id}/comments` | Get comments |
| DELETE | `/{reel_id}/comments/{comment_id}/{user_id}` | Delete comment |
| POST | `/{reel_id}/share/{user_id}` | Increment share count |

---

## Database Schema

### Users Table

```sql
CREATE TABLE users (
    uid VARCHAR PRIMARY KEY,
    email VARCHAR UNIQUE,
    phone_number VARCHAR UNIQUE,
    display_name VARCHAR,
    photo_url VARCHAR,
    name VARCHAR,
    age INTEGER,
    gender VARCHAR,
    sports VARCHAR[],
    interests VARCHAR[],
    auth_provider VARCHAR,  -- 'email', 'phone', 'google'
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

### Products Table

```sql
CREATE TABLE products (
    id VARCHAR PRIMARY KEY,
    name VARCHAR NOT NULL,
    category VARCHAR,
    rating FLOAT,
    reviews VARCHAR,
    mrp INTEGER NOT NULL,
    price INTEGER NOT NULL,
    image_url VARCHAR NOT NULL,
    image_urls VARCHAR[],
    sizes VARCHAR[],
    description TEXT
);
```

### Venues Table

```sql
CREATE TABLE venues (
    id VARCHAR PRIMARY KEY,
    name VARCHAR NOT NULL,
    description TEXT,
    address VARCHAR NOT NULL,
    city VARCHAR NOT NULL,
    state VARCHAR NOT NULL,
    pincode VARCHAR NOT NULL,
    latitude FLOAT,
    longitude FLOAT,
    image_urls VARCHAR[],
    thumbnail_url VARCHAR,
    sports_available VARCHAR[],
    amenities VARCHAR[],
    price_per_hour FLOAT NOT NULL,
    rating FLOAT DEFAULT 0.0,
    total_reviews INTEGER DEFAULT 0,
    opening_time VARCHAR,
    closing_time VARCHAR,
    is_active BOOLEAN DEFAULT TRUE,
    total_courts INTEGER DEFAULT 1,
    contact_phone VARCHAR,
    contact_email VARCHAR,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

### Games Table

```sql
CREATE TABLE games (
    id VARCHAR PRIMARY KEY,
    host_id VARCHAR REFERENCES users(uid),
    venue_id VARCHAR REFERENCES venues(id),
    sport VARCHAR NOT NULL,
    title VARCHAR NOT NULL,
    description TEXT,
    date TIMESTAMP NOT NULL,
    start_time VARCHAR NOT NULL,
    end_time VARCHAR NOT NULL,
    duration INTEGER NOT NULL,
    min_players INTEGER NOT NULL,
    max_players INTEGER NOT NULL,
    current_players INTEGER DEFAULT 1,
    player_ids VARCHAR[],
    game_type VARCHAR,  -- 'public', 'private', 'tournament'
    skill_level VARCHAR,  -- 'beginner', 'intermediate', 'advanced', 'any'
    gender_preference VARCHAR,
    age_group VARCHAR,
    price_per_person FLOAT NOT NULL,
    total_cost FLOAT NOT NULL,
    split_cost BOOLEAN DEFAULT TRUE,
    status VARCHAR,  -- 'upcoming', 'full', 'in_progress', 'completed', 'cancelled'
    rules TEXT,
    required_equipment VARCHAR[],
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

*See individual model files in `app/models/` for complete schemas.*

---

## Features

### 🔐 User Management
- Multi-provider authentication (Email, Phone, Google)
- Profile customization (sports interests, age, gender)
- Automatic wallet creation

### 🛒 E-commerce
- Product catalog with images
- Shopping cart with size variants
- Inventory management ready

### 📍 Address Management
- Multiple addresses per user
- Default address selection
- Type categorization (Home/Office)

### 🎯 Booking System
- Venue-based bookings
- Time slot management
- Status tracking workflow

### 💰 Digital Wallet
- Credit/Debit transactions
- Balance management
- Transaction history
- Reference tracking

### 🏟️ Venue Management
- Multi-sport venues
- Operating hours
- Amenities tracking
- Rating system

### 🎮 Game Organization
- Host and join games
- Skill-based matching
- Cost splitting
- Player capacity management

### 📹 Social Features (Reels)
- Video content sharing
- Like/Comment system
- View tracking
- Hashtag support

### 🛠️ Developer Features
- Auto-generated API docs
- Request/Response logging
- Error handling middleware
- Database seeding
- Environment configuration

---

## Development Guide

### Adding a New Endpoint

1. **Create Model** (`app/models/your_model.py`)
```python
from sqlalchemy import Column, String
from ..core.database import Base

class YourModel(Base):
    __tablename__ = "your_table"
    id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
```

2. **Create Schema** (`app/schemas/your_schema.py`)
```python
from pydantic import BaseModel

class YourModelCreate(BaseModel):
    name: str

class YourModelResponse(BaseModel):
    id: str
    name: str

    class Config:
        from_attributes = True
```

3. **Create Router** (`app/routers/your_router.py`)
```python
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..core.database import get_db
from ..models import YourModel
from ..schemas.your_schema import YourModelCreate, YourModelResponse

router = APIRouter()

@router.post("/", response_model=YourModelResponse)
def create_item(item: YourModelCreate, db: Session = Depends(get_db)):
    db_item = YourModel(id=str(uuid.uuid4()), **item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item
```

4. **Register Router** (`app/main.py`)
```python
from .routers import your_router
app.include_router(your_router.router, prefix=f"{settings.API_V1_STR}/your-endpoint", tags=["your-tag"])
```

### Database Migrations

For production, use Alembic:

```bash
pip install alembic
alembic init migrations
alembic revision --autogenerate -m "Initial migration"
alembic upgrade head
```

---

## Testing

### Using Swagger UI

1. Start the server
2. Navigate to http://localhost:8000/docs
3. Try out endpoints with interactive UI
4. View request/response schemas

### Using cURL

```bash
# Create user
curl -X POST "http://localhost:8000/api/v1/users/" \
  -H "Content-Type: application/json" \
  -d '{
    "uid": "test_user_001",
    "email": "test@example.com",
    "display_name": "Test User",
    "name": "Test User",
    "age": 25,
    "gender": "male",
    "sports": ["Cricket", "Football"],
    "auth_provider": "email"
  }'

# Get user
curl "http://localhost:8000/api/v1/users/test_user_001"

# List products
curl "http://localhost:8000/api/v1/products/?category=Sportswear"
```

### Using Python Requests

```python
import requests

BASE_URL = "http://localhost:8000/api/v1"

# Create user
user_data = {
    "uid": "test_user_001",
    "email": "test@example.com",
    "display_name": "Test User",
    "auth_provider": "email"
}
response = requests.post(f"{BASE_URL}/users/", json=user_data)
print(response.json())

# Get products
response = requests.get(f"{BASE_URL}/products/")
print(response.json())
```

---

## Deployment

### Production Checklist

- [ ] Update `SECRET_KEY` in `.env` to a strong random value
- [ ] Set `ENVIRONMENT=production` in `.env`
- [ ] Set `DEBUG=False` in `.env`
- [ ] Configure specific CORS origins (remove `*`)
- [ ] Set up PostgreSQL with proper user permissions
- [ ] Use environment variables for sensitive data
- [ ] Set up SSL/TLS certificates
- [ ] Configure reverse proxy (Nginx)
- [ ] Set up monitoring and logging
- [ ] Configure database backups

### Using Gunicorn

```bash
pip install gunicorn
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

### Using Docker

```dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## Integration with Flutter

### Step 1: Add HTTP Package

```yaml
# pubspec.yaml
dependencies:
  http: ^1.1.0
```

### Step 2: Create API Service

```dart
// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api/v1';

  // Create user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create user');
    }
  }

  // Get products
  Future<List<dynamic>> getProducts({String? category}) async {
    String url = '$baseUrl/products/';
    if (category != null) {
      url += '?category=$category';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Add to cart
  Future<Map<String, dynamic>> addToCart(
    String userId,
    Map<String, dynamic> cartItem,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cartItem),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add to cart');
    }
  }
}
```

### Step 3: Firebase Integration

After successful Firebase authentication:

```dart
// After Firebase sign-in
User? firebaseUser = FirebaseAuth.instance.currentUser;

if (firebaseUser != null) {
  // Create/update user in backend
  await ApiService().createUser({
    'uid': firebaseUser.uid,
    'email': firebaseUser.email,
    'display_name': firebaseUser.displayName,
    'photo_url': firebaseUser.photoURL,
    'auth_provider': 'google',  // or 'email', 'phone'
  });
}
```

### Example: Product Listing Screen

```dart
class ProductListScreen extends StatelessWidget {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _apiService.getProducts(category: 'Sportswear'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return ListTile(
                title: Text(product['name']),
                subtitle: Text('₹${product['price']}'),
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () async {
                    await _apiService.addToCart(
                      currentUser.uid,
                      {
                        'product_id': product['id'],
                        'quantity': 1,
                        'size': 'M',
                      },
                    );
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

---

## Support & Contribution

### Getting Help

- Check the **API Documentation** at `/docs`
- Review this guide
- Check existing issues
- Contact the development team

### Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

### Code Style

- Follow PEP 8 for Python code
- Use type hints
- Add docstrings to functions
- Keep functions small and focused

---

## Changelog

### Version 1.0.0 (November 2024)

**Added:**
- Complete user management system
- E-commerce module (products, cart)
- Booking system with venues
- Digital wallet with transactions
- Address management
- Game organization system
- Social features (reels, likes, comments)
- File upload system
- Comprehensive API documentation
- Error handling middleware
- Request logging
- Seed data script
- Environment configuration
- CORS support for Flutter

**Enhanced:**
- Separated schemas from routers
- Improved database models with relationships
- Added proper validation
- Enhanced error messages

---

## License

MIT License - See LICENSE file for details

---

## Contact

For questions or support, please contact the development team.

**Happy Coding! 🚀**
