"""
Seed Data Script for BMS Backend
Populates the database with sample data for testing and development
"""
import uuid
from datetime import datetime, timedelta
from app.core.database import SessionLocal
from app.models import (
    User, Product, Address, AddressType, CartItem,
    Booking, BookingStatus, Wallet, Transaction,
    TransactionType, TransactionStatus, Venue,
    Game, GameType, GameStatus, SkillLevel,
    Reel, ReelLike, ReelComment
)


def clear_database(db):
    """Clear all existing data from the database"""
    print("Clearing existing data...")
    try:
        db.query(ReelComment).delete()
        db.query(ReelLike).delete()
        db.query(Reel).delete()
        db.query(Game).delete()
        db.query(Venue).delete()
        db.query(Transaction).delete()
        db.query(Wallet).delete()
        db.query(Booking).delete()
        db.query(CartItem).delete()
        db.query(Address).delete()
        db.query(Product).delete()
        db.query(User).delete()
        db.commit()
        print("Database cleared successfully!")
    except Exception as e:
        print(f"Note: Some tables may be empty or not exist yet: {str(e)[:100]}")
        db.rollback()


def seed_users(db):
    """Seed sample users"""
    print("Seeding users...")
    users = [
        User(
            uid="user_001",
            email="john.doe@example.com",
            display_name="John Doe",
            name="John Doe",
            age=28,
            gender="male",
            sports=["Cricket", "Football", "Badminton"],
            interests=["Sports", "Fitness", "Travel"],
            auth_provider="email"
        ),
        User(
            uid="user_002",
            email="jane.smith@example.com",
            phone_number="+1234567890",
            display_name="Jane Smith",
            name="Jane Smith",
            age=25,
            gender="female",
            sports=["Tennis", "Badminton", "Swimming"],
            interests=["Sports", "Yoga", "Reading"],
            auth_provider="google"
        ),
        User(
            uid="user_003",
            phone_number="+9876543210",
            display_name="Mike Johnson",
            name="Mike Johnson",
            age=32,
            gender="male",
            sports=["Basketball", "Football"],
            interests=["Sports", "Gaming", "Music"],
            auth_provider="phone"
        ),
        User(
            uid="user_004",
            email="sarah.williams@example.com",
            display_name="Sarah Williams",
            name="Sarah Williams",
            age=27,
            gender="female",
            sports=["Yoga", "Running", "Cycling"],
            interests=["Fitness", "Health", "Nature"],
            auth_provider="email"
        ),
    ]

    for user in users:
        db.add(user)
    db.commit()
    print(f"Added {len(users)} users")
    return users


def seed_wallets(db, users):
    """Seed wallets for users"""
    print("Seeding wallets...")
    wallets = []
    for user in users:
        wallet = Wallet(
            id=str(uuid.uuid4()),
            user_id=user.uid,
            balance=1000.0 + (len(wallets) * 500)  # Varying balances
        )
        db.add(wallet)
        wallets.append(wallet)
    db.commit()
    print(f"Added {len(wallets)} wallets")
    return wallets


def seed_addresses(db, users):
    """Seed sample addresses"""
    print("Seeding addresses...")
    addresses = [
        Address(
            id=str(uuid.uuid4()),
            user_id=users[0].uid,
            name="John Doe",
            mobile="9876543210",
            pincode="560001",
            house_number="123",
            address="MG Road",
            locality="Central Business District",
            city="Bangalore",
            state="Karnataka",
            type=AddressType.home,
            is_default=True
        ),
        Address(
            id=str(uuid.uuid4()),
            user_id=users[0].uid,
            name="John Doe",
            mobile="9876543210",
            pincode="560037",
            house_number="456",
            address="Koramangala 4th Block",
            locality="Koramangala",
            city="Bangalore",
            state="Karnataka",
            type=AddressType.office,
            is_default=False
        ),
        Address(
            id=str(uuid.uuid4()),
            user_id=users[1].uid,
            name="Jane Smith",
            mobile="8765432109",
            pincode="560038",
            house_number="789",
            address="HSR Layout Sector 2",
            locality="HSR Layout",
            city="Bangalore",
            state="Karnataka",
            type=AddressType.home,
            is_default=True
        ),
    ]

    for address in addresses:
        db.add(address)
    db.commit()
    print(f"Added {len(addresses)} addresses")
    return addresses


def seed_products(db):
    """Seed sample products"""
    print("Seeding products...")
    products = [
        Product(
            id=str(uuid.uuid4()),
            name="Nike Dri-FIT Running Shirt",
            category="Sportswear",
            rating=4.5,
            reviews="245 reviews",
            mrp=2999,
            price=1999,
            image_url="product_images/nike_shirt.jpg",
            image_urls=["product_images/nike_shirt_1.jpg", "product_images/nike_shirt_2.jpg"],
            sizes=["S", "M", "L", "XL"],
            description="High-performance running shirt with moisture-wicking technology"
        ),
        Product(
            id=str(uuid.uuid4()),
            name="Adidas Training Shorts",
            category="Sportswear",
            rating=4.3,
            reviews="189 reviews",
            mrp=1899,
            price=1299,
            image_url="product_images/adidas_shorts.jpg",
            sizes=["M", "L", "XL"],
            description="Comfortable training shorts with side pockets"
        ),
        Product(
            id=str(uuid.uuid4()),
            name="Yonex Badminton Racket",
            category="Sports Equipment",
            rating=4.7,
            reviews="312 reviews",
            mrp=8999,
            price=6499,
            image_url="product_images/yonex_racket.jpg",
            sizes=["Standard"],
            description="Professional grade badminton racket for intermediate to advanced players"
        ),
        Product(
            id=str(uuid.uuid4()),
            name="Wilson Tennis Ball Pack",
            category="Sports Equipment",
            rating=4.6,
            reviews="156 reviews",
            mrp=899,
            price=699,
            image_url="product_images/tennis_balls.jpg",
            sizes=["Pack of 3", "Pack of 6"],
            description="High-quality tennis balls for practice and matches"
        ),
        Product(
            id=str(uuid.uuid4()),
            name="Puma Sports Shoes",
            category="Footwear",
            rating=4.4,
            reviews="423 reviews",
            mrp=5999,
            price=3999,
            image_url="product_images/puma_shoes.jpg",
            sizes=["7", "8", "9", "10", "11"],
            description="Versatile sports shoes for running and training"
        ),
    ]

    for product in products:
        db.add(product)
    db.commit()
    print(f"Added {len(products)} products")
    return products


def seed_cart_items(db, users, products):
    """Seed sample cart items"""
    print("Seeding cart items...")
    cart_items = [
        CartItem(
            id=str(uuid.uuid4()),
            user_id=users[0].uid,
            product_id=products[0].id,
            quantity=2,
            size="L"
        ),
        CartItem(
            id=str(uuid.uuid4()),
            user_id=users[0].uid,
            product_id=products[2].id,
            quantity=1,
            size="Standard"
        ),
        CartItem(
            id=str(uuid.uuid4()),
            user_id=users[1].uid,
            product_id=products[4].id,
            quantity=1,
            size="8"
        ),
    ]

    for item in cart_items:
        db.add(item)
    db.commit()
    print(f"Added {len(cart_items)} cart items")
    return cart_items


def seed_venues(db):
    """Seed sample venues"""
    print("Seeding venues...")
    venues = [
        Venue(
            id=str(uuid.uuid4()),
            name="PlayArena Sports Complex",
            description="Premium sports facility with multiple courts and world-class amenities",
            address="123 Stadium Road",
            city="Bangalore",
            state="Karnataka",
            pincode="560001",
            latitude=12.9716,
            longitude=77.5946,
            image_urls=["venue_images/playarena_1.jpg", "venue_images/playarena_2.jpg"],
            thumbnail_url="venue_images/playarena_thumb.jpg",
            sports_available=["Cricket", "Football", "Badminton", "Tennis"],
            amenities=["Parking", "Changing Rooms", "Cafeteria", "First Aid"],
            price_per_hour=1500.0,
            rating=4.7,
            total_reviews=245,
            opening_time="06:00",
            closing_time="23:00",
            total_courts=6,
            contact_phone="+919876543210",
            contact_email="info@playarena.com"
        ),
        Venue(
            id=str(uuid.uuid4()),
            name="Urban Sports Hub",
            description="Modern indoor sports facility in the heart of the city",
            address="456 MG Road",
            city="Bangalore",
            state="Karnataka",
            pincode="560025",
            latitude=12.9760,
            longitude=77.6068,
            image_urls=["venue_images/urban_hub_1.jpg"],
            thumbnail_url="venue_images/urban_hub_thumb.jpg",
            sports_available=["Badminton", "Table Tennis", "Squash"],
            amenities=["Air Conditioning", "Parking", "Locker Rooms", "WiFi"],
            price_per_hour=1200.0,
            rating=4.5,
            total_reviews=189,
            opening_time="07:00",
            closing_time="22:00",
            total_courts=4,
            contact_phone="+919876543211",
            contact_email="contact@urbanhub.com"
        ),
        Venue(
            id=str(uuid.uuid4()),
            name="Green Field Cricket Ground",
            description="Professional cricket ground with excellent pitch conditions",
            address="789 Sports Avenue",
            city="Bangalore",
            state="Karnataka",
            pincode="560037",
            latitude=12.9141,
            longitude=77.6411,
            image_urls=["venue_images/greenfield_1.jpg", "venue_images/greenfield_2.jpg"],
            thumbnail_url="venue_images/greenfield_thumb.jpg",
            sports_available=["Cricket"],
            amenities=["Parking", "Pavilion", "Scoreboard", "Floodlights"],
            price_per_hour=2000.0,
            rating=4.8,
            total_reviews=312,
            opening_time="06:00",
            closing_time="21:00",
            total_courts=2,
            contact_phone="+919876543212",
            contact_email="bookings@greenfield.com"
        ),
    ]

    for venue in venues:
        db.add(venue)
    db.commit()
    print(f"Added {len(venues)} venues")
    return venues


def seed_bookings(db, users, venues):
    """Seed sample bookings"""
    print("Seeding bookings...")
    now = datetime.utcnow()
    bookings = [
        Booking(
            id=str(uuid.uuid4()),
            user_id=users[0].uid,
            sport="Cricket",
            venue_name=venues[0].name,
            venue_address=venues[0].address,
            venue_image_url=venues[0].thumbnail_url,
            date=now + timedelta(days=1),
            start_time="10:00",
            end_time="12:00",
            duration=120,
            price=3000.0,
            status=BookingStatus.confirmed
        ),
        Booking(
            id=str(uuid.uuid4()),
            user_id=users[0].uid,
            sport="Badminton",
            venue_name=venues[1].name,
            venue_address=venues[1].address,
            venue_image_url=venues[1].thumbnail_url,
            date=now + timedelta(days=3),
            start_time="18:00",
            end_time="19:00",
            duration=60,
            price=1200.0,
            status=BookingStatus.pending
        ),
        Booking(
            id=str(uuid.uuid4()),
            user_id=users[1].uid,
            sport="Tennis",
            venue_name=venues[0].name,
            venue_address=venues[0].address,
            venue_image_url=venues[0].thumbnail_url,
            date=now - timedelta(days=2),
            start_time="16:00",
            end_time="17:00",
            duration=60,
            price=1500.0,
            status=BookingStatus.completed
        ),
    ]

    for booking in bookings:
        db.add(booking)
    db.commit()
    print(f"Added {len(bookings)} bookings")
    return bookings


def seed_transactions(db, wallets):
    """Seed sample transactions"""
    print("Seeding transactions...")
    transactions = [
        Transaction(
            id=str(uuid.uuid4()),
            wallet_id=wallets[0].id,
            amount=500.0,
            type=TransactionType.credit,
            status=TransactionStatus.success,
            description="Welcome bonus",
            reference_id="WELCOME_BONUS_001"
        ),
        Transaction(
            id=str(uuid.uuid4()),
            wallet_id=wallets[0].id,
            amount=1500.0,
            type=TransactionType.debit,
            status=TransactionStatus.success,
            description="Booking payment for PlayArena",
            reference_id="BOOKING_001"
        ),
        Transaction(
            id=str(uuid.uuid4()),
            wallet_id=wallets[1].id,
            amount=1000.0,
            type=TransactionType.credit,
            status=TransactionStatus.success,
            description="Wallet top-up",
            reference_id="TOPUP_001"
        ),
    ]

    for transaction in transactions:
        db.add(transaction)
    db.commit()
    print(f"Added {len(transactions)} transactions")
    return transactions


def seed_games(db, users, venues):
    """Seed sample games"""
    print("Seeding games...")
    now = datetime.utcnow()
    games = [
        Game(
            id=str(uuid.uuid4()),
            host_id=users[0].uid,
            venue_id=venues[0].id,
            sport="Cricket",
            title="Sunday Morning Cricket Match",
            description="Looking for players for a friendly cricket match",
            date=now + timedelta(days=7),
            start_time="08:00",
            end_time="10:00",
            duration=120,
            min_players=11,
            max_players=22,
            current_players=5,
            player_ids=[users[0].uid, users[1].uid, users[2].uid],
            game_type=GameType.public,
            skill_level=SkillLevel.intermediate,
            gender_preference="mixed",
            age_group="18-35",
            price_per_person=150.0,
            total_cost=3000.0,
            split_cost=True,
            status=GameStatus.upcoming,
            rules="Bring your own equipment. Fair play expected.",
            required_equipment=["Cricket bat", "Pads", "Helmet"]
        ),
        Game(
            id=str(uuid.uuid4()),
            host_id=users[1].uid,
            venue_id=venues[1].id,
            sport="Badminton",
            title="Evening Badminton Session",
            description="Casual badminton for beginners and intermediate players",
            date=now + timedelta(days=2),
            start_time="18:00",
            end_time="19:00",
            duration=60,
            min_players=2,
            max_players=4,
            current_players=4,
            player_ids=[users[1].uid, users[2].uid, users[3].uid],
            game_type=GameType.public,
            skill_level=SkillLevel.beginner,
            price_per_person=300.0,
            total_cost=1200.0,
            split_cost=True,
            status=GameStatus.full
        ),
        Game(
            id=str(uuid.uuid4()),
            host_id=users[2].uid,
            venue_id=venues[0].id,
            sport="Football",
            title="Weekend Football Tournament",
            description="5v5 football tournament with prizes",
            date=now + timedelta(days=14),
            start_time="16:00",
            end_time="18:00",
            duration=120,
            min_players=10,
            max_players=20,
            current_players=8,
            player_ids=[users[2].uid, users[3].uid],
            game_type=GameType.tournament,
            skill_level=SkillLevel.advanced,
            price_per_person=200.0,
            total_cost=3000.0,
            split_cost=True,
            status=GameStatus.upcoming,
            required_equipment=["Football boots", "Shin guards"]
        ),
    ]

    for game in games:
        db.add(game)
    db.commit()
    print(f"Added {len(games)} games")
    return games


def seed_reels(db, users):
    """Seed sample reels"""
    print("Seeding reels...")
    reels = [
        Reel(
            id=str(uuid.uuid4()),
            user_id=users[0].uid,
            video_url="reels/cricket_shot_001.mp4",
            thumbnail_url="reels/thumbnails/cricket_shot_001.jpg",
            caption="Perfect cover drive! 🏏 #Cricket #Sports",
            sport="Cricket",
            location="PlayArena Sports Complex",
            duration=15,
            width=1080,
            height=1920,
            file_size=5242880,  # 5MB
            views_count=1234,
            likes_count=145,
            comments_count=23,
            shares_count=12,
            hashtags=["Cricket", "Sports", "CoverDrive"],
            tagged_users=[users[1].uid],
            is_public=True
        ),
        Reel(
            id=str(uuid.uuid4()),
            user_id=users[1].uid,
            video_url="reels/badminton_smash_001.mp4",
            thumbnail_url="reels/thumbnails/badminton_smash_001.jpg",
            caption="Smash it! 🏸 #Badminton #PowerSmash",
            sport="Badminton",
            location="Urban Sports Hub",
            duration=12,
            width=1080,
            height=1920,
            file_size=4194304,  # 4MB
            views_count=892,
            likes_count=98,
            comments_count=15,
            shares_count=8,
            hashtags=["Badminton", "Smash", "Sports"],
            is_public=True
        ),
        Reel(
            id=str(uuid.uuid4()),
            user_id=users[2].uid,
            video_url="reels/football_goal_001.mp4",
            thumbnail_url="reels/thumbnails/football_goal_001.jpg",
            caption="What a goal! ⚽ #Football #Goal #Amazing",
            sport="Football",
            duration=18,
            width=1080,
            height=1920,
            file_size=6291456,  # 6MB
            views_count=2345,
            likes_count=267,
            comments_count=45,
            shares_count=34,
            hashtags=["Football", "Goal", "Sports", "Amazing"],
            tagged_users=[users[3].uid],
            is_public=True
        ),
    ]

    for reel in reels:
        db.add(reel)
    db.commit()
    print(f"Added {len(reels)} reels")
    return reels


def seed_reel_likes_and_comments(db, users, reels):
    """Seed sample reel likes and comments"""
    print("Seeding reel likes and comments...")

    # Likes
    likes = [
        ReelLike(id=str(uuid.uuid4()), reel_id=reels[0].id, user_id=users[1].uid),
        ReelLike(id=str(uuid.uuid4()), reel_id=reels[0].id, user_id=users[2].uid),
        ReelLike(id=str(uuid.uuid4()), reel_id=reels[1].id, user_id=users[0].uid),
        ReelLike(id=str(uuid.uuid4()), reel_id=reels[2].id, user_id=users[0].uid),
        ReelLike(id=str(uuid.uuid4()), reel_id=reels[2].id, user_id=users[1].uid),
    ]

    for like in likes:
        db.add(like)

    # Comments
    comments = [
        ReelComment(
            id=str(uuid.uuid4()),
            reel_id=reels[0].id,
            user_id=users[1].uid,
            text="Amazing shot! 👏",
            likes_count=5
        ),
        ReelComment(
            id=str(uuid.uuid4()),
            reel_id=reels[0].id,
            user_id=users[2].uid,
            text="Teach me that technique!",
            likes_count=3
        ),
        ReelComment(
            id=str(uuid.uuid4()),
            reel_id=reels[1].id,
            user_id=users[0].uid,
            text="Perfect form! 💪",
            likes_count=2
        ),
        ReelComment(
            id=str(uuid.uuid4()),
            reel_id=reels[2].id,
            user_id=users[1].uid,
            text="What a goal! Unbelievable! 🔥",
            likes_count=8
        ),
    ]

    for comment in comments:
        db.add(comment)

    db.commit()
    print(f"Added {len(likes)} likes and {len(comments)} comments")


def main():
    """Main function to seed all data"""
    print("="*50)
    print("Starting Database Seeding Process")
    print("="*50)

    db = SessionLocal()
    try:
        # Clear existing data
        clear_database(db)

        # Seed data in order (respecting foreign key constraints)
        users = seed_users(db)
        wallets = seed_wallets(db, users)
        addresses = seed_addresses(db, users)
        products = seed_products(db)
        cart_items = seed_cart_items(db, users, products)
        venues = seed_venues(db)
        bookings = seed_bookings(db, users, venues)
        transactions = seed_transactions(db, wallets)
        games = seed_games(db, users, venues)
        reels = seed_reels(db, users)
        seed_reel_likes_and_comments(db, users, reels)

        print("="*50)
        print("Database seeding completed successfully!")
        print("="*50)
        print("\nSummary:")
        print(f"  Users: {len(users)}")
        print(f"  Wallets: {len(wallets)}")
        print(f"  Addresses: {len(addresses)}")
        print(f"  Products: {len(products)}")
        print(f"  Cart Items: {len(cart_items)}")
        print(f"  Venues: {len(venues)}")
        print(f"  Bookings: {len(bookings)}")
        print(f"  Transactions: {len(transactions)}")
        print(f"  Games: {len(games)}")
        print(f"  Reels: {len(reels)}")
        print("\nYou can now test the API with this sample data!")

    except Exception as e:
        print(f"Error during seeding: {e}")
        db.rollback()
        raise
    finally:
        db.close()


if __name__ == "__main__":
    main()
