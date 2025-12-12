import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mini_e_commerce/model/Product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> cartproducts = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;

  void addToCart(Product product) {
    int index = cartproducts.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      cartproducts[index].quantity != null
          ? cartproducts[index].quantity = cartproducts[index].quantity! + 1
          : cartproducts[index].quantity = 1;
    } else {
      cartproducts.add(product);
    }

    notifyListeners();
  }

  void removeOne(Product product) {
    int index = cartproducts.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      if (cartproducts[index].quantity! > 1) {
        cartproducts[index].quantity != null
            ? cartproducts[index].quantity = cartproducts[index].quantity! - 1
            : cartproducts[index].quantity = 1;
      } else {
        cartproducts.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    cartproducts.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    cartproducts.clear();
    notifyListeners();
  }

  int get totalCartItems {
    int total = 0;
    for (var p in cartproducts) {
      total += p.quantity!;
    }
    return total;
  }

  double get totalPrice {
    double total = 0;
    for (var p in cartproducts) {
      total += p.price * p.quantity!;
    }
    return total;
  }

  Future<void> fetchProductsByCategory(String cat) async {
    if (cat.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    final url = "https://fakestoreapi.com/products/category/$cat";

    try {
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        _products = (response.data as List)
            .map((e) => Product.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    const url = "https://fakestoreapi.com/products/categories";

    _isLoading = true;
    notifyListeners();

    try {
      final res = await Dio().get(url);

      if (res.statusCode == 200) {
        List data = res.data;

        _categories = data.map((cat) {
          IconData icon;
          switch (cat) {
            case "electronics":
              icon = Icons.electrical_services;
              break;
            case "jewelery":
              icon = Icons.watch;
              break;
            case "men's clothing":
              icon = Icons.male;
              break;
            case "women's clothing":
              icon = Icons.female;
              break;
            default:
              icon = Icons.category;
          }

          return {"label": cat, "icon": icon};
        }).toList();

        if (_categories.isNotEmpty) {
          await fetchProductsByCategory(_categories[0]["label"]);
        }
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
