# Quick Start Guide

## Database Setup Complete!

Your PostgreSQL database has been configured with:
- **Database Name**: `owlturf`
- **Username**: `owlturf_user`
- **Password**: `SaaVik@dev`

## What's Been Created

All database tables have been created successfully:
- `users` - User profiles with sports interests
- `products` - E-commerce product catalog
- `addresses` - User delivery addresses
- `cart_items` - Shopping cart
- `bookings` - Sports venue bookings
- `wallets` - Digital wallets
- `transactions` - Transaction history

## Starting the Server

### Option 1: Quick Start Script
```bash
cd /Users/shivasanthosh/Desktop/bms/backend
./run.sh
```

### Option 2: Manual Start
```bash
cd /Users/shivasanthosh/Desktop/bms/backend
source venv/bin/activate
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## Server is Currently Running!

The FastAPI server is already running and accessible at:
- **API**: http://localhost:8000
- **Interactive Docs**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Testing the API

Try these commands:
```bash
# Health check
curl http://localhost:8000/health

# Root endpoint
curl http://localhost:8000/

# Create a user
curl -X POST http://localhost:8000/api/v1/users/ \
  -H "Content-Type: application/json" \
  -d '{
    "uid": "user123",
    "email": "test@example.com",
    "name": "Test User",
    "age": 25,
    "gender": "male",
    "sports": ["cricket", "football"]
  }'

# Get all products
curl http://localhost:8000/api/v1/products/
```

## Available API Endpoints

All endpoints are under `/api/v1`:

### Users
- `POST /users/` - Create user
- `GET /users/{user_id}` - Get user
- `PUT /users/{user_id}` - Update user
- `DELETE /users/{user_id}` - Delete user

### Products
- `POST /products/` - Create product
- `GET /products/` - List products (supports ?category=)
- `GET /products/{product_id}` - Get product
- `PUT /products/{product_id}` - Update product

### Addresses
- `POST /addresses/{user_id}` - Add address
- `GET /addresses/{user_id}` - List user addresses

### Cart
- `POST /cart/{user_id}` - Add to cart
- `GET /cart/{user_id}` - Get cart
- `DELETE /cart/{user_id}` - Clear cart

### Bookings
- `POST /bookings/{user_id}` - Create booking
- `GET /bookings/{user_id}` - List bookings

### Wallet
- `GET /wallet/{user_id}` - Get wallet
- `POST /wallet/{user_id}/transactions` - Create transaction
- `GET /wallet/{user_id}/transactions` - Transaction history

## PostgreSQL Management

### Connect to database
```bash
psql owlturf
```

### View tables
```sql
\dt
```

### View table structure
```sql
\d users
\d products
\d bookings
```

### Sample queries
```sql
-- View all users
SELECT * FROM users;

-- View all products
SELECT * FROM products;

-- Check wallet balances
SELECT u.email, w.balance
FROM users u
JOIN wallets w ON u.uid = w.user_id;
```

## Stopping the Server

Press `CTRL+C` in the terminal where the server is running.

## Restarting PostgreSQL

If you need to restart PostgreSQL:
```bash
brew services restart postgresql@15
```

## Connection String for Flutter App

Update your Flutter app to use:
```dart
final String apiBaseUrl = 'http://localhost:8000/api/v1';
// For iOS simulator use: http://127.0.0.1:8000/api/v1
// For Android emulator use: http://10.0.2.2:8000/api/v1
```

## Troubleshooting

### Database connection errors
```bash
# Check if PostgreSQL is running
brew services list | grep postgresql

# Restart PostgreSQL
brew services restart postgresql@15
```

### Port 8000 already in use
```bash
# Find and kill process using port 8000
lsof -ti:8000 | xargs kill -9
```

## Next Steps

1. Visit http://localhost:8000/docs to explore the interactive API documentation
2. Test the endpoints using the Swagger UI
3. Integrate the API with your Flutter app
4. Add authentication/authorization as needed
