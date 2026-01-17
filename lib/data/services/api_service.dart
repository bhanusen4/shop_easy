import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/product_model.dart';

class ApiService {
  Future<List<String>> fetchCategories() async {
    final res = await http.get(Uri.parse(ApiConstants.categories));
    return List<String>.from(jsonDecode(res.body));
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    final res = await http.get(
      Uri.parse("${ApiConstants.products}/category/$category"),
    );
    final data = jsonDecode(res.body) as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    final res = await http.get(
      Uri.parse(ApiConstants.products),
    );
    final data = jsonDecode(res.body) as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<ProductModel> fetchProduct(int id) async {
    final res = await http.get(
      Uri.parse("${ApiConstants.products}/$id"),
    );
    return ProductModel.fromJson(jsonDecode(res.body));
  }
}
