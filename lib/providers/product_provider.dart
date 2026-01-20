import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../data/services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<ProductModel> products = [];
  List<ProductModel> _allProducts = [];
  List<ProductModel> get allProducts => _allProducts;
  bool _loading = false;
  bool get loading => _loading;
  List<ProductModel> _masterList = []; // This stores the unfiltered category data
  bool _loadingAll = false;
  bool get loadingAll => _loadingAll;

  Future<void> loadProducts(String category) async {
    _loading = true;
    notifyListeners();


      if (category.toLowerCase() == 'all') {
        _masterList = await _api.fetchAllProducts();
      } else {
        _masterList = await _api.fetchProductsByCategory(category);
      }
      // Set the display list to the master list initially
      products = List.from(_masterList);
    _loading = false;
    notifyListeners();
  }

  Future<void>getAllProducts() async {
    _loadingAll = true;
    notifyListeners();
    _allProducts.clear();
    _allProducts = await _api.fetchAllProducts();

    _loadingAll = false;
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
       products = List.from(_masterList);
    } else {
      // Filter from the master list so we don't lose items on backspace
      products = _masterList
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
  
}
