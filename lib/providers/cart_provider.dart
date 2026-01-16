import 'package:flutter/material.dart';

import '../data/models/cart_model.dart';
import '../data/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartModel> _items = {};

  List<CartModel> get items => _items.values.toList();

  double get total =>
      _items.values.fold(0, (sum, e) => sum + e.total);

  void addToCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.qty++;
    } else {
      _items[product.id] = CartModel(product: product);
    }
    notifyListeners();
  }

  void increment(int id) {
    _items[id]!.qty++;
    notifyListeners();
  }

  void decrement(int id) {
    if (_items[id]!.qty > 1) {
      _items[id]!.qty--;
    }
    notifyListeners();
  }

  void remove(int id) {
    _items.remove(id);
    notifyListeners();
  }
}
