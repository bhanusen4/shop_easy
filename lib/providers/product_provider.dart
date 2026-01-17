import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../data/services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<ProductModel> products = [];
  bool loading = false;

  Future<void> loadProducts(String category) async {
    loading = true;
    notifyListeners();

    products = await _api.fetchProductsByCategory(category);

    loading = false;
    notifyListeners();
  }

  Future<void>getAllProducts() async {
    loading = true;
    notifyListeners();

    products = await _api.fetchAllProducts();

    loading = false;
    notifyListeners();
  }
  
}
