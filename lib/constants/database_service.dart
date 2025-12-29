import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class DatabaseService {
  static const String _productsBox = 'products';
  static const String _categoriesBox = 'categories';
  static const String _cartBox = 'cart';
  static const String _ordersBox = 'orders';
  static const String _settingsBox = 'settings';

  static Future<void> initDatabase() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(CartItemAdapter());
    Hive.registerAdapter(OrderAdapter());

    await Hive.openBox<Product>(_productsBox);
    await Hive.openBox<Category>(_categoriesBox);
    await Hive.openBox<CartItem>(_cartBox);
    await Hive.openBox<Order>(_ordersBox);
    await Hive.openBox<dynamic>(_settingsBox);
  }

  // Products
  static Future<void> saveProducts(List<Product> products) async {
    final box = Hive.box<Product>(_productsBox);
    await box.clear();
    for (var product in products) {
      await box.put(product.id, product);
    }
  }

  static List<Product> getProducts() {
    final box = Hive.box<Product>(_productsBox);
    return box.values.toList();
  }

  static Product? getProduct(String id) {
    final box = Hive.box<Product>(_productsBox);
    return box.get(id);
  }

  // Categories
  static Future<void> saveCategories(List<Category> categories) async {
    final box = Hive.box<Category>(_categoriesBox);
    await box.clear();
    for (var category in categories) {
      await box.put(category.id, category);
    }
  }

  static List<Category> getCategories() {
    final box = Hive.box<Category>(_categoriesBox);
    return box.values.toList();
  }

  // Cart
  static Future<void> addToCart(CartItem item) async {
    final box = Hive.box<CartItem>(_cartBox);
    final existing = box.get(item.productId);
    
    if (existing != null) {
      existing.quantity += item.quantity;
      await existing.save();
    } else {
      await box.put(item.productId, item);
    }
  }

  static Future<void> removeFromCart(String productId) async {
    final box = Hive.box<CartItem>(_cartBox);
    await box.delete(productId);
  }

  static List<CartItem> getCart() {
    final box = Hive.box<CartItem>(_cartBox);
    return box.values.toList();
  }

  static Future<void> clearCart() async {
    final box = Hive.box<CartItem>(_cartBox);
    await box.clear();
  }

  static Future<void> updateCartItemQuantity(
    String productId,
    int quantity,
  ) async {
    final box = Hive.box<CartItem>(_cartBox);
    final item = box.get(productId);
    if (item != null) {
      item.quantity = quantity;
      await item.save();
    }
  }

  // Orders
  static Future<void> saveOrder(Order order) async {
    final box = Hive.box<Order>(_ordersBox);
    await box.put(order.id, order);
  }

  static List<Order> getOrders() {
    final box = Hive.box<Order>(_ordersBox);
    return box.values.toList()..sort((a, b) => b.orderDate.compareTo(a.orderDate));
  }

  // Settings
  static bool isDarkMode() {
    final box = Hive.box<dynamic>(_settingsBox);
    return box.get('darkMode', defaultValue: false);
  }

  static Future<void> setDarkMode(bool value) async {
    final box = Hive.box<dynamic>(_settingsBox);
    await box.put('darkMode', value);
  }
}