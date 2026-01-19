import 'package:flutter/material.dart';

import '../data/models/cart_model.dart';
import '../data/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartModel> _items = {};

  List<CartModel> get items => _items.values.toList();

  double get total =>
      _items.values.fold(0, (sum, e) => sum + e.total);

  int getQty(int productId) {
    return _items[productId]?.qty ?? 0;
  }

  void addToCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.qty++;
    } else {
      _items[product.id] = CartModel(product: product, qty: 1);
    }
    notifyListeners();
  }

  void increment(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.qty++;
      notifyListeners();
    }
  }

  void decrement(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.qty > 1) {
      _items[productId]!.qty--;
    } else {
      _items.remove(productId); // remove if qty == 1
    }
    notifyListeners();
  }


  void remove(int id) {
    _items.remove(id);
    notifyListeners();
  }

}
