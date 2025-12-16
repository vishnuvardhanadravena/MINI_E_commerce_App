import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mini_e_commerce/model/Product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];
  final List<Product> _cartProducts = [];
  final List<Map<String, dynamic>> _categories = [];

  bool _isLoading = false;

  List<Product> searchedProducts = [];
  List<Map<String, dynamic>> searchedCategories = [];

  List<Product> get products => _products;
  List<Product> get cartProducts => _cartProducts;
  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;

  void addToCart(Product product, String from) {
    print("------------ ADD TO CART CALLED ------------");
    print("FROM: $from");
    print("Incoming Quantity: ${product.quantity}");

    final index = _cartProducts.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      final existing = _cartProducts[index];

      final int qtyToAdd = from == 'cart' ? 1 : product.quantity!;

      print("Existing Qty: ${existing.quantity}");
      print("Qty To Add: $qtyToAdd");

      _cartProducts[index] = existing.copyWith(
        quantity: existing.quantity! + qtyToAdd,
      );
    } else {
      _cartProducts.add(
        product.copyWith(quantity: from == 'cart' ? 1 : product.quantity),
      );
    }

    notifyListeners();
  }

  void removeFromCart(Product product) {
    final index = _cartProducts.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      if ((_cartProducts[index].quantity ?? 1) > 1) {
        _cartProducts[index].quantity =
            (_cartProducts[index].quantity ?? 1) - 1;
      } else {
        _cartProducts.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartProducts.clear();
    notifyListeners();
  }

  int get totalCartItems =>
      _cartProducts.fold(0, (sum, p) => sum + (p.quantity ?? 1));
  double get totalPrice =>
      _cartProducts.fold(0, (sum, p) => sum + p.price * (p.quantity ?? 1));

  void search(String query) {
    if (query.length < 3) {
      clearSearch();
      return;
    }

    final q = query.toLowerCase();

    searchedProducts = _products
        .where((p) => p.title.toLowerCase().contains(q))
        .toList();

    searchedCategories = _categories
        .where((c) => c["label"].toLowerCase().contains(q))
        .toList();

    notifyListeners();
  }

  void clearSearch() {
    searchedProducts = [];
    searchedCategories = [];
    notifyListeners();
  }

  Future<void> fetchProductsByCategory(String category) async {
    if (category.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final res = await Dio().get(
        "https://fakestoreapi.com/products/category/$category",
      );

      _products
        ..clear()
        ..addAll((res.data as List).map((e) => Product.fromJson(e)).toList());
    } catch (e) {
      debugPrint("Fetch products error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await Dio().get(
        "https://fakestoreapi.com/products/categories",
      );

      _categories.clear();

      for (final cat in res.data) {
        _categories.add({"label": cat, "icon": _getCategoryIcon(cat)});
      }

      if (_categories.isNotEmpty) {
        await fetchProductsByCategory(_categories.first["label"]);
      }
    } catch (e) {
      debugPrint("Fetch categories error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case "electronics":
        return Icons.electrical_services;
      case "jewelery":
        return Icons.watch;
      case "men's clothing":
        return Icons.male;
      case "women's clothing":
        return Icons.female;
      default:
        return Icons.category;
    }
  }
}
