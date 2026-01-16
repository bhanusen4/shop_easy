import 'package:flutter/material.dart';
import '../data/services/api_service.dart';

class CategoryProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<String> categories = [];
  bool loading = false;

  Future<void> loadCategories() async {
    loading = true;
    notifyListeners();

    categories = await _api.fetchCategories();

    loading = false;
    notifyListeners();
  }
}
