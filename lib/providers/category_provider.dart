import 'package:flutter/material.dart';
import '../data/services/api_service.dart';

class CategoryProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<String> _categories = [];
  List<String> get categories =>_categories;
  bool loading = false;

  Future<void> loadCategories() async {
    loading = true;
    notifyListeners();

    _categories = await _api.fetchCategories();
    _categories.insert(0,'All');

    loading = false;
    notifyListeners();
  }
}
