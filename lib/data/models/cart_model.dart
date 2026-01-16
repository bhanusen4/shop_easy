import 'product_model.dart';

class CartModel {
  final ProductModel product;
  int qty;

  CartModel({required this.product, this.qty = 1});

  double get total => product.price * qty;
}
