import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class ECommerceService {
  static final ECommerceService _instance = ECommerceService._internal();
  factory ECommerceService() => _instance;
  ECommerceService._internal();

  // Mock data for demonstration
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Flying Machine Men classic checked TShirt',
      category: 'Sports Tshirt',
      rating: 4.2,
      reviews: '66K',
      mrp: 2999,
      price: 899,
      imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop',
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      description: '''Product Details

Classic Streetwear Graphic Tee

Level up your everyday fit with this premium cotton graphic tee. Designed for all-day comfort and effortless style, it features a relaxed unisex fit that pairs perfectly with jeans, cargos, or layered under a jacket. The bold print gives it a street-ready edge, while the breathable fabric keeps you cool no matter where the day takes you.

• Fabric: 100% soft cotton
• Fit: Relaxed, true to size
• Print: High-quality, fade-resistant graphic
• Care: Machine wash cold, tumble dry low

Your new go-to tee—comfortable enough for lounging, sharp enough for the streets.''',
    ),
    Product(
      id: '2',
      name: 'Performance Running Tee',
      category: 'Sports Tshirt',
      rating: 4.5,
      reviews: '45K',
      mrp: 1999,
      price: 599,
      imageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400&h=500&fit=crop',
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      description: 'High-performance athletic tee for your workout needs.',
    ),
  ];

  List<CartItem> _cartItems = [];

  // Product methods
  List<Product> getAllProducts() {
    return _products;
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    return _products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
             (product.category?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  // Cart methods
  List<CartItem> getCartItems() {
    return List.from(_cartItems);
  }

  void addToCart(Product product, {int quantity = 1}) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id && item.product.size == product.size,
    );

    if (existingItemIndex >= 0) {
      _cartItems[existingItemIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
  }

  void updateCartItemQuantity(String productId, String? size, int quantity) {
    final itemIndex = _cartItems.indexWhere(
      (item) => item.product.id == productId && item.product.size == size,
    );

    if (itemIndex >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(itemIndex);
      } else {
        _cartItems[itemIndex].quantity = quantity;
      }
    }
  }

  void removeFromCart(String productId, String? size) {
    _cartItems.removeWhere(
      (item) => item.product.id == productId && item.product.size == size,
    );
  }

  void clearCart() {
    _cartItems.clear();
  }

  // Cart calculations
  int getCartTotal() {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int getCartMRPTotal() {
    return _cartItems.fold(0, (sum, item) => sum + item.totalMRP);
  }

  int getCartDiscount() {
    return getCartMRPTotal() - getCartTotal();
  }

  int getCartItemCount() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  bool isCartEmpty() {
    return _cartItems.isEmpty;
  }

  // Order methods (for future implementation)
  Future<bool> placeOrder({
    required Map<String, dynamic> address,
    required String paymentMethod,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Clear cart after successful order
    clearCart();
    
    return true;
  }
}