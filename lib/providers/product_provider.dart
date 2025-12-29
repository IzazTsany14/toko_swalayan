import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/product_service.dart';
import '../services/database_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  List<Product> _filteredProducts = [];
  String _selectedCategoryId = '';
  String _searchQuery = '';

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  List<Product> get filteredProducts => _filteredProducts;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  ProductProvider() {
    initializeData();
  }

  Future<void> initializeData() async {
    await loadCategories();
    await loadProducts();
  }

  Future<void> loadCategories() async {
    _categories = DatabaseService.getCategories();
    if (_categories.isEmpty) {
      _categories = ProductService.getCategories();
      await DatabaseService.saveCategories(_categories);
    }
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _products = DatabaseService.getProducts();
    if (_products.isEmpty) {
      _products = ProductService.getDummyProducts();
      await DatabaseService.saveProducts(_products);
    }
    _filteredProducts = _products;
    notifyListeners();
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    _filterProducts();
    notifyListeners();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    _filterProducts();
    notifyListeners();
  }

  void _filterProducts() {
    _filteredProducts = _products.where((product) {
      bool matchesCategory = _selectedCategoryId.isEmpty ||
          product.categoryId == _selectedCategoryId;
      bool matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Product? getProduct(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> getPopularProducts({int limit = 6}) {
    return _products
        .where((p) => p.rating >= 4.5)
        .toList()
        .sublist(0, (limit < _products.length) ? limit : _products.length);
  }

  List<Product> getPromoProducts() {
    return _products.where((p) => p.isPromo).toList();
  }

  List<Product> getCategoryProducts(String categoryId) {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  Category? getCategory(String categoryId) {
    try {
      return _categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }
}