import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  CartProvider() {
    loadCart();
  }

  void loadCart() {
    _cartItems = DatabaseService.getCart();
    notifyListeners();
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final existingIndex =
        _cartItems.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
      await DatabaseService.updateCartItemQuantity(
        product.id,
        _cartItems[existingIndex].quantity,
      );
    } else {
      final cartItem = CartItem(
        productId: product.id,
        productName: product.name,
        imageUrl: product.imageUrl,
        price: product.price,
        quantity: quantity,
        promoPrice: product.isPromo ? product.promoPrice : null,
      );
      _cartItems.add(cartItem);
      await DatabaseService.addToCart(cartItem);
    }
    notifyListeners();
  }

  Future<void> removeFromCart(String productId) async {
    _cartItems.removeWhere((item) => item.productId == productId);
    await DatabaseService.removeFromCart(productId);
    notifyListeners();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _cartItems[index].quantity = quantity;
      await DatabaseService.updateCartItemQuantity(productId, quantity);
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await DatabaseService.clearCart();
    notifyListeners();
  }

  CartItem? getCartItem(String productId) {
    try {
      return _cartItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  bool hasItem(String productId) {
    return _cartItems.any((item) => item.productId == productId);
  }
}