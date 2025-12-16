// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:mini_e_commerce/model/Product.dart';

// class ProductProvider extends ChangeNotifier {
//   List<Product> _products = [];
//   List<Product> cartproducts = [];
//   List<Map<String, dynamic>> _categories = [];
//   bool _isLoading = false;

//   List<Product> get products => _products;
//   List<Map<String, dynamic>> get categories => _categories;
//   bool get isLoading => _isLoading;
//     List<dynamic> searchedCategories = [];
//   List<Product> searchedProducts = [];

//   void addToCart(Product product) {
//     print("Adding product to cart: ${product.id} - ${product.title}");

//     int index = cartproducts.indexWhere((item) => item.id == product.id);
//     print("Index in cart: $index");

//     if (index != -1) {
//       if (cartproducts[index].quantity != null) {
//         cartproducts[index].quantity =
//             cartproducts[index].quantity! + product.quantity!;
//         print(
//           "Product already in cart. Increased quantity to ${cartproducts[index].quantity}",
//         );
//       } else {
//         cartproducts[index].quantity = 1;
//         print("Product already in cart. Quantity was null, set to 1");
//       }
//     } else {
//       cartproducts.add(product);
//       print("Product added to cart for the first time.");
//     }

//     print(
//       "Current cart: ${cartproducts.map((p) => '${p.title} x${p.quantity}').toList()}",
//     );

//     notifyListeners();
//     print("Listeners notified.");
//   }

//   void removeOne(Product product) {
//     int index = cartproducts.indexWhere((item) => item.id == product.id);

//     if (index != -1) {
//       if (cartproducts[index].quantity! > 1) {
//         cartproducts[index].quantity != null
//             ? cartproducts[index].quantity = cartproducts[index].quantity! - 1
//             : cartproducts[index].quantity = 1;
//       } else {
//         cartproducts.removeAt(index);
//       }
//       notifyListeners();
//     }
//   }

//   void removeFromCart(Product product) {
//     cartproducts.removeWhere((item) => item.id == product.id);
//     notifyListeners();
//   }

//   void clearCart() {
//     cartproducts.clear();
//     notifyListeners();
//   }
//  bool isLoading = false;

//   List<dynamic> categories = [];
//   List<Product> products = [];

//   // 🔍 Search results
//   List<dynamic> searchedCategories = [];
//   List<Product> searchedProducts = [];

//   void search(String query) {
//     if (query.length < 4) {
//       searchedCategories = [];
//       searchedProducts = [];
//       notifyListeners();
//       return;
//     }

//     final q = query.toLowerCase();

//     searchedCategories = categories
//         .where((c) => c["label"].toLowerCase().contains(q))
//         .toList();

//     searchedProducts = products
//         .where((p) => p.title.toLowerCase().contains(q))
//         .toList();

//     notifyListeners();
//   }

//   void clearSearch() {
//     searchedCategories = [];
//     searchedProducts = [];
//     notifyListeners();
//   }

//   int get totalCartItems {
//     int total = 0;
//     for (var p in cartproducts) {
//       total += p.quantity!;
//     }
//     return total;
//   }

//   double get totalPrice {
//     double total = 0;
//     for (var p in cartproducts) {
//       total += p.price * p.quantity!;
//     }
//     return total;
//   }

//   Future<void> fetchProductsByCategory(String cat) async {
//     if (cat.isEmpty) return;

//     _isLoading = true;
//     notifyListeners();

//     final url = "https://fakestoreapi.com/products/category/$cat";

//     try {
//       final response = await Dio().get(url);

//       if (response.statusCode == 200) {
//         _products = (response.data as List)
//             .map((e) => Product.fromJson(e))
//             .toList();
//       }
//     } catch (e) {
//       debugPrint("Error fetching products: $e");
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> fetchCategories() async {
//     const url = "https://fakestoreapi.com/products/categories";

//     _isLoading = true;
//     notifyListeners();

//     try {
//       final res = await Dio().get(url);

//       if (res.statusCode == 200) {
//         List data = res.data;

//         _categories = data.map((cat) {
//           IconData icon;
//           switch (cat) {
//             case "electronics":
//               icon = Icons.electrical_services;
//               break;
//             case "jewelery":
//               icon = Icons.watch;
//               break;
//             case "men's clothing":
//               icon = Icons.male;
//               break;
//             case "women's clothing":
//               icon = Icons.female;
//               break;
//             default:
//               icon = Icons.category;
//           }

//           return {"label": cat, "icon": icon};
//         }).toList();

//         if (_categories.isNotEmpty) {
//           await fetchProductsByCategory(_categories[0]["label"]);
//         }
//       }
//     } catch (e) {
//       debugPrint("Error fetching categories: $e");
//     }

//     _isLoading = false;
//     notifyListeners();
//   }
// }

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

  void addToCart(Product product) {
    final index = _cartProducts.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      _cartProducts[index].quantity = (_cartProducts[index].quantity ?? 1) + 1;
    } else {
      product.quantity = 1;
      _cartProducts.add(product);
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
