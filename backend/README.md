# BMS Backend API

FastAPI-based backend server for the BMS (Booking Management System) Flutter app with PostgreSQL database.

## Features

- **User Management**: User registration, profile management, authentication
- **Products & E-commerce**: Product catalog, cart management
- **Addresses**: User address management with default address support
- **Bookings**: Sports venue booking system
- **Wallet & Transactions**: Digital wallet with transaction history

## Tech Stack

- **FastAPI**: Modern Python web framework
- **PostgreSQL**: Relational database
- **SQLAlchemy**: ORM for database interactions
- **Pydantic**: Data validation and settings management

## Setup

### Prerequisites

- Python 3.8+
- PostgreSQL 12+

### 1. Install PostgreSQL

#### macOS (using Homebrew)
```bash
brew install postgresql@14
brew services start postgresql@14
```

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

### 2. Create Database

```bash
# Login to PostgreSQL
psql postgres

# Create database and user
CREATE DATABASE bms_db;
CREATE USER bms_user WITH PASSWORD 'bms_password';
GRANT ALL PRIVILEGES ON DATABASE bms_db TO bms_user;

# Exit psql
\q
```

### 3. Install Python Dependencies

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 4. Configure Environment (Optional)

Create a `.env` file in the `backend` directory to override default settings:

```env
DATABASE_URL=postgresql://bms_user:bms_password@localhost:5432/bms_db
SECRET_KEY=your-secret-key-here
```

### 5. Initialize Database Tables

```bash
python init_db.py
```

### 6. Run the Server

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at `http://localhost:8000`

## API Documentation

Once the server is running, visit:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## API Endpoints

### Users
- `POST /api/v1/users/` - Create user
- `GET /api/v1/users/{user_id}` - Get user
- `GET /api/v1/users/` - List users
- `PUT /api/v1/users/{user_id}` - Update user
- `DELETE /api/v1/users/{user_id}` - Delete user

### Products
- `POST /api/v1/products/` - Create product
- `GET /api/v1/products/{product_id}` - Get product
- `GET /api/v1/products/` - List products (supports category filter)
- `PUT /api/v1/products/{product_id}` - Update product
- `DELETE /api/v1/products/{product_id}` - Delete product

### Addresses
- `POST /api/v1/addresses/{user_id}` - Create address
- `GET /api/v1/addresses/{user_id}` - List user addresses
- `GET /api/v1/addresses/{user_id}/{address_id}` - Get address
- `PUT /api/v1/addresses/{user_id}/{address_id}` - Update address
- `DELETE /api/v1/addresses/{user_id}/{address_id}` - Delete address

### Cart
- `POST /api/v1/cart/{user_id}` - Add item to cart
- `GET /api/v1/cart/{user_id}` - Get cart items
- `PUT /api/v1/cart/{user_id}/{cart_item_id}` - Update cart item
- `DELETE /api/v1/cart/{user_id}/{cart_item_id}` - Remove cart item
- `DELETE /api/v1/cart/{user_id}` - Clear cart

### Bookings
- `POST /api/v1/bookings/{user_id}` - Create booking
- `GET /api/v1/bookings/{user_id}` - List user bookings (supports status filter)
- `GET /api/v1/bookings/{user_id}/{booking_id}` - Get booking
- `PUT /api/v1/bookings/{user_id}/{booking_id}` - Update booking
- `DELETE /api/v1/bookings/{user_id}/{booking_id}` - Delete booking

### Wallet & Transactions
- `GET /api/v1/wallet/{user_id}` - Get wallet
- `POST /api/v1/wallet/{user_id}/transactions` - Create transaction
- `GET /api/v1/wallet/{user_id}/transactions` - Get transaction history
- `GET /api/v1/wallet/{user_id}/transactions/{transaction_id}` - Get transaction

## Database Schema

### Users Table
- uid (PK)
- email (unique)
- display_name
- photo_url
- name
- age
- gender
- sports (array)
- interests (array)
- created_at
- updated_at

### Products Table
- id (PK)
- name
- category
- rating
- reviews
- mrp
- price
- image_url
- sizes (array)
- description

### Addresses Table
- id (PK)
- user_id (FK)
- name
- mobile
- pincode
- house_number
- address
- locality
- city
- state
- type (enum: home/office)
- is_default

### Cart Items Table
- id (PK)
- user_id (FK)
- product_id (FK)
- quantity
- size

### Bookings Table
- id (PK)
- user_id (FK)
- sport
- venue_name
- venue_address
- date
- start_time
- end_time
- duration
- price
- status (enum: pending/confirmed/cancelled/completed)
- created_at
- updated_at

### Wallets Table
- id (PK)
- user_id (FK, unique)
- balance
- created_at
- updated_at

### Transactions Table
- id (PK)
- wallet_id (FK)
- amount
- type (enum: credit/debit)
- status (enum: pending/success/failed)
- description
- reference_id
- created_at

## Development

### Running Tests
```bash
# TODO: Add tests
pytest
```

### Database Migrations
For production, consider using Alembic for database migrations:
```bash
pip install alembic
alembic init migrations
```

## Production Deployment

1. Update `SECRET_KEY` in settings
2. Set proper CORS origins in `app/core/config.py`
3. Use environment variables for sensitive data
4. Set up proper PostgreSQL user permissions
5. Use a production WSGI server like Gunicorn:
   ```bash
   pip install gunicorn
   gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker
   ```

## Connecting from Flutter App

Update your Flutter app's API base URL to point to this server:

```dart
final String apiBaseUrl = 'http://localhost:8000/api/v1';
// or for production
final String apiBaseUrl = 'https://your-domain.com/api/v1';
```

## License

MIT
